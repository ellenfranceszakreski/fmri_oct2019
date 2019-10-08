% smooth09_job_template
% append code after defining this variable: subx, runx
% assumes data has already been normalized
% NOTE: MUST DEFINE SUBJECT AND RUN!!!!
% e.g. subx = 'sub1'
% e.g. runx = 'run1'         f = spm_select('ExtFPList',dirname,anat_filter);
number_of_cores=12;
d=tempname();% get temporary directory location
mkdir(d);
% create cluster
cluster = parallel.cluster.Local('JobStorageLocation',d,'NumWorkers',number_of_cores);
matlabpool(cluster, number_of_cores);
%% analysis
addpath('/data/scratch/zakell/fmri_oct2019/Scripts');
addpath(genpath(fullfile(spm('dir'),'config')));
subxDir=['/data/scratch/zakell/fmri_oct2019/Input/',subx];

matlabbatch = {};
matlabbatch{1}.spm.spatial.smooth.data = cellstr(spm_select('ExtFPList', subxDir, ['^wausub\d+_',runx,'.nii'], 1:200));
matlabbatch{1}.spm.spatial.smooth.fwhm = [9 9 9];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's09';

spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);
% save file in subject's directory to indicate successful job completion
save(fullfile(subxDir,'smooth09_done.mat'), 'matlabbatch','-mat');
% done
