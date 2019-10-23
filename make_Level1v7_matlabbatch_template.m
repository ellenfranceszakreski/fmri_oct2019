%% add after defining variable, subx
% e.g. subx='sub2'
AnalysisDir='/data/scratch/zakell/fmri_oct2019'; %<-make sure this correct
switch subx
    case {'sub1','sub28'}
        runxs = {'run2','run3'};
    case {'sub21','sub22'}
        error('%s has no MIST data.', subx);
    otherwise
        runxs = {'run1','run2','run3'};
end
runN=numel(runxs);
subxDir = fullfile(AnalysisDir,'Input',subx);
matlabbatch{1}.spm.stats.fmri_spec.dir = {subxDir};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.552;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 44;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 22;
%%
conditions = {'control','stress'};
for r=1:runN
    runx=runxs{r};
    % scans
    matlabbatch{1}.spm.stats.fmri_spec.sess(r).scans = cellstr(...
        spm_select('ExtFPList', subxDir, ['s09wausub\d+_',runx,'.nii'], 1:139));
    % load data
    ds = importdata(fullfile(AnalysisDir,'Data',...
        strcat('dataset_',subx,'_',runx,'.mat')));
    % conditions
    for c=1:numel(conditions)
         matlabbatch{1}.spm.stats.fmri_spec.sess(r).cond(c).name = conditions{c};
         evii = strcmp(ds.event,conditions{c});
         evii = find(evii);
         if numel(evii)>2
             warning('efz:warning','%s %s %s occurs %d times.',...
                 subx,runx,conditions{c},numel(evii));
             evii = evii(1:2);
         end
         matlabbatch{1}.spm.stats.fmri_spec.sess(r).cond(c).onset = ds.onset(evii);
         matlabbatch{1}.spm.stats.fmri_spec.sess(r).cond(c).duration = ds.duration(evii);
         matlabbatch{1}.spm.stats.fmri_spec.sess(r).cond(c).tmod = 0;
         matlabbatch{1}.spm.stats.fmri_spec.sess(r).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
         matlabbatch{1}.spm.stats.fmri_spec.sess(r).cond(c).orth = 1;
         clear evii
    end
    clear c
    % regressor
    scanii = find(strcmp(ds.event,'ExpectedScan'));
    if numel(scanii)>139
        warning('efz:warning','%s %s has %d scans.',...
            subx,runx,numel(scanii));
        scanii = scanii(1:139);
    end
    matlabbatch{1}.spm.stats.fmri_spec.sess(r).regress.name = 'difficulty';
    matlabbatch{1}.spm.stats.fmri_spec.sess(r).regress.val = ds.difficulty(scanii);
    clear scanii ds
    % multiple regressors
    matlabbatch{1}.spm.stats.fmri_spec.sess(r).multi_reg = {fullfile(AnalysisDir,'Input',subx,...
        strcat('rp_',subx,'_',runx,'.txt'))};
    matlabbatch{1}.spm.stats.fmri_spec.sess(r).hpf = 384;
end
%%
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {fullfile(subxDir, 'wBrain.nii')};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

%% model estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep(...
    'fMRI model specification: SPM.mat File',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

%% contrast manager
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = '-control+stress';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [-1, +1]./runN;
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'replsc';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = '+control-stress';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [+1, -1]./runN;
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
matlabbatch{3}.spm.stats.con.delete = 1;
