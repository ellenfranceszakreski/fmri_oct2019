#!/bin/sh
# ./transfer_Level1_results.sh <Level1Name>
# transfer level1 results

AnalysisDir=/data/scratch/zakell/fmri_oct2019 # <- MAKE SURE THIS IS CORRECT
if [ "$#" -ne 1 ]; then
	echo "error: Specify level 1 name"
	echo "usage: transfer_Level1_results <Level1Name>"
	exit 1
fi
Level1Name=$1
Level1Dir=$AnalysisDir/$Level1Name
if [ -d $Level1Dir ]; then
	echo "error: Level1Name already exists at "$Level1Dir
	exit 2
fi
mkdir $Level1Dir
InitialDir=$(pwd)
cd $AnalysisDir/Input
for subx in sub*
do
	mkdir $Level1Dir/$subx
	mv -v $subx/beta_*.nii $Level1Dir/$subx
	mv -v $subx/con_*.nii $Level1Dir/$subx
	mv -v $subx/spm*_*.nii $Level1Dir/$subx # spmT_ spmF_
	mv -v $subx/mask.nii $Level1Dir/$subx
	mv -v $subx/Res*.nii $Level1Dir/$subx # e.g. Res_0100.nii ResMS.nii
	mv -v $subx/RPV.nii $Level1Dir/$subx
	mv -v $subx/SPM.mat $Level1Dir/$subx
done

echo "Done moving files"
cd $InitialDir

unset subx InitialDir AnalysisDir Level1Dir Level1Name
### DONE
