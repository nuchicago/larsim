#!/bin/bash

export MODE=$1
echo "setting up for MODE $MODE"
 
setup(){
    #. "/grid/fermiapp/products/minerva/etc/setups.sh"
    source /grid/fermiapp/products/larsoft/setup
    local TOP=${PWD}

    #setup -q debug -f Linux+2.6-2.5 root v5_30_00
    setup geant4 v4_10_1_p02 -q e7:prof
    setup boost v1_57_0 -q e7:prof
    setup root v5_34_21b -q e6:nu:prof
    setup dk2nu v01_01_03c -q e7:prof
    export M32=-m64
    export ARG=$1
    #echo $ARG "is ARG"
    setup fftw v3_3_4 -q prof
    #setup python v2_7_6
    # setup for jobsub client
    # according to the prescription in Mike Kirby's talk
    # minerva doc-10551, Dec 2014
    source /grid/fermiapp/products/common/etc/setups.sh
    #setup jobsub_client
    setup ifdhc
    if [ -z "${_CONDOR_SCRATCH_DIR}" ]; then	
    echo "_CONDOR_SCRATCH_DIR is not set... so I'm assuming we're not running on a grid node.... Setting up jobsub tools."	
    setup jobsub_tools	
    setup jobsub_client
    fi
    export BOOSTROOT=/grid/fermiapp/products/larsoft/boost/v1_57_0/source/boost_1_57_0
    # bash magic pulled off of stack exchange
    # gets the full path to the location of setup.sh
    export PPFX_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    echo "setting PPFX_DIR=${PPFX_DIR}"
    export LD_LIBRARY_PATH=$PPFX_DIR/lib:$LD_LIBRARY_PATH
    echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
}

HOST=$(hostname -f)
if [ "$MODE" = "REF" ] || [ "$MODE" = "OPT" ];then
if echo "$HOST" |grep 'dune';then
echo "Setting up for dune"
setup
fi
if echo "$HOST" |grep 'minerva';then
echo "This is minerva machine. Try setup.sh"
fi
else
echo "ARGS REF for reference and OPT for optimized"
fi
