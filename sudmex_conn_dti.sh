#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh


sID=$1
session=$2

dwis=${dir_dwis}/${sID}/${session}/${sID}_${session}_dwi_denoised_eddy_biascorr.mif
mask=${dir_dwis}/${sID}/${session}/mask.mif

fakeflag=""

if [ ! -d ${out_dir}/${sID}/${session} ]
then
  my_do_cmd mkdir -p ${out_dir}/${sID}/${session}
fi


echo "dir_dwis : $dir_dwis"
echo "sID      : $sID"
echo "session  : $session"
echo "dwis     : $dwis"
echo "mask     : $mask"
echo "out_dir  : $out_dir"


dt=${out_dir}/${sID}/${session}/dt.mif
my_do_cmd $fakeflag dwi2tensor \
  -mask $mask \
  $dwis \
  $dt

fa=${out_dir}/${sID}/${session}/fa.mif
md=${out_dir}/${sID}/${session}/md.mif
v1=${out_dir}/${sID}/${session}/v1.mif
my_do_cmd $fakeflag tensor2metric \
  -fa     $fa \
  -adc    $md \
  -vector $v1 \
  $dt

