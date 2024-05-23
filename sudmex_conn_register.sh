#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh


if [ "$#" -lt 2 ]
then
  echo "  [ERROR]. Insufficient arguments.
  `basename $0` <sID> <atlasVersion>"
  exit 2
fi


sID=$1
labels_version=$2
atlas=${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz
threads=$(( $(nproc) -2))




fa=${out_dir}/${sID}/fa.mif
md=${out_dir}/${sID}/md.mif
md_scaled=${out_dir}/${sID}/md_scaled.nii.gz
t1=${sudmex_dir}/Freesurfer/${sID}_T1w/mri/brain.mgz
labels_std=${sudmex_dir}/atlases/${labels_version}
lut=${labels_std%.nii.gz}_ref.csv

isOK=1
for f in $md $t1
do
    if [ ! -f $f ]
    then
    echo "[EROR] Cannot find file: $f"
    isOK=0
    fi
done

if [ $isOK -eq 0 ]
then
  exit 2
fi


echolor cyan "[INFO] Register t1 to dwi"
prefix=${out_dir}/${sID}/t1_to_dwi
fcheck=${prefix}Warped.nii.gz
if [ -f $fcheck ]
then
  echolor green "[INFO] File found, not overwriting: $fcheck"
else
    mrcalc $md 100000 -mul - | mrconvert -datatype int16 - $md_scaled
    my_do_cmd inb_synthreg.sh \
    -fixed $md_scaled \
    -moving $t1 \
    -outbase $prefix \
    -threads_max
fi



echolor cyan "[INFO] Register t1 to atlas"
prefix=${out_dir}/${sID}/t1_to_atlas
fcheck=${prefix}Warped.nii.gz
if [ -f $fcheck ]
then
  echolor green "[INFO] File found, not overwriting: $fcheck"
else
    my_do_cmd antsRegistrationSyN.sh -d 3 \
    -f "$atlas" \
    -m "$t1" \
    -o "$prefix" \
    -t "s" \
    -n "$threads" \
    -p f \
    -i ["${atlas}","${t1}",0]
fi
ln -svf $atlas ${out_dir}/${sID}/atlas.nii.gz

dwi_labels=${out_dir}/${sID}/dwispace_$(basename $labels_std)
fcheck=$dwi_labels
if [ -f $fcheck ]
then
  echolor green "[INFO] File found, not overwriting: $fcheck"
else
    my_do_cmd  antsApplyTransforms \
    -d 3 \
    -i $labels_std \
    -r $md_scaled \
    -o $dwi_labels \
    --interpolation NearestNeighbor \
    -t ${out_dir}/${sID}/t1_to_dwi1Warp.nii.gz \
    -t ${out_dir}/${sID}/t1_to_dwi0GenericAffine.mat \
    -t ${out_dir}/${sID}/t1_to_atlas1InverseWarp.nii.gz \
    -t [${out_dir}/${sID}/t1_to_atlas0GenericAffine.mat, 1]
fi


label_max=$(awk -F, '{print $1}' $lut | sort -n | tail -n 1)
echolor cyan "[INFO] Maximum label value is $label_max"
echolor cyan "[INFO] Removing labels with values above $label_max"
mv -v $dwi_labels /tmp/dwi_labels_$$.nii.gz
my_do_cmd mrcalc /tmp/dwi_labels_$$.nii.gz $label_max -le /tmp/ones_$$.mif
my_do_cmd mrcalc /tmp/dwi_labels_$$.nii.gz /tmp/ones_$$.mif -mul $dwi_labels

echolor cyan "[INFO] Check with:
      mrview ${out_dir}/${sID}/t1_to_dwiWarped.nii.gz \
      ${out_dir}/${sID}/fa.mif \
      -overlay.load ${out_dir}/${sID}/dwispace_$(basename $labels_std) \
      -overlay.threshold_min 1"

