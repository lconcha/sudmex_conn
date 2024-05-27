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
labels16=${out_dir}/${sID}/dwispace_$(basename ${labels_std%.nii.gz})_16.mif
lab=${labels_version%.nii.gz}
tck_sifted=${out_dir}/${sID}/sifted.tck
connectome_sift2=${out_dir}/${sID}/connectome_sift2_${lab}.csv
connectome=${out_dir}/${sID}/connectome_${lab}.csv


tmpDir=$(mktemp -d)

mrconvert -datatype uint32 $labels $labels16

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
  -tractography.opacity 0 \
  -connectome.init $labels16 \
  -connectome.load $connectome_sift2 \
  -size 800,600 \
  -reset \
  -capture.grab \
  -exit 
  
this_gif=${out_dir}/${sID}/qc.gif
convert -delay 30 -morph 5 ${tmpDir}/*.png $this_gif

rm -fR $tmpDir


for csv in $connectome $connectome_sift2
do
    sudmex_conn_csv2png.sh $csv ${csv%.csv}.png
done