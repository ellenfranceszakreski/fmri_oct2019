
% prepro_job matlabbatch to preprocess 1 subject
% 4 dependencies ( run1 epi files, run2 epi files, run3 epi files, anatomical scan )

%% realign & unwarp
% run 1
matlabbatch{1}.spm.spatial.realignunwarp.data(1).scans = '<UNDEFINED>';% should be cell string
matlabbatch{1}.spm.spatial.realignunwarp.data(1).pmscan = '';
% run 2
matlabbatch{1}.spm.spatial.realignunwarp.data(2).scans = '<UNDEFINED>'; % should be cellstring
matlabbatch{1}.spm.spatial.realignunwarp.data(2).pmscan = '';
% run 3
matlabbatch{1}.spm.spatial.realignunwarp.data(3).scans = '<UNDEFINED>'; % should be cellstring
matlabbatch{1}.spm.spatial.realignunwarp.data(3).pmscan = '';

matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 1; % highest quality
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 3; % default is 4
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 7; % highest qaulity
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 7; % highest quality
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'u';

%% slice time
matlabbatch{2}.spm.temporal.st.scans{1}(1) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','uwrfiles'));
matlabbatch{2}.spm.temporal.st.scans{2}(1) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 2)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{2}, '.','uwrfiles'));
matlabbatch{2}.spm.temporal.st.scans{3}(1) = cfg_dep('Realign & Unwarp: Unwarped Images (Sess 3)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{3}, '.','uwrfiles'));
matlabbatch{2}.spm.temporal.st.nslices = 44;
matlabbatch{2}.spm.temporal.st.tr = 2.552;
matlabbatch{2}.spm.temporal.st.ta = 2.494;
matlabbatch{2}.spm.temporal.st.so = [1:2:43, 2:2:44];
matlabbatch{2}.spm.temporal.st.refslice = 22; % reference slice is middle slice
matlabbatch{2}.spm.temporal.st.prefix = 'a';

%% segment anatomical
matlabbatch{3}.spm.spatial.preproc.channel.vols = '<UNDEFINED>'; %{'.../sub9/sub9_anat.nii,1'};
matlabbatch{3}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{3}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{3}.spm.spatial.preproc.channel.write = [0 1];
ngaus  = [1 1 2 3 4 2];
native = [1 1 1 0 0 0];
for c = 1:6 % tissue class c
    matlabbatch{3}.spm.spatial.preproc.tissue(c).tpm = {
        fullfile(spm('dir'), 'tpm', sprintf('TPM.nii,%d', c))};
    matlabbatch{3}.spm.spatial.preproc.tissue(c).ngaus = ngaus(c);
    matlabbatch{3}.spm.spatial.preproc.tissue(c).native = [native(c) 0];
    matlabbatch{3}.spm.spatial.preproc.tissue(c).warped = [0 0];
end
clear c ngaus native
matlabbatch{3}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{3}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{3}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{3}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{3}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{3}.spm.spatial.preproc.warp.samp = 2; % default is 3
matlabbatch{3}.spm.spatial.preproc.warp.write = [0 1];

%% look for bias corrected anatomical scan
matlabbatch{4}.cfg_basicio.file_dir.cfg_fileparts.files(1) = cfg_dep('Segment: Bias Corrected (1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','channel', '()',{1}, '.','biascorr', '()',{':'}));

%% skull strip anatomical scan
matlabbatch{5}.spm.util.imcalc.input(1) = cfg_dep('Segment: c1 Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{1}, '.','c', '()',{':'}));
matlabbatch{5}.spm.util.imcalc.input(2) = cfg_dep('Segment: c2 Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{2}, '.','c', '()',{':'}));
matlabbatch{5}.spm.util.imcalc.input(3) = cfg_dep('Segment: c3 Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','tiss', '()',{3}, '.','c', '()',{':'}));
matlabbatch{5}.spm.util.imcalc.input(4) = cfg_dep('Segment: Bias Corrected (1)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','channel', '()',{1}, '.','biascorr', '()',{':'}));
matlabbatch{5}.spm.util.imcalc.output = 'Brain';
matlabbatch{5}.spm.util.imcalc.outdir(1) = cfg_dep('Get Pathnames: Directories (unique)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','up'));
matlabbatch{5}.spm.util.imcalc.expression = '(i1 + i2 + i3) .* i4';
matlabbatch{5}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{5}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{5}.spm.util.imcalc.options.mask = 0;
matlabbatch{5}.spm.util.imcalc.options.interp = 1;
matlabbatch{5}.spm.util.imcalc.options.dtype = 4;

%% estimate coregistration of mean EPI to anatomical scan
matlabbatch{6}.spm.spatial.coreg.estimate.ref(1) = cfg_dep('Image Calculator: Imcalc Computed Image', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{6}.spm.spatial.coreg.estimate.source(1) = cfg_dep('Realign & Unwarp: Unwarped Mean Image', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','meanuwr'));
matlabbatch{6}.spm.spatial.coreg.estimate.other(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{6}.spm.spatial.coreg.estimate.other(2) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 2)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','files'));
matlabbatch{6}.spm.spatial.coreg.estimate.other(3) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 3)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{3}, '.','files'));
matlabbatch{6}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{6}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{6}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{6}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

%% normalise write
matlabbatch{7}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{7}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{7}.spm.spatial.normalise.write.subj.resample(2) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 2)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{2}, '.','files'));
matlabbatch{7}.spm.spatial.normalise.write.subj.resample(3) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 3)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{3}, '.','files'));
matlabbatch{7}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
                                                      
matlabbatch{7}.spm.spatial.normalise.write.woptions.vox = [3 3 3]; % fMRI voxel size
matlabbatch{7}.spm.spatial.normalise.write.woptions.interp = 7; % highest quality
matlabbatch{7}.spm.spatial.normalise.write.woptions.prefix = 'w';

%% smooth EPI's
matlabbatch{8}.spm.spatial.smooth.data(1) = cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
matlabbatch{8}.spm.spatial.smooth.fwhm = [12 12 12]; % 12 = 4 x fMRI voxel size
matlabbatch{8}.spm.spatial.smooth.dtype = 0;
matlabbatch{8}.spm.spatial.smooth.im = 0;
matlabbatch{8}.spm.spatial.smooth.prefix = 's12';

%% write normalise the anatomical scan
matlabbatch{9}.spm.spatial.normalise.write.subj.def(1) = cfg_dep('Segment: Forward Deformations', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','fordef', '()',{':'}));
matlabbatch{9}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Image Calculator: Imcalc Computed Image', substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{9}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                          78 76 85];
matlabbatch{9}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
matlabbatch{9}.spm.spatial.normalise.write.woptions.interp = 7; % highest quality
matlabbatch{9}.spm.spatial.normalise.write.woptions.prefix = 'w';
