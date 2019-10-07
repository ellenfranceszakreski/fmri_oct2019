% Level1v1_job_template run matlabbatch to preprocess one subject
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

addpath([AnalysisDir,'/Scripts']);
addpath(genpath(fullfile(spm('dir'),'config')));

[jobs, spmDir] = make_Level1v1_matlabbatch_for_subx(subx); % .m file is in Scripts folder (deletes pre-existing level 1 directory content for this subject if it exists);

spm('defaults', 'FMRI');
spm_jobman('run', jobs);

% save file in subject's directory to indicate successful job completion
save(fullfile(spmDir,'Level1v1_done.mat'), 'jobs','-mat');
% done
