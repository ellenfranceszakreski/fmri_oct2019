% Level1v2_print_job_template.m
% append this code after defining variable subx, e.g. subx='sub2';
% subject should have level 1 contrasts

AnalysisDir='/data/scratch/zakell/fmri_oct2019'; %<-make sure this is correct

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

% List of open inputs
% Named Directory Selector: Directory - cfg_files
jobs = {[AnalysisDir,'/Scripts/Level1v2_print_job.m']};
inputs{1, 1} = {[AnalysisDir,'/Input/',subx]}; % Named Directory Selector: Directory - cfg_files
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
%% done
