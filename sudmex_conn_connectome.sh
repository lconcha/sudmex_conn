#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh



sID=$1
session=$2
labels_version=$3

labels=${out_dir}/${sID}/${session}/dwispace_$(basename $labels_version)
lab=${labels_version%.nii.gz}
fa=${out_dir}/${sID}/${session}/fa.mif
tck=${out_dir}/${sID}/${session}/sifted.tck
tck_act=${out_dir}/${sID}/${session}/nobackup/act.tck


fakeflag=""

connectome=${out_dir}/${sID}/${session}/connectome_sift2_${lab}.csv
if [ -f $connectome ]
then
  Warning "Connectome exists: $connectome"
  exit 0
fi

isOK=1
for f in $labels $fa $tck $tck_act
do
    if [ ! -f $f ]
    then
      Error "Cannot find file: $f"
      isOK=0
    else
      Info "Found file: $f"
    fi
done
if [ $isOK -eq 0 ]
then
  exit 2
fi


connectome=${out_dir}/${sID}/${session}/connectome_${lab}.csv
assignments=${out_dir}/${sID}/${session}/assignments_${lab}.txt
my_do_cmd $fakeflag tck2connectome \
  $tck \
  $labels \
  $connectome \
  -out_assignments $assignments



connectome=${out_dir}/${sID}/${session}/connectome_sift2_${lab}.csv
assignments=${out_dir}/${sID}/${session}/assignments_sift2_${lab}.txt
sift2_weights=${out_dir}/${sID}/${session}/sift2_weights.txt
my_do_cmd $fakeflag tck2connectome \
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