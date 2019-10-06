% level1_job
% level 1 model specification and estimation job for 1 subject
% do this after prepreprocessing and after selecting regressors/conditions, but before level 1 model estimation

pp_prefix = 's12wau'; % prefix of preprocessed EPI's
matlabbatch = {};
%% subject directory
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.name = 'subx directory';
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {'<UNDEFINED>'}; % define
%% select preprocessed images
% run 1 (i.e. session 1)
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','dirs', '{}',{1}));
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = ['^',pp_prefix,'sub\d+_run1\.nii'];
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPListRec';
% run 2
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','dirs', '{}',{1}));
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = ['^',pp_prefix,'sub\d+_run2\.nii'];
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPListRec';
% run 3
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','dirs', '{}',{1}));
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.filter = ['^',pp_prefix,'sub\d+_run3\.nii'];
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPListRec';

%% select frames
% run 1 depends on matlabbatch{2}
matlabbatch{5}.spm.util.exp_frames.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^swcrasub\d+_run1\.nii)',...
    substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files'));
matlabbatch{5}.spm.util.exp_frames.frames = 1:139;
% run 2 depends on matlabbatch{3}
matlabbatch{6}.spm.util.exp_frames.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^swcrasub\d+_run2\.nii)',...
    substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files'));
matlabbatch{6}.spm.util.exp_frames.frames = 1:139; 
% run 3 depends on matlabbatch{4}
matlabbatch{7}.spm.util.exp_frames.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^swcrasub\d+_run3\.nii)',....
    substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files'));
matlabbatch{7}.spm.util.exp_frames.frames = 1:139; 

%% gather selected frames
matlabbatch{8}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'swcra runs';
% run 1, 1st set of files, (i.e. depends on matlabbatch{5})
matlabbatch{8}.cfg_basicio.file_dir.file_ops.cfg_named_file.files{1}(1) = cfg_dep('Expand image frames: Expanded filename list.',...
    substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
% run 2, 2nd set of files, (i.e. depends on matlabbatch{6})
matlabbatch{8}.cfg_basicio.file_dir.file_ops.cfg_named_file.files{2}(1) = cfg_dep('Expand image frames: Expanded filename list.',...
    substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
% run 3, 3rd set of files, (i.e. depends on matlabbatch{7})
matlabbatch{8}.cfg_basicio.file_dir.file_ops.cfg_named_file.files{3}(1) = cfg_dep('Expand image frames: Expanded filename list.',...
    substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));

%% select multiple regressor .mat files (depends on matlabbatch{1})
% run 1 (9)
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','dirs', '{}',{1}));
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^selected_regressors_sub\d+_run1\.mat';
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPListRec';
% run 2 (10)
matlabbatch{10}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','dirs', '{}',{1}));
matlabbatch{10}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^selected_regressors_sub\d+_run2\.mat';
matlabbatch{10}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPListRec';
% run 3 (11)
matlabbatch{11}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','dirs', '{}',{1}));
matlabbatch{11}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^selected_regressors_sub\d+_run3\.mat';
matlabbatch{11}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPListRec';

%% select multiple conditions .mat files (depends on matlabbatch{1})
% run 1 (12)
matlabbatch{12}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','dirs', '{}',{1}));
matlabbatch{12}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^selected_conditions_sub\d+_run1\.mat';
matlabbatch{12}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPListRec';
% run 2 (13)
matlabbatch{13}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','dirs', '{}',{1}));
matlabbatch{13}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^selected_conditions_sub\d+_run2\.mat';
matlabbatch{13}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPListRec';
% run 3 (14)
matlabbatch{14}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','dirs', '{}',{1}));
matlabbatch{14}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^selected_conditions_sub\d+_run3\.mat';
matlabbatch{14}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPListRec';

%% Specify level 1 experimental design
matlabbatch{15}.spm.stats.fmri_spec.dir(1) = cfg_dep('Named Directory Selector: subx directory(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{15}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{15}.spm.stats.fmri_spec.timing.RT = 2.552;
matlabbatch{15}.spm.stats.fmri_spec.timing.fmri_t = 44;
matlabbatch{15}.spm.stats.fmri_spec.timing.fmri_t0 = 22;
% run 1, depends on matlabbatch{8} subindex 1
matlabbatch{15}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep('Named File Selector: swcra runs(1) - Files',...
    substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files', '{}',{1})); % 1st set of files
matlabbatch{15}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
% get run 1 conditions, matlabbatch{12}
matlabbatch{15}.spm.stats.fmri_spec.sess(1).multi(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^selected_conditions_sub\d+_run1\.mat)',...
    substruct('.','val', '{}',{12}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files'));
% get run 1 regressors, matlabbatch{9}
matlabbatch{15}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{15}.spm.stats.fmri_spec.sess(1).multi_reg(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^selected_regressors_sub\d+_run1\.mat)',....
    substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files'));
matlabbatch{15}.spm.stats.fmri_spec.sess(1).hpf = 348;

% run 2, depends on matlabbatch{8} subindex 2
matlabbatch{15}.spm.stats.fmri_spec.sess(2).scans(1) = cfg_dep('Named File Selector: pp runs(2) - Files',...
    substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files', '{}',{2})); % 2nd set of files
% get run 2 conditions, matlabbatch{13}
matlabbatch{15}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{15}.spm.stats.fmri_spec.sess(2).multi(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^selected_conditions_sub\d+_run2\.mat)',...
    substruct('.','val', '{}',{13}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files'));
% get run 2 regressors, matlabbatch{10}
matlabbatch{15}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{15}.spm.stats.fmri_spec.sess(2).multi_reg(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^selected_regressors_sub\d+_run2\.mat)',...
    substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files'));
matlabbatch{15}.spm.stats.fmri_spec.sess(2).hpf = 348;

% run 3, depends on matlabbatch{8} subindex 3
matlabbatch{15}.spm.stats.fmri_spec.sess(3).scans(1) = cfg_dep('Named File Selector: pp runs(3) - Files',...
    substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),....
    substruct('.','files', '{}',{3})); % 3rd set of files
% get run 3 conditions, matlabbatch{14}
matlabbatch{15}.spm.stats.fmri_spec.sess(3).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{15}.spm.stats.fmri_spec.sess(3).multi(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^selected_conditions_sub\d+_run3\.mat)',...
    substruct('.','val', '{}',{14}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files'));
% get run 3 regressors, matlabbatch{11}
matlabbatch{15}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
matlabbatch{15}.spm.stats.fmri_spec.sess(3).multi_reg(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^selected_regressors_sub\d+_run3\.mat)',...
    substruct('.','val', '{}',{11}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}),...
    substruct('.','files'));
matlabbatch{15}.spm.stats.fmri_spec.sess(3).hpf = 348;
% factorial design options, bases functions, voltera, threshold
matlabbatch{15}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{15}.spm.stats.fmri_spec.bases.hrf.derivs = [0,0];% bases functions [temporal dirative, dispersion dirative]
matlabbatch{15}.spm.stats.fmri_spec.volt = 1; % voltera
matlabbatch{15}.spm.stats.fmri_spec.global = 'None';
matlabbatch{15}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{15}.spm.stats.fmri_spec.mask = {''};
matlabbatch{15}.spm.stats.fmri_spec.cvi = 'AR(1)';

%% estimation
matlabbatch{16}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File',...
    substruct('.','val', '{}',{15}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{16}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{16}.spm.stats.fmri_est.method.Classical = 1;
