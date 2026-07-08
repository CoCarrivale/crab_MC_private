#!/bin/bash
export EOS_MGM_URL=root://eosuser.cern.ch
echo "Starting job on " `date` #Date/time of start of job
echo "Running on: `uname -a`" #Condor job is running on this node
echo "System software: `cat /etc/redhat-release`" #Operating System on that node
source /cvmfs/cms.cern.ch/cmsset_default.sh


#Working on lhe step
#step: LHE to GENSIM

sed -i 's#^.*hoppetweights-ymax20.tgz.*$#    args = cms.vstring("zee_dim6_mll50-100_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz"),#' -i SMP-RunIISummer20UL17wmLHEGEN-00065_1_cfg.py
sed -i 's#^.*input[^=]*=[^=]*cms.untracked.int32.*$#    input = cms.untracked.int32(10)#g' -i SMP-RunIISummer20UL17wmLHEGEN-00065_1_cfg.py
sed -i "s/^.*nEvents = .*$/    nEvents = cms.untracked.uint32(10),/g" -i SMP-RunIISummer20UL17wmLHEGEN-00065_1_cfg.py
sed -i "s/^process.RandomNumberGeneratorService.externalLHEProducer.initialSeed.*$/process.RandomNumberGeneratorService.externalLHEProducer.initialSeed=int($(($1+1)))/g" -i SMP-RunIISummer20UL17wmLHEGEN-00065_1_cfg.py 
echo "Opening CMSSW_13_0_17"
tar -xzvf CMSSW_13_0_17.tgz
# rm CMSSW_13_0_17.tgz
cd CMSSW_13_0_17/src/
scramv1 b ProjectRename # this handles linking the already compiled code - do NOT recompile
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
echo $CMSSW_BASE "is the CMSSW we have on the local worker node"
cd ../../
date
cmsRun SMP-RunIISummer20UL17wmLHEGEN-00065_1_cfg.py



#Working on sim step
#step: LHE to GENSIM

# rm -rf CMSSW_13_0_17
echo "Opening CMSSW_13_0_17"
tar -xzvf CMSSW_13_0_17.tgz
# rm CMSSW_13_0_17.tgz
cd CMSSW_13_0_17/src/
scramv1 b ProjectRename # this handles linking the already compiled code - do NOT recompile
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
echo $CMSSW_BASE "is the CMSSW we have on the local worker node"
cd ../../
date
cmsRun SMP-RunIISummer20UL17SIM-00030_1_cfg.py


#Working on digipremix step

date
cmsRun SMP-RunIISummer20UL17DIGIPremix-00030_1_cfg.py


#Working on hlt step
#step: GENSIM to DIGIRAW

# rm -rf CMSSW_13_0_14
echo "Opening CMSSW_13_0_14"
tar -xzvf CMSSW_13_0_14.tgz
# rm CMSSW_13_0_14.tgz
cd CMSSW_13_0_14/src/
scramv1 b ProjectRename # this handles linking the already compiled code - do NOT recompile
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
echo $CMSSW_BASE "is the CMSSW we have on the local worker node"
cd ../../
date
cmsRun SMP-RunIISummer20UL17HLT-00029_1_cfg.py


#Working on reco step
#step: DIGIRAW to AOD

# rm -rf CMSSW_13_0_14
echo "Opening CMSSW_13_0_14"
tar -xzvf CMSSW_13_0_14.tgz
# rm CMSSW_13_0_14.tgz
cd CMSSW_13_0_14/src/
scramv1 b ProjectRename # this handles linking the already compiled code - do NOT recompile
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
echo $CMSSW_BASE "is the CMSSW we have on the local worker node"
cd ../../
date
cmsRun SMP-RunIISummer20UL17RECO-00029_1_cfg.py


#Working on miniAOD step
#step: AOD to MiniAOD

# rm -rf CMSSW_13_0_14
echo "Opening CMSSW_13_0_14"
tar -xzvf CMSSW_13_0_14.tgz
# rm CMSSW_13_0_14.tgz
cd CMSSW_13_0_14/src/
scramv1 b ProjectRename # this handles linking the already compiled code - do NOT recompile
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
echo $CMSSW_BASE "is the CMSSW we have on the local worker node"
cd ../../
date
cmsRun SMP-RunIISummer20UL17MiniAODv2-00180_1_cfg.py


#Working on nanoAOD step
#step: MiniAOD to NanoAOD

# rm -rf CMSSW_13_0_14
echo "Opening CMSSW_13_0_14"
tar -xzvf CMSSW_13_0_14.tgz
# rm CMSSW_13_0_14.tgz
cd CMSSW_13_0_14/src/
scramv1 b ProjectRename # this handles linking the already compiled code - do NOT recompile
eval `scramv1 runtime -sh` # cmsenv is an alias not on the workers
echo $CMSSW_BASE "is the CMSSW we have on the local worker node"
cd ../../
date
cmsRun SMP-RunIISummer20UL17NanoAODv9-00124_1_cfg.py


# rm zee_dim6_mll50-100_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz SMP-RunIISummer20UL17wmLHEGEN-00065.root SMP-RunIISummer20UL17wmLHEGEN-00065_inLHE.root SMP-RunIISummer20UL17MiniAODv2-00180.root
# rm -rf CMSSW_13_0_14 *py
date
