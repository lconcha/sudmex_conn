#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh



if [ "$#" -lt 2 ]
then
  Error "Insufficient arguments.
        `basename $0` <sID> <atlasVersion>"
  exit 2
fi


sID=$1
labels_version=$2


fa=${out_dir}/${sID}/fa.mif
labels_std=${sudmex_dir}/atlases/${labels_version}
labels=${out_dir}/${sID}/dwispace_$(basename $labels_std)
lab=${labels_version%.nii.gz}
tck_sifted=${out_dir}/${sID}/sifted.tck
connectome=${out_dir}/${sID}/connectome_sift2_${lab}.csv

tmpDir=$(mktemp -d)

mrconvert -datatype uint32 $labels ${tmpDir}/labels.mif

my_do_cmd mrview \
  $fa \
  -size 800,600 \
  -overlay.load $labels \
  -overlay.threshold_min 1 \
  -overlay.opacity 0.3 \
  -noannotations \
  -overlay.colourmap 3 \
  -mode 2 \
  -capture.folder ${tmpDir} \
  -capture.prefix qc \
  -capture.grab \
  -tractography.load $tck_sifted \
  -overlay.opacity 0 \
  -capture.grab \
  -connectome.init ${tmpDir}/labels.mif \
  -connectome.load $connectome \
  -tractography.opacity 0 \
  -reset \
  -size 800,600 \
  -capture.grab \
  -exit 
  
this_gif=${out_dir}/${sID}/qc.gif
convert -delay 30 -morph 5 ${tmpDir}/*.png $this_gif

rm -fR $tmpDir