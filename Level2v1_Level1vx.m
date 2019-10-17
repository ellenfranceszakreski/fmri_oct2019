addpath(genpath([spm('dir'),'/config']));
AnalysisDir='/data/scratch/zakell/fmri_oct2019';
Level2Name='Level2v1_Level1v6;
Level1Name= 'Level1v6;
con_000x='con_0001'
Level2Dir=[AnalysisDir,'/',Level2Name];
if exist(Level2Dir,'dir')~=7
    mkdir(Level2Dir)
end

matlabbatch = {};
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.name = 'Level2Dir';
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {{Level2Dir}};
% cd
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_cd.dir = {Level2Dir};
matlabbatch{3}.spm.stats.factorial_design.dir = {Level2Dir};
elaLevels = {'low','high'};
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(1).name = 'ela'; % low vs. high
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(1).levels = numel(elaLevels);
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(1).dept = 0;
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(1).variance = 1;
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(1).gmsca = 0;
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(1).ancova = 0;
cueLevels = {'control','mortality'};
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(2).name = 'cue'; % control vs. mortality
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(2).levels = numel(cueLevels);
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(2).dept = 0;
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(2).variance = 1;
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(2).gmsca = 0;
matlabbatch{3}.spm.stats.factorial_design.des.fd.fact(2).ancova = 0;
%%
ds = importdata([AnalysisDir,'/Data/AllSubjects.mat']);
% image names (e.g. .../Input/sub10/con_0001.nii)
ds.con_000x = strcat(AnalysisDir,'/',Level1Name,'/', ds.subx,'/',con_000x, '.nii');
con000x_exists_ind=false(size(ds,1),1);
for n=1:size(ds,1)
    con000x_exists_ind(n) = exist(ds.con_000x{n}, 'file') == 2;
end; clear n
assert(any(con000x_exists_ind),'Could not find contrast images');
ds = ds(con000x_exists_ind, :);
clear con000x_exists_ind
subfun_index_scans = @(ela,cue)ds.con_000x(strcmp(ds.ela,ela) & strcmp(ds.cue,cue));

% low ela, control cue
matlabbatch{3}.spm.stats.factorial_design.des.fd.icell(1).levels = [1;1];
matlabbatch{3}.spm.stats.factorial_design.des.fd.icell(1).scans = subfun_index_scans('low','control');

matlabbatch{3}.spm.stats.factorial_design.des.fd.icell(2).levels = [1;2];
matlabbatch{3}.spm.stats.factorial_design.des.fd.icell(2).scans = subfun_index_scans('low','mortality');

matlabbatch{3}.spm.stats.factorial_design.des.fd.icell(3).levels = [2;1];
matlabbatch{3}.spm.stats.factorial_design.des.fd.icell(3).scans = subfun_index_scans('high','control');

matlabbatch{3}.spm.stats.factorial_design.des.fd.icell(4).levels = [2;2];
matlabbatch{3}.spm.stats.factorial_design.des.fd.icell(4).scans = subfun_index_scans('high','mortality');
clear ds subfun_index_scans

matlabbatch{3}.spm.stats.factorial_design.des.fd.contrasts = 1;
matlabbatch{3}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{3}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{3}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{3}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{3}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{3}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{3}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{3}.spm.stats.factorial_design.globalm.glonorm = 1;
%% estimate
matlabbatch{4}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File',...
    substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{4}.spm.stats.fmri_est.method.Classical = 1;
%% results

matlabbatch{5}.spm.stats.results.spmmat(1) = cfg_dep('Model estimation: SPM.mat File',...
    substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{5}.spm.stats.results.conspec.titlestr = '';
matlabbatch{5}.spm.stats.results.conspec.contrasts = Inf;
matlabbatch{5}.spm.stats.results.conspec.threshdesc = 'FDR';
matlabbatch{5}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{5}.spm.stats.results.conspec.extent = 0;
matlabbatch{5}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{5}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{5}.spm.stats.results.units = 1;
matlabbatch{5}.spm.stats.results.export{1}.ps = true;

%exclude results
matlabbatch=matlabbatch(1:4);
spm('defaults','FMRI');
spm_jobman('run',matlabbatch);




