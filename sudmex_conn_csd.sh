#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh



sID=$1

dwis=${dir_dwis}/${sID}/dwis_du_preproc.nii.gz
bval=${dir_dwis}/${sID}/dwis_du_preproc.bval
bvec=${dir_dwis}/${sID}/dwis_du_preproc.bvec
mask=${dir_dwis}/${sID}/dwi_den_unr_preproc_mask.mif


if [ ! -d ${out_dir}/${sID} ]
then
  my_do_cmd mkdir ${out_dir}/${sID}
fi

out_fod=${out_dir}/${sID}/fod.mif


if [ -f $out_fod ]
then
  echo "[WARN] FOD exists: $out_fod"
  exit 0
fi

out_response=${out_dir}/${sID}/response.txt
my_do_cmd dwi2response tax \
  -mask $mask \
  -fslgrad $bvec $bval \
  $dwis \
  $out_response



my_do_cmd dwi2fod csd \
  -mask $mask \
  -fslgrad $bvec $bval \
  $dwis \
  $out_response \
  $out_fod