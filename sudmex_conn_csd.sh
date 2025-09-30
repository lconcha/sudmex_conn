#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh




sID=$1
session=$2

dwis=${dir_dwis}/${sID}/${session}/${sID}_${session}_dwi_denoised_eddy_biascorr.mif
mask=${dir_dwis}/${sID}/${session}/mask.mif


if [ ! -d ${out_dir}/${sID}/${session} ]
then
  my_do_cmd mkdir ${out_dir}/${sID}/${session}
fi

out_fod_wm=${out_dir}/${sID}/${session}/wm_fod.mif
out_fod_gm=${out_dir}/${sID}/${session}/gm_fod.mif
out_fod_csf=${out_dir}/${sID}/${session}/csf_fod.mif


if [ -f $out_fod_wm ]
then
  Warning "FOD exists: $out_fod_wm"
  exit 0
fi

out_response_wm=${out_dir}/${sID}/${session}/response_wm.txt
out_response_gm=${out_dir}/${sID}/${session}/response_gm.txt
out_response_csf=${out_dir}/${sID}/${session}/response_csf.txt
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