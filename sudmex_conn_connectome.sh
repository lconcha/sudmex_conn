#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh



sID=$1
labels_version=$2

labels=${out_dir}/${sID}/dwispace_$(basename $labels_version)
lab=${labels_version%.nii.gz}
fa=${out_dir}/${sID}/fa.mif
tck=${out_dir}/${sID}/sifted.tck
tck_act=${out_dir}/${sID}/nobackup/act.tck




connectome=${out_dir}/${sID}/connectome_${lab}.csv
assignments=${out_dir}/${sID}/assignments_${lab}.txt
my_do_cmd tck2connectome \
  $tck \
  $labels \
  $connectome \
  -out_assignments $assignments


connectome=${out_dir}/${sID}/connectome_sift2_${lab}.csv
assignments=${out_dir}/${sID}/assignments_sift2_${lab}.txt
sift2_weights=${out_dir}/${sID}/sift2_weights.txt
my_do_cmd tck2connectome \
  $tck_act \
  $labels \
  $connectome \
  -out_assignments $assignments \
  -tck_weights_in $sift2_weights


# mkdir ${out_dir}/${sID}/connectome_tcks/
# my_do_cmd connectome2tck \
#   $tck \
#   $assignments \
#   ${out_dir}/${sID}/connectome_tcks/tck