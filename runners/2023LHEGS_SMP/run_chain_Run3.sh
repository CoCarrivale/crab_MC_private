#!/bin/sh
set -e
#set -x

SEED=$(( $1 + 0 ))
GRIDPACK=$2
EVENTS=$3
THREADS=$4

echo "PRINTING PWD run_test"
pwd



python3 copy_gridpack.py -i ${GRIDPACK} -u -x root://eosuser.cern.ch/ #--use-xrootd

bash chain_step_0_test.sh ${SEED} ${GRIDPACK} ${EVENTS} ${THREADS}
bash chain_step_1_test.sh ${SEED}
# bash chain_step_2_test.sh ${SEED}
# bash chain_step_3_test.sh ${SEED}
bash chain_step_4_test.sh ${SEED}
bash chain_step_5_test.sh ${SEED}

