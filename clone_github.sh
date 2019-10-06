#!/bin/sh
# e.g. ./clone_github.sh clone github to directory Github (on analysis path)
# get code from git hub repository named 'fmri_oct2019'

AnalysisDir=/data/scratch/zakell/fmri_oct2019
GithubDir=$AnalysisDir/Github

# remake Github directory
test -d $GithubDir && rm -r $GithubDir
mkdir $GithubDir

echo "Cloning github repository fmri_oct2019 to $GithubDir"

## clone github files
git clone https://github.com/ellenfranceszakreski/fmri_oct2019 --depth 1 --branch=master $GithubDir
echo "Done cloning"

## make scripts executable and easy to delete (github sets access of files clones to read only)
echo "resetting access of cloned files"
chmod -R 777 "$GithubDir"
echo "New files"
ls -l $GithubDir
printf "\n\nTransfer done. When ready, enter commands below:\n"
printf "cd %s\n" "$AnalysisDir"
printf "mv -v Github/* Scripts\n\n"
unset GithubDir AnalysisDir
### DONE
