#!/bin/bash
source $(dirname $0)/sudmex_conn_env.sh




sID=$1

dwis=${dir_dwis}/${sID}/dwis.mif
fmap=${dir_dwis}/${sID}/fmap.mif
mask=${out_dir}/${sID}/mask.mif
dwis_denoised=${out_dir}/${sID}/dwis_denoised.mif
dwis_denoised_eddy=${out_dir}/${sID}/dwis_denoised_eddy.mif
dwis_denoised_eddy_biascorr=${out_dir}/${sID}/dwis_denoised_eddy_biascorr.mif
dwis_preproc_final=${out_dir}/${sID}/dwis_preproc.mif

if [ ! -d ${out_dir}/${sID} ]
then
  my_do_cmd mkdir ${out_dir}/${sID}
fi

designer_container=/misc/lauterbur/lconcha/nobackup/containers/designer2.sif

shell_sizes=$(mrinfo -shell_sizes $dwis | sed 's/\s*\r*$//')

if [[ ! "$shell_sizes" = "8 32 96" ]]
then
  Error "This is not a multi-shell acquisition. shell sizes: $shell_sizes"
  exit 2
fi

if [ ! -d ${out_dir}/${sID} ]
then
my_do_cmd mkdir ${out_dir}/${sID}
fi

fcheck=$dwis_denoised
if [ -f $fcheck ]
then
    Info " File exists, not overwriting: $fcheck"
else
    singularity run --nv \
    -B /misc:/misc \
    $designer_container \
    designer \
    -denoise \
    $dwis \
    $dwis_denoised
fi



fcheck=$mask
if [ -f $fcheck ]
then
    Info " File exists, not overwriting: $fcheck"
else
    my_do_cmd dwi2mask  $dwis_denoised  $mask
fi


fcheck=$dwis_denoised_eddy
if [ -f $fcheck ]
then
    Info " File exists, not overwriting: $fcheck"
else
    dwifslpreproc \
    -eddy_options " --cnr_maps --repol --data_is_shelled --slm=linear " \
    -rpe_none \
    -eddy_mask $mask \
    -rpe_none \
    -pe_dir AP \
    $dwis_denoised \
    $dwis_denoised_eddy
fi

fcheck=$dwis_denoised_eddy_biascorr
if [ -f $fcheck ]
then
    Info " File exists, not overwriting: $fcheck"
else
    my_do_cmd dwibiascorrect ants \
    -mask $mask \
    -bias ${dwis_denoised_eddy_biascorr%.mif}_field.mif \
    $dwis_denoised_eddy \
    $dwis_denoised_eddy_biascorr
fi

ln -svf $dwis_denoised_eddy_biascorr $dwis_preproc_final