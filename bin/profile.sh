#!/bin/bash

function start_profile(){
echo "start tCollector in dryrun mode"
cd ${RUNDIR}/openTSDB_tcollector/
mkdir logs
./tcollector.py -H spui.grid.sara.nl -p 4242  &
TCOLL_PID=$!
cd ${RUNDIR}

}

function stop_profile(){
echo "killing tcollector"
kill $TCOLL_PID


}