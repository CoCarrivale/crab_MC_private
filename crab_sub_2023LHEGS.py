import CRABClient
from WMCore.Configuration import Configuration
from multiprocessing import Process
config = Configuration()


gp_path = '/eos/user/f/ffiore/VBS/Gridpacks/ZZ/VBS_ZZ_semilep_el8_amd64_gcc10_CMSSW_12_4_8_tarball.tar.xz'  ##to check 
#events_per_job = 1000
events_per_job = 20
PROD='VBS_semilep_ZZ_EWK_2023LHEGS_v12'

config.section_('General')
config.General.workArea=PROD
config.General.requestName=PROD

config.section_('JobType')
config.JobType.scriptExe = 'runners/2023LHEGS_SMP/run_chain_test.sh'
config.JobType.psetName = 'do_nothing_cfg.py'
config.JobType.pluginName = 'PrivateMC'
config.JobType.outputFiles = ['RunIII_2023LHEGS_NanoAODv9.root']
config.JobType.inputFiles = [
    'CMSSW_13_0_14.tar.gz', # Patched version for nanoAOD with reweighting weights
    'modifyCfg.py',
    'copy_gridpack.py',
    'get_disk_files.py',
    'runners/2023LHEGS_SMP/run_chain_test.sh',
    'runners/2023LHEGS_SMP/chain_step_0_LHEGS.sh',
    'runners/2023LHEGS_SMP/chain_step_1_DRPreMix.sh',
#    'runners/2023LHEGS_SMP/chain_step_2_test.sh',
#    'runners/2023LHEGS_SMP/chain_step_3_test.sh',
    'runners/2023LHEGS_SMP/chain_step_4_MiniAOD.sh',
    'runners/2023LHEGS_SMP/chain_step_5_NanoAOD.sh',
    'Run3/Summer23/cfg_Run3Summer23DRPremix.py',
#    '2018_SMP/HLT_step.py',
#    '2018_SMP/RECO_step.py',
#    '2018_SMP/SIM_step.py',
    'Run3/Summer23/cfg_Run3Summer23MiniAODv4.py',
    'Run3/Summer23/cfg_Run3Summer23NanoAODv12.py',
    'Run3/Summer23/cfg_Run3Summer23wmLHEGS.py'
    ]
config.JobType.disableAutomaticOutputCollection = False
config.JobType.allowUndistributedCMSSW = True
config.JobType.maxMemoryMB = 8000
config.JobType.numCores = 4

config.section_('Data')
config.Data.unitsPerJob = events_per_job
NJOBS = 2
#NJOBS = 5000
config.Data.totalUnits = config.Data.unitsPerJob * NJOBS
config.Data.splitting = 'EventBased'
config.Data.publication = False
#config.Data.ignoreLocality = True
config.Data.outputPrimaryDataset = PROD
config.Data.outputDatasetTag = PROD
config.Data.outLFNDirBase = '/cms/store/user/ffiore/'
#config.Data.inputDBS = 'phys03'

config.section_('User')

config.section_('Site')
#config.Site.whitelist = ['T2_IT_Bari']
config.Site.storageSite = 'T2_IT_Bari'


config.JobType.scriptArgs = ['inputGridpack='+gp_path]
config.JobType.scriptArgs.append('nEvents=' + str(config.Data.unitsPerJob))
config.JobType.scriptArgs.append('nThreads='+str(config.JobType.numCores))
#config.JobType.pyCfgParams = ['nEvents='+str(config.Data.unitsPerJob),'nThreads='+str(config.JobType.numCores),'inputGridpack='+mll_bin]

#print ('Submitting jobs py cfg params -->: '+' '.join(config.JobType.pyCfgParams))
print ('Submitting jobs with script args --> '+' '.join(config.JobType.scriptArgs))
print ('Submitting jobs with unitsPerJob --> '+str(config.Data.unitsPerJob)+' totalUnits --> '+str(config.Data.totalUnits),' primary dataset --> ',str(config.Data.outputPrimaryDataset))
