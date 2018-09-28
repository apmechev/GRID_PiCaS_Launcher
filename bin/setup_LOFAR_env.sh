#!/bin/bash

function setup_lofar_leiden(){
   source /net/para34/data1/oonk/lof_nov2016_2_19_0/lofim.sh
   module load lofargrid #gridtools
   echo "setup_env: Loaded LOFAR from /net/para34/data1/oonk/lof_nov2016_2_19_0/lofim.sh"
}

function setup_lofar_herts(){
  module load casa
  module load lofar
  source /soft/lofar-051116/lofarinit.sh
  export PYTHONPATH=/soft/pyrap:$PYTHONPATH
  echo "setup_env: Loaded LOFAR from /soft/lofar-051116/lofarinit.sh"
}


function setup_local_lofar(){
 case "$( hostname -f )" in
    *sara*) echo "setup_env: softdrive not found";exit 10;;
    *leiden*) setup_lofar_leiden ;;
    node[0-9]*) setup_lofar_herts;;
    *) echo "setup_env: Can't find host in list of supported clusters"; exit 11;; #exit 11=> unsupported cluster
 esac
}


function setup_softdrive_lofar(){
    export LD_LIBRARY_PATH=/cvmfs/softdrive.nl/apmechev/gcc-4.8.5/lib:/cvmfs/softdrive.nl/apmechev/gcc-4.8.5/lib64:$LD_LIBRARY_PATH
 if [ -z "$1" ]
  then
    echo "setup_env: Initializing default environment in /cvmfs/softdrive.nl/wjvriend/lofar_stack/2.16"
    . /cvmfs/softdrive.nl/wjvriend/lofar_stack/2.16/init_env_release.sh
    export PYTHONPATH=/cvmfs/softdrive.nl/wjvriend/lofar_stack/2.16/local/release/lib/python2.7/site-packages/losoto-1.0.0-py2.7.egg:/cvmfs/softdrive.nl/wjvriend/lofar_stack/2.16/local/release/lib/python2.7/site-packages/losoto-1.0.0-py2.7.egg/losoto:$PYTHONPATH
    export LOFAR_PATH=/cvmfs/softdrive.nl/wjvriend/lofar_stack/2.16/
  else
    if [ -e "$1/init_env_release.sh" ]; then
      echo "setup_env: Initializing environment from ${1}"
      . ${1}/init_env_release.sh
      export PYTHONPATH=${1}/local/release/lib/python2.7/site-packages/losoto-1.0.0-py2.7.egg:${1}/local/release/lib/python2.7/site-packages/losoto-1.0.0-py2.7.egg/losoto:$PYTHONPATH
      export LOFARDATAROOT=/cvmfs/softdrive.nl/wjvriend/data
#      export PYTHONHOME=${1}/local/release/lib/python2.7
      export LOFAR_PATH=${1}
    else
        echo "setup_env: The environment script doesn't exist. check the path $1/init_env_release.sh again"
        exit 12 #exit 12=> no init_env script
    fi
  fi
}

function setup_LOFAR_env(){

echo "INITIALIZE LOFAR SOFTWARE"  
 if [[ -n "$SIMG" ]]
 then
    echo "Skipping cvmfs software loading in lieu of singularity image at $SIMG"
    ls $SIMG
    return
 fi

 if [ ! -z $( echo $1 | grep cvmfs ) ]
  then
    if [ -d /cvmfs/softdrive.nl ]
     then
      echo "setup_enc: softdrive directory found"
      setup_softdrive_lofar $1
     else
      echo "setup_env: No Softdrive installation. Trying to source LOFAR otherwise"
      setup_local_lofar 

   fi
 fi

echo  "var LOFARDATAROOT: " ${LOFARDATAROOT}
echo  "setup" "adding symbolic link for EPHEMERIDES and GEODETIC data into homedir"
ln -sf ${LOFARDATAROOT} .
ln -sf ${LOFARDATAROOT} ~/
# NEW NB we can't assume the home dir is shared across all Grid nodes.

source /cvmfs/softdrive.nl/lofar_sw/env/current_losoto.sh
}



