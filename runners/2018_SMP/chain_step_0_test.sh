#!/bin/sh
set -e
#set -x

SEED=$1
GRIDPACK=$2
EVENTS=$3
THREADS=$4

RUN_DIR=${PWD}

#== CMSSW: gridpack=zee_dim6_mll100-200
#== CMSSW: 1
#== CMSSW: events=1000

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



python ${RUN_DIR}/modifyCfg.py ${RUN_DIR}/SMP-RunIISummer20UL18wmLHEGEN-00061_1_cfg.py ${RUN_DIR}/step_0_cfg.py --randomSeeds=${SEED} --strategy=1

echo "PRINTING PWD chain, where FrameworkJobReport.xml will be"
pwd

cmsRun -e -j FrameworkJobReport.xml ${RUN_DIR}/step_0_cfg.py jobNum=$1 ${GRIDPACK} ${EVENTS} ${THREADS}
