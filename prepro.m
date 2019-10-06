% prepro run matlabbatch to preprocess one subject 
% append this code after defining variable, subx
% e.g. subx = 'sub3'
addpath('/data/scratch/zakell/fmri_oct2019/Scripts');

%% get data for subjext
[subxDir, runxs] = prepare_subx(subx); % .m file is in Scripts folder
clear subx
assert(numel(runxs)==3, 'unexpected number of runs.');
clear runxs
 
%% prepare data
jobs = {'/data/scratch/zakell/fmri_oct2019/Scripts/prepro_job.m'};
inputs = cell(4, 1);
addpath(genpath(fullfile(spm('dir'),'config')));
inputs{1, 1} = cellstr(spm_select('ExtFPList',subxDir,'^sub\d+_run1.nii',1:200));
inputs{2, 1} = cellstr(spm_select('ExtFPList',subxDir,'^sub\d+_run2.nii',1:200));
inputs{3, 1} = cellstr(spm_select('ExtFPList',subxDir,'^sub\d+_run3.nii',1:200));
inputs{4, 1} = cellstr(spm_select('ExtFPList',subxDir,'^sub\d+_anat.nii',1));
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
% done
