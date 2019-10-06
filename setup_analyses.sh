#!/bin/sh
# source setup_analyses.sh
# run matlab code to set up analyses

# load require modules
source /data/scratch/zakell/fmri_oct2019/Scripts/load_modules.sh

# setup level1 (warning will throw error if analysis already setup)
matlab -nodesktop -nodisplay -nosplash -r "setup_analysis('s12wau', 'cue_difficulty_movement', {'control','stress'}, {'difficulty','rp_'});"
