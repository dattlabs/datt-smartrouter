#!/usr/bin/env bats

@test "requests from same client are routed to a single server" {
  pushd ./scala-e2e
  sbt compile
  popd

  run bash -c "java -jar ./scala-e2e/target/scala-2.10/smartRouterTest.jar" # TODO pass hostnanme:port for nginx

  echo "output: "$output
  echo "status: "$status
  [ "$status" -eq 0 ]
  [ "$output" -ne 0 ]
}
