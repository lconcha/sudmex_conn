#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh



subject_list=""
for s in $(ls -d ${sudmex_dir}/dwi_preprocessed/sub-*)
do
  sID=$(basename $s)
  subject_list="$subject_list $sID"
done

echo $subject_list