
function setup_sara_dir(){

export PYTHONPATH=${PWD}:$PYTHONPATH
source /cvmfs/softdrive.nl/lofar_sw/env/current_dysco.sh 

cp *parset $1
cp -r  $PWD/prefactor/ $1
#TODO: Make this block just a git pull?
cp *py $1
mkdir $1/piechart
cp -r $PWD/piechart/* $1/piechart

cp srm.txt $1 #this is a fallthrough by taking the srm from the token not from the sandbox!

cp ${PARSET} $1
cp ${SCRIPT} $1
cp -r $PWD/tcollector $1
cp -r $PWD/ddf-pipeline $1
cp -r $PWD/skymodels $1
cp -r $PWD/tools $1
cp pipeline.cfg $1
cd ${RUNDIR}
touch pipeline_status

mkdir -p Input
mkdir -p Output
}

function setup_run_dir(){
 case "$( hostname -f )" in
    *sara*) export RUNDIR=`mktemp -d -p ${JOBDIR}`; setup_sara_dir ${RUNDIR} ;;
    *leiden*) setup_leiden_dir ;;
    node[0-9]*) export RUNDIR=`mktemp --directory --tmpdir=/data/lofar/grid_jobs`; setup_sara_dir ${RUNDIR} ;;
    *) echo "Can't find host in list of supported clusters"; exit 11;;
 esac
}

