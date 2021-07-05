#!/usr/bin/env bash
# ./benchmark.sh [option]
# Options:
#   --workload	N	run benchmark with N workloads (default: 3)

DIR=$(dirname $0)

# load env
# https://songmu.jp/riji/entry/2019-06-14-bash-dotenv.html
set -o allexport
source $DIR/.env
set +o allexport

if [ -z $TEAMNAME ]; then
    echo 'You need to specify team name'
    exit 1
fi

$DIR/bin/benchmarker -u $DIR/userdata -t http://$APP_IP/ "$@" | tee /dev/stderr | /opt/mackerel-agent/plugins/bin/mackerel-plugin-json -stdin -prefix $MACKEREL_SERVICE_METRIC_PREFIX -include score | sed "s/score/score-$TEAMNAME/" | mkr throw -s $MACKEREL_SERVICE
