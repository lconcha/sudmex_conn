#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh


sID=$1
session=$2

t1=${sudmex_dir}/Bids/${sID}/${session}/anat/${sID}_${session}_T1w.nii.gz

fakeflag=""


if ${SUBJECTS_DIR}/${sID}_${session}/mri/aseg.mgz
then
  Warning "Freesurfer already run for ${sID} ${session}"
  exit 0
fi  



my_do_cmd $fakeflag \
  recon-all \
  -i $t1 \
  -s ${sID}_${session} \
  -all


