% level1_job_template run matlabbatch to preprocess one subject
% use this as a template when making CIC cluster jobs for each participant.
% append this code after defining variable
% e.g. subx='sub3';

%% set up cluster
number_of_cores=12;
d=tempname();% get temporary directory location
mkdir(d);
% create cluster
cluster = parallel.cluster.Local('JobStorageLocation',d,'NumWorkers',number_of_cores);
matlabpool(cluster, number_of_cores);

%% run analysis
% get data for subject
subxDir = ['/data/scratch/zakell/fmri_oct2019/Level1/',subx];
assert(exist(subxDir,'dir')==7,'Could not find subject directory.%s',subxDir)

% gather input
jobs = {'/data/scratch/zakell/fmri_oct2019/Scripts/level1_job.m'};
inputs = {subxDir};
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});

% save file in subject's directory to indicate successful job completion
save(fullfile(subxDir,'level1_done.mat'), 'jobs','-mat');
% done
