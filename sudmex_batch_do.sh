#!/bin/bash

source $(dirname $0)/sudmex_conn_env.sh


function list_sessions() {
  local subject=$1
  for s in ${dir_dwis}/${subject}/ses*
  do
    echo $(basename $s)
  done
}


logdir=${out_dir}/logs


do_this="sudmex_conn_csd.sh"

for sID in $(sudmex_conn_list_subjects.sh)
do
    for s in $(list_sessions $sID)
    do
      session=$(basename $s)
      #fsl_sub -N dti -s smp,14 -l $logdir \
        $do_this $sID $session
    done
done
