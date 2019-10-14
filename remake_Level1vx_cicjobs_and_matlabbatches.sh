#!/bin/sh
# remake_Level1vx_cicjobs_and_matlabbatches.sh <Level1vx> <optional subject list>

AnalysisDir=/data/scratch/zakell/fmri_oct2019 #make sure this is correct

if [ "$#" -eq 0 ]; then
	echo "error: incorrect number of inputs"
	exit 1
fi
Level1vx=`echo "$1" | grep -o '^Level1v[0-9]\{1,\}'`
if [ ${#Level1vx} -eq 0 ]; then
	echo "error: invalid LeveLName. Must be Level1[0-9]+"
	exit 2
fi
# temporarily go to analysis dir
InitialDir=$(pwd)
cd $AnalysisDir

### (re)make template
Level1vx_job_template=Scripts/$Level1vx"_job_template.m"
# clear file
test -f $Level1vx_job_template && rm $Level1vx_job_template
touch $Level1vx_job_template 
# add code
echo "% append this code after defining variable subx, e.g. subx='sub2';" > $Level1vx_job_template 
printf "AnalysisDir = '"$AnalysisDir"';\n" >> $Level1vx_job_template
echo "%% set up cluster" >> $Level1vx_job_template
echo "number_of_cores=12;" >> $Level1vx_job_template
echo "d=tempname();% get temporary directory location" >> $Level1vx_job_template
echo "mkdir(d);" >> $Level1vx_job_template
echo "cluster = parallel.cluster.Local('JobStorageLocation',d,'NumWorkers',number_of_cores);" >> $Level1vx_job_template
echo "matlabpool(cluster, number_of_cores);" >> $Level1vx_job_template

echo "%% run analysis" >> $Level1vx_job_template
echo "addpath([AnalysisDir,'/Scripts']);" >> $Level1vx_job_template
echo "addpath(genpath([spm('dir'),'/config']));" >> $Level1vx_job_template
echo "% made byremake_Level1v4_cicjobs_and_matlabbatches" >> $Level1vx_job_template

printf "jobs = {[AnalysisDir,'/cicjobs/%s/',subx,'_matlabbatch.m']};\n" $Level1vx >> $Level1vx_job_template
echo "spm('defaults', 'FMRI');" >> $Level1vx_job_template
echo "spm_jobman('run', jobs);" >> $Level1vx_job_template
echo "% job complete" >> $Level1vx_job_template
printf "save([AnalysisDir,'/Input/',subx,'/%s_job_done.mat'], 'jobs');\n" $Level1vx >> $Level1vx_job_template
echo "% done" >> $Level1vx_job_template

printf "\n\nDone making template file: %s\n----------------------------\n" "$Level1vx_job_template"
cat $Level1vx_job_template
printf "\n----------------------------\n"
#### done making template

# make jobs
if [ "$#" -eq 2 ]; then
	./Scripts/remake_cicjobs.sh $Leve1vx $2 # provided optional subject list
	status=$? #exit status
elif [ "$#" -eq 1 ]; then
	Leve1vx="$1"
	./Scripts/remake_cicjobs.sh $Leve1vx
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

# template file for matlabbatches
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
