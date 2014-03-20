
package com.datt.smartroutertest

import akka.actor.ActorSystem
import scala.concurrent.duration._
import akka.util.Timeout
import spray.can.Http
import akka.io.IO
import akka.pattern.ask
import spray.client.pipelining._
import spray.http._
import scala.concurrent.{Await, Future}
import spray.json._
import DefaultJsonProtocol._
import scala.collection.mutable
import spray.http.HttpRequest
import spray.http.HttpResponse
import spray.http.HttpHeaders.`Set-Cookie`

object Main {
  implicit val system = ActorSystem()
  import system.dispatcher // execution context for futures

  val timeoutDuration = 20.seconds

  val cookies = mutable.Map[Integer, List[HttpCookie]]().withDefaultValue(List())

  private def withCookies(client: Integer): HttpRequest => HttpRequest =
    if (cookies(client).size > 0) addHeader(HttpHeaders.Cookie(cookies(client))) else identity

  def extractCookies(res: HttpResponse) = res.headers.collect { case `Set-Cookie`(hc) => hc }
  private def storeCookies(client: Integer): Future[HttpResponse] => Future[HttpResponse] =
    (response) => for (res <- response) yield { cookies(client) = extractCookies(res); res }

  private def issueRequest(client: Integer, hostname: String, port: Integer, req: HttpRequest): Future[HttpResponse] = {
    implicit val timeout = Timeout.durationToTimeout(timeoutDuration)
    val connectedSendReceive = for {
      Http.HostConnectorInfo(connector, _) <-
        IO(Http) ? Http.HostConnectorSetup(hostname, port = port)
    } yield sendReceive(connector)

    val pipeline = for (sendRecv <- connectedSendReceive) yield
        addHeader("Accept", "application/json") ~>
        withCookies(client)                     ~>
        sendRecv                                ~>
        storeCookies(client)                    ~>
        unmarshal[HttpResponse]

    pipeline.flatMap(_(req))
  }

  private def getResponseJson(client: Integer, host: String, port: Integer, req: HttpRequest): JsValue = {
    val response = issueRequest(client, host, port, Get("/"))
    val res = Await.result(response, timeoutDuration)
    assert(res.status == StatusCode.int2StatusCode(200))
    res.entity.asString.asJson
  }

  def main(args: Array[String]): Unit = {
    val Array(host, portStr) = args.head.split(":")

    class RichJsVal(jsVal: JsValue) { def getField(key: String) = jsVal.asJsObject.fields(key) }
    implicit def richJsVal(jsVal: JsValue) = new RichJsVal(jsVal)

    val clients = 0 until 20
    clients.par.foreach { client =>
      val getServerIP = () =>
        getResponseJson(client, host, portStr.toInt, Get("/")).getField("IP").convertTo[String]
      val serverIP = getServerIP()
      for (req <- 0 until 100) assert(serverIP == getServerIP())
    }

    sys.exit(0)
  }
}
