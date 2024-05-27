#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh


labels_options="atlas_116.nii.gz atlas_232.nii.gz "atlas_454.nii.gz""


for labels_version in $labels_options
do
    lab=${labels_version%.nii.gz}

    qc_dir=${out_dir}/qc/$lab
    mkdir -p ${qc_dir}/{im,mat}
    error_log=${qc_dir}/ERRORS.txt

    for sID in $(sudmex_conn_list_subjects.sh)
    do
    sudmex_conn_qc.sh $sID $labels_version $error_log
    my_do_cmd convert ${out_dir}/${sID}/connectome_${lab}.png \
      ${out_dir}/${sID}/connectome_sift2_${lab}.png \
      +append \
      ${qc_dir}/mat/${sID}_connectomes_${lab}.png
    ln -svf ${out_dir}/${sID}/qc.gif                      ${qc_dir}/im/${sID}.gif
    done

done
