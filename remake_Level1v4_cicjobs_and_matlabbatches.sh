#!/bin/sh
# remake_Level1v4_cicjobs_and_matlabbatches.sh <optional subject list>

AnalysisDir=/data/scratch/zakell/fmri_oct2019

matlabbatchTemplateFile=$AnalysisDir/Scripts/make_Level1v4_matlabbatch_template.m
if [ ! -f $matlabbatchTemplateFile ]; then
  echo "error: could not find "$matlabbatchTemplateFile
  exit 1
fi
# temporarily go to cicjobs/Level1v4 
InitialDir=$(pwd)
cd $AnalysisDir

if [ "$#" -eq 1 ]; then
  ./Scripts/remake_cicjobs.sh Level1v4 $1 # provided optional subject list
  status=$? #exit status
elif [ "$#" -eq 0 ]; then
  ./Scripts/remake_cicjobs.sh Level1v4
  status=$? #exit status
else
  echo "error: incorrect number of inputs"
  exit 2
fi
# get exit status for remake_cicjobs
if [ $status -ne 0 ]; then
  echo "error: failed to make job list"
  cd "$InitialDir"
  exit 3
fi
unset status
# make matlabbatches in cicjobs dir

cd cicjobs/Level1v4
for subx_job in subx*_job.m
do
  subx=`echo $subx_job | grep -o sub[0-9]\+`
  subxmatlabbatchFile=$subx"_matlabbatch.m"
  test -f $subxmatlabbatchFile && rm $subxmatlabbatchFile
  touch $subxmatlabbatchFile
  # prepend code setting variable "subx" to this subject
  echo "subx = '"$subx"';" > $subxmatlabbatchFile
  # add code to job .m file (same for all subjects)
  cat $matlabbatchTemplateFile >> $subxmatlabbatchFile
  echo "done "$subxmatlabbatchFile
  unset subx subxmatlabbatchFile
done
# return to original directory
cd "$InitialDir"
echo "Done making required job .m files and matlabbatch files."
### DONE
exit 0
