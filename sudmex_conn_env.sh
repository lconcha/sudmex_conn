#!/bin/bash
module load ANTs/2.4.4 freesurfer/7.3.2 fsl/6.0.7.1 inb_tools/1.0 mrtrix/3.0.4 
source `which my_do_cmd`

# Files
export sudmex_dir=/misc/tezca/egarza/SUDMEX_CONN
export dir_dwis=${sudmex_dir}/dwi_preprocessed
export out_dir=/misc/lauterbur2/lconcha/exp/SUDMEX_CONN

# Tractography 
export act_ntracks=2M
export sift_ntracks=200k
export mu=0.0001


