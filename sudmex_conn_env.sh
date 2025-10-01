#!/bin/bash
module load singularity ANTs/2.4.4 freesurfer/7.3.2 fsl/6.0.7.1 inb_tools/1.0 mrtrix/3.0.4 


source `which my_do_cmd`

# Files
export sudmex_dir=/misc/austin/jalilr2/sudmex_tms
export dir_dwis=${sudmex_dir}/dwi_preprocessed
export out_dir=/misc/lauterbur2/lconcha/exp/sudmex_tms
export SUBJECTS_DIR=${out_dir}/Freesurfer


# Tractography 
export act_ntracks=10M
export sift_ntracks=500k
export mu=0.0001


function Info() {
  echolor cyan "[INFO | $(hostname) | $(date '+%F:%H:%M:%S')] $1"
}

function Warning() {
  echolor yellow "[WARN | $(hostname) | $(date '+%F:%H:%M:%S')] $1"
}

function Error() {
  echolor orange "[ERROR | $(hostname) | $(date '+%F:%H:%M:%S')] $1"
}

