#!/bin/bash

source build

docker run -i -t --rm -w "/files" --name "smartrouter" --hostname "smartrouter" datt/datt-smartrouter bash -c "supervisord; /bin/bash"
