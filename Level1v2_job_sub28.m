% Level1v2_job_sub28.m
% level 1 specification, estimation, contrast creation (-control+stress, +control-stress)
% 1 dependency (subject's input directory)
AnalysisDir='/data/scratch/zakell/fmri_oct2019'; % <- MAKE SURE THIS IS CORRECT!
addpath(genpath(fullfile(spm('dir'),'config')));

matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.name = 'subx dir';
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {{fullfile(AnalysisDir,'Input/sub28')}};
% no RUN 1
%% find run 2 smoothed iamges
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx dir(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^s09wausub\d+_run2.nii';
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
%% find run 3 smoothed images
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx dir(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^s09wausub\d+_run3.nii';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
%% run2 expand frames
matlabbatch{4}.spm.util.exp_frames.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^s09wausub\d+_run2.nii)',...
    substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{4}.spm.util.exp_frames.frames = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200];
%% run3 expand frames
matlabbatch{5}.spm.util.exp_frames.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^s09wausub\d+_run3.nii)',...
    substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.spm.util.exp_frames.frames = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200];
%% gather files
% {6} gather smoothed frames
matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_named_file.name = 'smoothed';
% {6} files {1} run2
matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_named_file.files{1}(1) = cfg_dep('Expand image frames: Expanded filename list.',...
    substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
% {6} files {2} run3
matlabbatch{6}.cfg_basicio.file_dir.file_ops.cfg_named_file.files{2}(1) = cfg_dep('Expand image frames: Expanded filename list.',...
    substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));

%% find gray matter {7}
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx dir(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^wGm.nii$';
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';

%% movement parameters {8},{9}
% rp_subx_run2
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx dir(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^rp_sub\d+_run2.txt';
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
% rp_subx_run3
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx dir(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^rp_sub\d+_run3.txt';
matlabbatch{9}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';

%% level 1 specification
matlabbatch{10}.spm.stats.fmri_spec.dir(1) = cfg_dep('Named Directory Selector: subx dir(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{10}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{10}.spm.stats.fmri_spec.timing.RT = 2.552;
matlabbatch{10}.spm.stats.fmri_spec.timing.fmri_t = 44;
matlabbatch{10}.spm.stats.fmri_spec.timing.fmri_t0 = 22;
%----run2 depends on gathered smoothed files {6} {1} and rp_subx_run2.txt {8}
matlabbatch{10}.spm.stats.fmri_spec.sess(1).scans(1) = cfg_dep('Named File Selector: smoothed(1) - Files',...
    substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{1}));
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(1).name = 'control';
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(1).onset = [1;71];
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(1).duration = [24;23];
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(1).tmod = 1;
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(1).orth = 1;
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(2).name = 'stress';
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(2).onset = [25;94];
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(2).duration = [46;46];
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(2).tmod = 1;
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{10}.spm.stats.fmri_spec.sess(1).cond(2).orth = 1;
matlabbatch{10}.spm.stats.fmri_spec.sess(1).multi = {''};
matlabbatch{10}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
% {8} find rp_sunx_run2
matlabbatch{10}.spm.stats.fmri_spec.sess(1).multi_reg(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^rp_sub\d+_run2.txt)',...
    substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{10}.spm.stats.fmri_spec.sess(1).hpf = 384;
%----run3 depends on gathered smoothed files {6} {2} and rp_subx_run2.txt {9}
matlabbatch{10}.spm.stats.fmri_spec.sess(2).scans(1) = cfg_dep('Named File Selector: smoothed(2) - Files',...
    substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files', '{}',{2}));
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(1).name = 'control';
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(1).onset = [1;71];
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(1).duration = [24;23];
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(1).tmod = 1;
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(1).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(1).orth = 1;
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(2).name = 'stress';
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(2).onset = [25;94];
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(2).duration = [46;46];
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(2).tmod = 1;
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
matlabbatch{10}.spm.stats.fmri_spec.sess(2).cond(2).orth = 1;
matlabbatch{10}.spm.stats.fmri_spec.sess(2).multi = {''};
matlabbatch{10}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
% {9} find rp_sunx_run3
matlabbatch{10}.spm.stats.fmri_spec.sess(2).multi_reg(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^rp_sub\d+_run3.txt)',...
    substruct('.','val', '{}',{9}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{10}.spm.stats.fmri_spec.sess(2).hpf = 384;
%----
matlabbatch{10}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{10}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{10}.spm.stats.fmri_spec.volt = 1;
matlabbatch{10}.spm.stats.fmri_spec.global = 'None';
matlabbatch{10}.spm.stats.fmri_spec.mthresh = 0.8;
% depends on GM mask {7}
matlabbatch{10}.spm.stats.fmri_spec.mask(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^wGm.nii$)',...
    substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{10}.spm.stats.fmri_spec.cvi = 'AR(1)';

%% estimate
matlabbatch{11}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File',...
    substruct('.','val', '{}',{10}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{11}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{11}.spm.stats.fmri_est.method.Classical = 1;
%% contrast manager
matlabbatch{12}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File',...
    substruct('.','val', '{}',{11}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{12}.spm.stats.con.consess{1}.tcon.name = '-control+stress';
matlabbatch{12}.spm.stats.con.consess{1}.tcon.weights = [-0.5 0.5]; %movement parameters are 0 padded
matlabbatch{12}.spm.stats.con.consess{1}.tcon.sessrep = 'replsc';
matlabbatch{12}.spm.stats.con.consess{2}.tcon.name = '+control-stress';
matlabbatch{12}.spm.stats.con.consess{2}.tcon.weights = [0.5 -0.5]; %movement parameters are 0 padded
matlabbatch{12}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
matlabbatch{12}.spm.stats.con.delete = 1;
%------------------
%%% run
spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);
%% DONE


