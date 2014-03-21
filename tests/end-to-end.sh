#!/bin/bash

set -x

. ./helpers.bash

run_sbt='sbt "run 8080"'
run_dir_bkg "../../datt-sampleapp" "$run_sbt"

sleep 5

java -jar ./scala-e2e/target/scala-2.10/smartRouterTest.jar localhost:8080
exitCode=$?

kill -9 %+
exit $exitCode
