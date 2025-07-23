# 3DYGeneration

Private geenration of 3DiffDY EFT samples.

Mll binned gridpacks are located at (ask giacomo in case)

```
/eos/user/g/gboldrin/Zee_dim6_LHE/mll_binned/gridpacks_v2_2025_02_07
```

```
zee_dim6_mll100-200_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz    zee_dim6_mll200-400_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz  zee_dim6_mll600-800_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz
zee_dim6_mll1000-1500_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz  zee_dim6_mll400-600_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz  zee_dim6_mll800-1000_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz
zee_dim6_mll1500-inf_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz   zee_dim6_mll50-100_slc7_amd64_gcc700_CMSSW_10_6_19_tarball.tar.xz
```

One wrapper script starts from one gridpack and generate everything up to nAOD v12 (prepid: SMP-RunIISummer20UL17) following this flow 

```
https://cms-pdmv-prod.web.cern.ch/mcm/requests?dataset_name=DYJetsToTauTau_M-50_AtLeastOneEorMuDecay_massWgtFix_TuneCP5_13TeV-powhegMiNNLO-pythia8-photos&page=0&shown=127
```

The wrapper script can be submitted to condor for generation under a ```slc7``` singularity. 


# Condor

To configure the system make sure you cmsrel all relevant CMSSW releases indicated in the wrapper script e.g.:

```
cmssw-cc7
cmsrel CMSSW_10_6_17_patch1
cd CMSSW_10_6_17_patch1/src
cmsenv
scram b -j 8
cd ../..
tar -xzvf CMSSW_10_6_17_patch1.tgz CMSSW_10_6_17_patch1
```

then you should change the output path of ```submit.jdl``` and can submit via condor.

Beware that failures are expected due to Premix Neutrino guns often appear to be on TAPE. Crab submission should be preferred.


# Crab

Two config files are available for crab submission: 2017 and 2018. To launch crab generation simply run 

```
cmssw-cc7
cmsrel CMSSW_10_6_19_patch3
cd CMSSW_10_6_19_patch3/src; cmsenv; cd -
crab submit crab_sub_2018.py
```

Or equivalently ```crab submit crab_sub_2017.py``` 

With the current setup, I am writing to Bari T2:
`gfal-ls davs://webdav.recas.ba.infn.it:8443/cms/store/user/mpresill/osWW_EFT/OSWWemu_EWK_dim6_topU3l/OSWWemu_EWK_dim6_topU3l/250715_154441/0000`

## How to test these crab jobs locally:

Run the following commands using the task id (here example from Andrea):
```
crab preparelocal --task=250605_125525:apiccine_crab_TTTo2L2Nu_UL2017 --destdir=./local
```

then `cd`in the folder prepared by crad, and exectue:
```
bash -x ./run_job.sh  1
```
