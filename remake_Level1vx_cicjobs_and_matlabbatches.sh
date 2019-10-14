#!/bin/sh
# remake_Level1vx_cicjobs_and_matlabbatches.sh <Level1vx> <optional subject list>

AnalysisDir=/data/scratch/zakell/fmri_oct2019

# temporarily go to analysis dir
InitialDir=$(pwd)
cd $AnalysisDir

if [ "$#" -eq 2 ]; then
	Leve1vx="$1"
	./Scripts/remake_cicjobs.sh "$Leve1vx" $2 # provided optional subject list
	status=$? #exit status
elif [ "$#" -eq 0 ]; then
	Leve1vx="$1"
	./Scripts/remake_cicjobs.sh "$Leve1vx"
	status=$? #exit status
else
	echo "error: incorrect number of inputs"
	exit 1
fi
# get exit status for remake_cicjobs
if [ $status -ne 0 ]; then
  echo "error: failed to make job list"
  cd "$InitialDir"
  exit 2
fi
unset status

## make matlabbatches in cicjobs dir

# template file
matlabbatchTemplateFile=$AnalysisDir/Scripts/"make_"$Leve1vx"_matlabbatch_template.m"
if [ ! -f $matlabbatchTemplateFile ]; then
  echo "error: could not find "$matlabbatchTemplateFile
  exit 1
fi
# temporarily go to cicjobs/$Leve1vx (made by remake_cicjobs.sh)
cd cicjobs/$Leve1vx

for subx_job in sub*_job.m
do
  subx=`echo $subx_job | sed -e 's/_job.m//g'`
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
