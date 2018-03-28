#!/bin/bash

function start_profile(){
echo "start tCollector in dryrun mode"
cd ${RUNDIR}/tcollector/
mkdir logs
mkdir run
./tcollector.py -H spui.grid.sara.nl -p 4242  &
TCOLL_PID=$!
cd ${RUNDIR}

}

function stop_profile(){
echo "killing tcollector"
kill $TCOLL_PID


}
