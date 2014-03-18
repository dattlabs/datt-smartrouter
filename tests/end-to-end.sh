#!/usr/bin/env bats

@test "requests from same client are routed to a single server" {
  pushd ./scala-e2e
  sbt compile
  popd

  run bash -c "./scala-e2e/target/..." # TODO : fill out rest of path

  echo "output: "$output
  echo "status: "$status
  [ "$status" -eq 0 ]
  [ "$output" -ne 0 ]
}
