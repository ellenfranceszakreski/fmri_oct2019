#!/bin/sh
# prep_ForSftp.sh
# make directory for transferring 
# smoothed images, movement parameters, normalised GM mask to mac, level 1 SPM.mat, level 1 contrasts
# depends on .../Scripts/subjects.txt

OriginalDir=$(pwd)
AnalysisDir=/data/scratch/zakell/fmri_oct2019 # <-make sure this is correct
ForSftpDir=$AnalysisDir/ForSftp
if [ -d $ForSftpDir ]; then
	echo "error: sftp dir already exists!"
	exit 1
fi
mkdir $ForSftpDir
cd $AnalysisDir
# make tar archive for each subject in subject list
for subx in `cat $AnalysisDir/Scripts/subjects.txt`
do
GZIP=-9 tar -czvf $ForSftpDir/$subx".tar.gz" \
Input/$subx/s09wausub*.nii \
Input/$subx/wGm.nii \
Input/$subx/rp_*.txt \
Input/$subx/SPM.mat \
Input/$subx/con_*.nii \
Input/$subx/beta_* \
Input/$subx/RPV.nii \
Input/$subx/ResMS.nii

done
unset subx
# return to initial directory
cd $OriginalDir

echo "Done making tar archives. Ready for sftp"
unset OriginalDir AnalysisDir ForSftpDir
###
