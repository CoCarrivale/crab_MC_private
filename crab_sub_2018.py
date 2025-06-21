import CRABClient
from WMCore.Configuration import Configuration
from multiprocessing import Process
config = Configuration()


# mll_bin = 'zee_dim6_mll50-100' 
# mll_bin = 'zee_dim6_mll100-200'
# mll_bin = 'zee_dim6_mll1000-1500' 
# mll_bin = 'zee_dim6_mll1500-inf'
# mll_bin = 'zee_dim6_mll200-400'
# mll_bin = 'zee_dim6_mll400-60' 
# mll_bin = 'zee_dim6_mll600-800' 
mll_bin = 'zee_dim6_mll800-1000'

gp_path = '/eos/user/g/gboldrin/Zee_dim6_LHE/mll_binned/gridpacks_v2_2025_02_07/' + mll_bin + '_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz' 
events_per_job = 1000
PROD='ZDYEFT-nanoaod18_'+mll_bin

config.section_('General')
config.General.workArea=PROD
config.General.requestName=PROD

config.section_('JobType')
config.JobType.scriptExe = 'runners/2018/run_chain_test.sh'
config.JobType.psetName = 'do_nothing_cfg.py'
config.JobType.pluginName = 'PrivateMC'
config.JobType.outputFiles = ['SMP-RunIISummer20UL18NanoAODv9-00051.root']
config.JobType.inputFiles = [
    'CMSSW_10_6_26.tar.gz', # Patched version for nanoAOD with reweighting weights
    'modifyCfg.py',
    'copy_gridpack.py',
    'get_disk_files.py',
    'runners/2018/run_chain_test.sh',
    'runners/2018/chain_step_0_test.sh',
    'runners/2018/chain_step_1_test.sh',
    'runners/2018/chain_step_2_test.sh',
    'runners/2018/chain_step_3_test.sh',
    'runners/2018/chain_step_4_test.sh',
    'runners/2018/chain_step_5_test.sh',
    '2018/SMP-RunIISummer20UL18wmLHEGEN-00061_1_cfg.py',
    '2018/SMP-RunIISummer20UL18SIM-00035_1_cfg.py',
    '2018/SMP-RunIISummer20UL18DIGIPremix-00035_1_cfg.py',
    '2018/SMP-RunIISummer20UL18HLT-00035_1_cfg.py',
    '2018/SMP-RunIISummer20UL18RECO-00035_1_cfg.py',
    '2018/SMP-RunIISummer20UL18MiniAODv2-00051_1_cfg.py',
    '2018/SMP-RunIISummer20UL18NanoAODv9-00051_1_cfg.py'
    ]
config.JobType.disableAutomaticOutputCollection = False
config.JobType.allowUndistributedCMSSW = True
config.JobType.maxMemoryMB = 8000
config.JobType.numCores = 4

config.section_('Data')
config.Data.unitsPerJob = events_per_job
NJOBS = 2000
config.Data.totalUnits = config.Data.unitsPerJob * NJOBS
config.Data.splitting = 'EventBased'
config.Data.publication = True
#config.Data.ignoreLocality = True
config.Data.outputPrimaryDataset = PROD
config.Data.outputDatasetTag = PROD
config.Data.outLFNDirBase = '/store/user/gboldrin/3DY_SMEFTsim_LO/'
#config.Data.inputDBS = 'phys03'

config.section_('User')

config.section_('Site')
#config.Site.whitelist = ['T2_CH_CERN']
config.Site.storageSite = 'T2_FR_GRIF_LLR'


config.JobType.scriptArgs = ['inputGridpack='+gp_path]
config.JobType.scriptArgs.append('nEvents=' + str(config.Data.unitsPerJob))
config.JobType.scriptArgs.append('nThreads='+str(config.JobType.numCores))
#config.JobType.pyCfgParams = ['nEvents='+str(config.Data.unitsPerJob),'nThreads='+str(config.JobType.numCores),'inputGridpack='+mll_bin]

#print ('Submitting jobs py cfg params -->: '+' '.join(config.JobType.pyCfgParams))
print ('Submitting jobs with script args --> '+' '.join(config.JobType.scriptArgs))
print ('Submitting jobs with unitsPerJob --> '+str(config.Data.unitsPerJob)+' totalUnits --> '+str(config.Data.totalUnits),' primary dataset --> ',str(config.Data.outputPrimaryDataset))
