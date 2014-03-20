#!/usr/bin/env bats

setup() {
  pushd ./scala-e2e
  sbt package
  popd

  pushd ../../datt-sampleapp
  sbt "run 8080"
  popd
}

@test "requests from same client are routed to a single server" {
  run bash -c "java -jar ./scala-e2e/target/scala-2.10/smartRouterTest.jar localhost:8080"

  echo "output: "$output
  echo "status: "$status
  [ "$status" -eq 0 ]
  [ "$output" -ne 0 ]
}
