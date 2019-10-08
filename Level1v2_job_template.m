% Level1v2_job_template.m
% append this code after defining variable subx, e.g. subx='sub2';
% subject should be smoothed already.

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
addpath(genpath([spm('dir'),'/config']));

subxDir = prepare_subx(subx);clear subx % .m file is in Scripts folder (deletes pre-existing directory for this subject if it exists);

AnalysisDir='/data/scratch/zakell/fmri_oct2019';
% List of open inputs
% Named Directory Selector: Directory - cfg_files
jobs = {[AnalysisDir,'/Scripts/Level1v2_job.m']};
inputs{1, 1} = [AnalysisDir,'/Input/',subx]; % Named Directory Selector: Directory - cfg_files
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
% job complete
save([AnalysisDir,'/Input/',subx,'/Level1v2_job_done.mat'], 'jobs');
%% done
