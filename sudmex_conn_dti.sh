#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh


sID=$1

dwis=${out_dir}/${sID}/dwis_preproc.mif
mask=${out_dir}/${sID}/mask.mif


if [ ! -d ${out_dir}/${sID} ]
then
  my_do_cmd mkdir ${out_dir}/${sID}
fi


echo "dir_dwis : $dir_dwis"
echo "sID      : $sID"
echo "dwis     : $dwis"
echo "mask     : $mask"
echo "out_dir  : $out_dir"


dt=${out_dir}/${sID}/dt.mif
my_do_cmd dwi2tensor \
  -mask $mask \
  $dwis \
  $dt

fa=${out_dir}/${sID}/fa.mif
md=${out_dir}/${sID}/md.mif
v1=${out_dir}/${sID}/v1.mif
my_do_cmd tensor2metric \
  -fa     $fa \
  -adc    $md \
  -vector $v1 \
  $dt

