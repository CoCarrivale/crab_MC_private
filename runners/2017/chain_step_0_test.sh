#!/bin/sh
set -e
#set -x

SEED=$1
GRIDPACK=$2
EVENTS=$3
THREADS=$4

RUN_DIR=${PWD}
echo "ARGUMENTS IN ORDER"
echo ${SEED}
echo ${GRIDPACK}
echo ${EVENTS}
echo ${THREADS}
echo "------------"
echo ">> Setting RUN_DIR to ${RUN_DIR}"

CMSSW_RELEASE=CMSSW_10_6_19_patch3
SCRAM_ARCH=slc7_amd64_gcc700

if [ "${CMSSW_RELEASE}" != "local" ]; then
    if [ -d ${CMSSW_RELEASE} ]; then
      echo ">> Cleaning up existing ${CMSSW_RELEASE} directory"
      rm -r ${CMSSW_RELEASE}
    fi
    echo ">> Setting up release area for ${CMSSW_RELEASE} and arch ${SCRAM_ARCH}"
    if [ ! -d ${CMSSW_RELEASE} ]; then
      scram project CMSSW ${CMSSW_RELEASE}
    fi

    cd ${CMSSW_RELEASE}/src
    eval `scramv1 runtime -sh`
    cd -

fi


####   I am applying modifications to step 0 input
python ${RUN_DIR}/modifyCfg.py ${RUN_DIR}/HIG-RunIISummer20UL17wmLHEGEN-00212_1_cfg.py ${RUN_DIR}/step_0_cfg.py --randomSeeds=${SEED} --strategy=1
####   I am applying modifications and to step 0 input, in order not to have compilation errors
#python ${RUN_DIR}/modifyCfg.py ${RUN_DIR}/HIG-RunIISummer20UL17MiniAODv2-00357_1_cfg.py ${RUN_DIR}/step_4_cfg.py --randomSeeds=${SEED}

echo "PRINTING PWD chain, where FrameworkJobReport.xml will be"
pwd

cmsRun -e -j FrameworkJobReport.xml ${RUN_DIR}/step_0_cfg.py jobNum=$1 ${GRIDPACK} ${EVENTS} ${THREADS}

echo " STEP 0 COMPLETE! "