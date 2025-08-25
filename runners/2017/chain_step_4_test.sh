#!/bin/sh
set -e

SEED=$1
RUN_DIR=${PWD}
echo ">> Setting RUN_DIR to ${RUN_DIR}"

# Step 3: Modify cfg in CMSSW_10_6_19_patch3
CMSSW_RELEASE_STEP3=CMSSW_10_6_19_patch3
export SCRAM_ARCH=slc7_amd64_gcc700

if [ "${CMSSW_RELEASE_STEP3}" != "local" ]; then
    if [ -d "${CMSSW_RELEASE_STEP3}" ]; then
        echo ">> Cleaning up existing ${CMSSW_RELEASE_STEP3} directory"
        rm -rf -- "${CMSSW_RELEASE_STEP3}"
    fi
    echo ">> Setting up release area for ${CMSSW_RELEASE_STEP3} and arch ${SCRAM_ARCH}"
    scram project CMSSW "${CMSSW_RELEASE_STEP3}"

    cd "${CMSSW_RELEASE_STEP3}/src"
    eval `scramv1 runtime -sh`
    cd "${RUN_DIR}"
fi

python3 "${RUN_DIR}/modifyCfg.py" \
    "${RUN_DIR}/HIG-RunIISummer20UL17MiniAODv2-00357_1_cfg.py" \
    "${RUN_DIR}/step_4_cfg.py" \
    --randomSeeds="${SEED}"

# Step 4: Run in CMSSW_10_6_17_patch1
CMSSW_RELEASE_STEP4=CMSSW_10_6_17_patch1
export SCRAM_ARCH=slc7_amd64_gcc700

if [ "${CMSSW_RELEASE_STEP4}" != "local" ]; then
    if [ -d "${CMSSW_RELEASE_STEP4}" ]; then
        echo ">> Cleaning up existing ${CMSSW_RELEASE_STEP4} directory"
        rm -rf -- "${CMSSW_RELEASE_STEP4}"
    fi
    echo ">> Setting up release area for ${CMSSW_RELEASE_STEP4} and arch ${SCRAM_ARCH}"
    scram project CMSSW "${CMSSW_RELEASE_STEP4}"

    cd "${CMSSW_RELEASE_STEP4}/src"
    eval `scramv1 runtime -sh`
    cd "${RUN_DIR}"
fi

echo " STEP 4: the CMSSW setup went fine "
cmsRun -e -j FrameworkJobReport.xml "${RUN_DIR}/step_4_cfg.py"
echo " STEP 4 COMPLETE! "
