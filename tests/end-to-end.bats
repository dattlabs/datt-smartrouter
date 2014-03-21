#!/usr/bin/env bats
load helpers

setup() {
  run_dir "./scala-e2e" "sbt package"
}

@test "requests from same client are routed to a single server" {
  run bash -c "./end-to-end.sh | tee output.txt"

  echo "output: "$output
  echo "status: "$status
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
