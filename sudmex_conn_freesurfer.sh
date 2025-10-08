#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh


sID=$1
session=$2

t1=${sudmex_dir}/Bids/${sID}/${session}/anat/${sID}_${session}_T1w.nii.gz

fakeflag=""


fcheck=${SUBJECTS_DIR}/${sID}_${session}/mri/aseg.mgz
Info "Checking if Freesurfer has been run for ${sID} ${session}"
Info "Looking for file: $fcheck"
if [ -f $fcheck ]
then
  Warning "Freesurfer already run for ${sID} ${session}"
  exit 0
else
  Info "Running Freesurfer for ${sID} ${session}"
fi



my_do_cmd $fakeflag \
  recon-all \
  -i $t1 \
  -s ${sID}_${session} \
  -all


