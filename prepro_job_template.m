% prepro_job_template run matlabbatch to preprocess one subject
% use this as a template when making CIC cluster jobs for each participant.
% append this code after defining variable, subx
% e.g. subx = 'sub3'
% NOTE: subject should have 3 runs

%% set up cluster
number_of_cores=12;
d=tempname();% get temporary directory location
mkdir(d);
% create cluster
cluster = parallel.cluster.Local('JobStorageLocation',d,'NumWorkers',number_of_cores);
matlabpool(cluster, number_of_cores);

%% run analysis
% get data for subject
addpath('/data/scratch/zakell/fmri_oct2019/Scripts');
subxDir = prepare_subx(subx);clear subx % .m file is in Scripts folder (deletes pre-existing directory for this subject if it exists);

% gather input
jobs = {'/data/scratch/zakell/fmri_oct2019/Scripts/prepro_job.m'};
inputs = cell(4, 1);
addpath(genpath(fullfile(spm('dir'),'config')));
inputs{1, 1} = cellstr(spm_select('ExtFPList',subxDir,'^sub\d+_run1.nii',1:200));
inputs{2, 1} = cellstr(spm_select('ExtFPList',subxDir,'^sub\d+_run2.nii',1:200));
inputs{3, 1} = cellstr(spm_select('ExtFPList',subxDir,'^sub\d+_run3.nii',1:200));
inputs{4, 1} = cellstr(spm_select('ExtFPList',subxDir,'^sub\d+_anat.nii',1));
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});

% save file in subject's directory to indicate successful job completion
save(fullfile(subxDir,'prepro_done.mat'), 'jobs','-mat');
% done
