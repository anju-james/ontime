#!/bin/bash

export PORT=5800

cd ~/www/ontime
./bin/ontime stop || true
./bin/ontime start
