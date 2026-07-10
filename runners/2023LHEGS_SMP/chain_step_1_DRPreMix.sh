#!/bin/sh
set -e
#set -x

SEED=$1

RUN_DIR=${PWD}
echo ">> Setting RUN_DIR to ${RUN_DIR}"

CMSSW_RELEASE=CMSSW_13_0_17
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

# SIM STEP 
python ${RUN_DIR}/modifyCfg.py ${RUN_DIR}/SIM_step.py ${RUN_DIR}/step_1_cfg.py --randomSeeds=${SEED}

cmsRun -e -j FrameworkJobReport.xml ${RUN_DIR}/step_1_cfg.py

# DIGI PREMIX
# python ${RUN_DIR}/modifyCfg.py ${RUN_DIR}/SMP-RunIISummer20UL18DIGIPremix-00035_1_cfg.py ${RUN_DIR}/step_1_bis_cfg.py --randomSeeds=${SEED} --checkPremix 2018 --strategy 1

# Do not query for premix files in production mode...Expecting failures

python ${RUN_DIR}/modifyCfg.py ${RUN_DIR}/DIGIpremix_step.py ${RUN_DIR}/step_1_bis_cfg.py --randomSeeds=${SEED} --strategy 1

cmsRun -e -j FrameworkJobReport.xml ${RUN_DIR}/step_1_bis_cfg.py
