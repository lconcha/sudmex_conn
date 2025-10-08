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


#do_this="sudmex_conn_csd.sh"
#do_this="sudmex_conn_freesurfer.sh"
#logname=fs
do_this="sudmex_conn_act.sh"
logname=act
nproc=24



for sID in $(sudmex_conn_list_subjects.sh)
do
    for s in $(list_sessions $sID)
    do
      session=$(basename $s)
      fcheck=${out_dir}/${sID}/${session}/sift2_weights.txt
      if [ -f $fcheck ]
      then
        Warning "SIFT2 weights exists: $fcheck"
        continue
      else
        Info "Submitting $do_this for ${sID} ${session}"
        fsl_sub -N ${logname}_${sID}_${s} -s smp,${nproc} -l $logdir \
          $do_this $sID $session
        fi
    done
done
