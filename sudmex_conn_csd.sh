#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh



sID=$1

dwis=${out_dir}/${sID}/dwis_preproc.mif
mask=${out_dir}/${sID}/mask.mif


if [ ! -d ${out_dir}/${sID} ]
then
  my_do_cmd mkdir ${out_dir}/${sID}
fi

out_fod_wm=${out_dir}/${sID}/wm_fod.mif
out_fod_gm=${out_dir}/${sID}/gm_fod.mif
out_fod_csf=${out_dir}/${sID}/csf_fod.mif


if [ -f $out_fod_wm ]
then
  echo "[WARN] FOD exists: $out_fod_wm"
  exit 0
fi

out_response_wm=${out_dir}/${sID}/response_wm.txt
out_response_gm=${out_dir}/${sID}/response_gm.txt
out_response_csf=${out_dir}/${sID}/response_csf.txt
my_do_cmd dwi2response dhollander \
  -mask $mask \
  $dwis \
  $out_response_wm \
  $out_response_gm \
  $out_response_csf



my_do_cmd dwi2fod msmt_csd \
  -mask $mask \
  $dwis \
  $out_response_wm \
  $out_fod_wm \
  $out_response_gm \
  $out_fod_gm \
  $out_response_csf \
  $out_fod_csf