#!/bin/bash

sID=$1

labels_version=atlas_116.nii.gz

echolor green "dti"
sudmex_conn_dti.sh $sID

echolor green "csd"
sudmex_conn_csd.sh $sID

echolor green "act"
sudmex_conn_act.sh $sID

echolor green "register"
sudmex_conn_register.sh $sID $labels_version

echolor green "connectome"
sudmex_conn_connectome.sh $sID $labels_version

