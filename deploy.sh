#!/bin/bash

export PORT=5800
export MIX_ENV=prod
export GIT_PATH=/home/ontime/src/ontime

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "ontime" ]; then
	echo "Error: must run as user 'ontime'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)
mix phx.digest
MIX_ENV=prod mix ecto.migrate
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/ontime ]; then
	echo mv ~/www/ontime ~/old/$NOW
	mv ~/www/ontime ~/old/$NOW
fi

mkdir -p ~/www/ontime
REL_TAR=~/src/ontime/_build/prod/rel/ontime/releases/0.0.1/ontime.tar.gz
(cd ~/www/ontime && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/ontime/src/ontime/start.sh
CRONTAB

#. start.sh
