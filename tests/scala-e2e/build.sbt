organization := "com.datt"

name := "smartrouter_test"

version := "0.1.0-SNAPSHOT"

scalacOptions := Seq("-unchecked", "-deprecation", "-encoding", "utf8")

resolvers ++= Seq(
  "spray repo" at "http://repo.spray.io"
)

seq(com.github.retronym.SbtOneJar.oneJarSettings: _*)

libraryDependencies ++= {
  val akkaV = "2.1.4"
  val sprayV = "1.1.1"
  Seq(
    "io.spray"          %   "spray-client"   % sprayV,
    "io.spray"          %%  "spray-json"     % "1.2.5",
    "com.typesafe.akka" %%  "akka-actor"     % akkaV,
    "org.scalatest"     %   "scalatest_2.10" % "2.0" % "test"
  )
}

