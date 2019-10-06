#!/bin/sh
# source setup_analyses.sh
# run matlab code to set up analyses

AnalysisDir=/data/scratch/zakell/fmri_oct2019
# load require modules
source $AnalysisDir/Scripts/load_modules.sh

# make level1 template from level1_template_tempalte
template_template_file=$AnalysisDir/Scripts/level1_job_template_template.m
if [ ! -f $template_template_file ]; then
  echo "error could not find $template_template_file"
  exit 1;
fi

template_file=$AnalysisDir/Scripts/level1_job_template.m
echo "making template file: "$template_file
# delete old template file
test -f $template_file && rm $template_file
# remake template
touch $template_file
# add analysis name
echo "AnalysisName = 'cue_difficulty_movement';" > $template_file
cat $template_template_file >> $template_file;

# remake cicjobs
./$AnalysisDir/Scripts/remake_cicjobs.sh 

# setup level1 (warning will throw error if analysis already setup)
echo "setting up analysis"
matlab -nodesktop -nodisplay -nosplash -r "setup_analysis('s12wau', 'cue_difficulty_movement', {'control','stress'}, {'difficulty','rp_'}); exit"


## done


