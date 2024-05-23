#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh




sID=$1

dwis=${out_dir}/${sID}/dwis_preproc.mif
mask=${out_dir}/${sID}/mask.mif
fod=${out_dir}/${sID}/wm_fod.mif


if [ ! -d ${out_dir}/${sID} ]
then
  my_do_cmd mkdir ${out_dir}/${sID}
fi


aseg=${sudmex_dir}/Freesurfer/${sID}_T1w/mri/aparc+aseg.mgz
fivett=${out_dir}/${sID}/5tt.mif
my_do_cmd 5ttgen freesurfer \
 -sgm_amyg_hipp \
  $aseg \
  $fivett

gmwmi=${out_dir}/${sID}/gmwmi.mif
my_do_cmd 5tt2gmwmi $fivett $gmwmi

if [ ! -d ${out_dir}/${sID}/nobackup/ ]
then 
  mkdir -p ${out_dir}/${sID}/nobackup/
fi

act_tck=${out_dir}/${sID}/nobackup/act.tck
my_do_cmd tckgen \
  -act $fivett \
  -seed_gmwmi $gmwmi \
  -select $act_ntracks \
  $fod \
  $act_tck

sift_tck=${out_dir}/${sID}/sifted.tck
my_do_cmd tcksift \
  -act $fivett \
  -term_number $sift_ntracks \
  -out_mu ${sift_tck%.tck}_mu.txt \
  $act_tck \
  $fod \
  $sift_tck



sift2_weights=${out_dir}/${sID}/sift2_weights.txt
my_do_cmd tcksift2 \
  -act $fivett \
  -fd_scale_gm \
  -out_mu ${out_dir}/${sID}/sift2_mu.txt \
  $act_tck \
  $fod \
  $sift2_weights
