#!/bin/sh
set -e
#set -x

SEED=$1

RUN_DIR=${PWD}
echo ">> Setting RUN_DIR to ${RUN_DIR}"

CMSSW_RELEASE=CMSSW_15_0_2
SCRAM_ARCH=el8_amd64_gcc12

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

python3 ${RUN_DIR}/modifyCfg.py ${RUN_DIR}/cfg_RunIII2024Summer24MiniAODv6.py ${RUN_DIR}/out_miniAODv6_step.py --randomSeeds=${SEED}

cmsRun -e -j FrameworkJobReport.xml ${RUN_DIR}/out_miniAODv6_step.py
