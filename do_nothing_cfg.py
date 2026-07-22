import FWCore.ParameterSet.Config as cms
process = cms.Process("MAIN")

process.source = cms.Source("EmptySource")
process.options = cms.untracked.PSet() 
process.options.numberOfThreads=cms.untracked.uint32(1)
process.options.numberOfStreams=cms.untracked.uint32(0)
