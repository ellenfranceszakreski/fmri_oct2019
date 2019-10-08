% norm_mask_Gm_job_template
% assumes segmentation has been performed
% add code after defining variable subx
% e.g. subx='sub2';
%% set up cluster
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

jobs = make_matlabbatch_norm_mask(subxDir, 'Gm', 1, [3 3 3]); % resample to 3 mm voxel to match fMRI
% output image will be Gm.nii (native space) and wGm.nii (MNI space)
spm('defaults', 'FMRI');
spm_jobman('run', jobs);
% save file in subject's directory to indicate successful job completion
save(fullfile(subxDir,'norm_mask_Gm_done.mat'), 'jobs','-mat');
% done
