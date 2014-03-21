#!/bin/bash

# not building first. assuming that it's built.

docker run -i -t --rm -w "/files" --name "smartrouter" --hostname "smartrouter" datt/datt-smartrouter bash -c "supervisord; /bin/bash"
