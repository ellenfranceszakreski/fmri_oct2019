#!/bin/sh
# remake_Level1.sh

AnalysisDir=/data/scratch/zakell/fmri_oct2019
Level1Dir=$AnalysisDir/Level1
Level1Subjects=$AnalysisDir/Scripts/Level1_subjects.txt
preproPrefix="s12wau" # make sure this is correct preprocessing prefix

## check subject
if [ ! -f $Level1Subjects ]; then
  echo "Could not find $Level1Subjects";
  exit 1
fi
# check each subject's preprocessing completion
for subx in `cat $Level1Subjects`
do
  if [ ! -d $AnalysisDir/Input/$subx ]; then
    echo $subx" has no folder in Input"
    exit 2
  elif [ ! -f $AnalysisDir/Input/$subx/prepro_done.mat ]; then
    echo $subx" preprocessing is not done or failed.";
    exit 3
  fi
done
unset subx

## remake level 1 directory
test -d $Level1Dir && rm -r $Level1Dir

## copy the preprocessed output for each subject
for subx in `cat $Level1Subjects`
do
  mkdir $Level1Dir/$subx
  cp -v $AnalysisDir/Input/$subx/$preproPrefix$subx"_run"*".nii" $Level1Dir/$subx
done
unset subx
