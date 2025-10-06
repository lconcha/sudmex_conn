#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh
Info "Running sudmex_conn_act.sh"

sID=$1
session=$2


fod=${out_dir}/${sID}/${session}/wm_fod.mif
act_tck=${out_dir}/${sID}/${session}/nobackup/act.tck
sift_tck=${out_dir}/${sID}/${session}/sifted.tck
sift2_weights=${out_dir}/${sID}/${session}/sift2_weights.txt


if [ -f $sift2_weights ]
then
  Warning "SIFT2 weights exists: $sift2_weights"
  exit 0
fi


if [ ! -f $fod ]
then
  Error "FOD does not exist: $fod"
  exit 2
fi


if [ ! -d ${out_dir}/${sID} ]
then
  my_do_cmd mkdir ${out_dir}/${sID}
fi


aseg=${SUBJECTS_DIR}/${sID}_${session}/mri/aparc+aseg.mgz
fivett=${out_dir}/${sID}/${session}/5tt.mif
my_do_cmd 5ttgen freesurfer \
 -sgm_amyg_hipp \
  $aseg \
  $fivett

gmwmi=${out_dir}/${sID}/${session}/gmwmi.mif
my_do_cmd 5tt2gmwmi $fivett $gmwmi

if [ ! -d ${out_dir}/${sID}/${session}/nobackup/ ]
then 
  mkdir -p ${out_dir}/${sID}/${session}/nobackup/
fi



my_do_cmd time tckgen \
  -act $fivett \
  -seed_gmwmi $gmwmi \
  -select $act_ntracks \
  $fod \
  $act_tck

my_do_cmd time tcksift \
  -act $fivett \
  -term_number $sift_ntracks \
  -out_mu ${sift_tck%.tck}_mu.txt \
  $act_tck \
  $fod \
  $sift_tck

my_do_cmd time tcksift2 \
  -act $fivett \
  -fd_scale_gm \
  -out_mu ${out_dir}/${sID}/${session}/sift2_mu.txt \
  $act_tck \
  $fod \
  $sift2_weights
