% make_Level1v4_matlabbatch_template.m make a matlabbatch cell array for level1 model specification and estimation
% requires variable subx be defined e.g. subx='sub2';

AnalysisDir='/data/scratch/zakell/fmri_oct2019'; % <-make sure this correct!
addpath(genpath(fullfile(spm('dir'),'config')));
ppPrefix = 's09wau';
matlabbatch = {};
x = 1;
matlabbatch{x}.spm.stats.fmri_spec.dir = {fullfile(AnalysisDir,'Input',subx)};
matlabbatch{x}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{x}.spm.stats.fmri_spec.timing.RT = 2.552;
matlabbatch{x}.spm.stats.fmri_spec.timing.fmri_t = 44;
matlabbatch{x}.spm.stats.fmri_spec.timing.fmri_t0 = 22; % reference slice from slice time correction
if strcmp(subx,'sub28')
    runxs = {'run2','run3'};
elseif ismember(subx, {'sub21','sub22'})
    error('sub21 and sub22 have no mist data')
else
    runxs = {'run1','run2','run3'};
end
nRun=numel(runxs);
control_stress = {'control','stress'};
for r=1:nRun
    subx_runx = [subx,'_',runxs{r}];
    % load dataset for conditions and regressors
    ds = importdata([AnalysisDir,'/Data/dataset_',subx_runx,'.mat']);
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).scans = cellstr(...
        spm_select('ExtFPList', fullfile(AnalysisDir,'Input',subx), ['^',ppPrefix, subx_runx,'.nii'], 1:139 )...
        );
    %% add conditions
    % control, stress
    for k = 1:numel(control_stress)
        evii = strcmp(ds.event, control_stress{k});
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).name = control_stress{k};
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).onset = ds.onset(evii);
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).duration = ds.duration(evii);
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).tmod = 1; % time modulation (0 = no time modulation, 1 = 1st order or linear change)
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).pmod = struct('name', {}, 'param', {}, 'poly', {}); % no parametric modulation
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).orth = 1; % orthogonal
        
    end; clear evii
    % NewQuestion
    k = k+1;
    evii = strcmp(ds.event, 'NewQuestion');
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).name = 'NewQuestion';
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).onset = ds.onset(evii);
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).duration = ds.duration(evii);
    matlabbatch{1}.spm.stats.fmri_spec.sess(r).cond(k).pmod.name = 'difficulty';
    matlabbatch{1}.spm.stats.fmri_spec.sess(r).cond(k).pmod.param = ds.difficulty(evii);
    matlabbatch{1}.spm.stats.fmri_spec.sess(r).cond(k).pmod.poly = 1; % 1st order
    clear evii

    %% regressors
    %     % if no single regressor
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).regress = struct('name', {}, 'val', {});
    
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).regress(1).name = 'difficulty';
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).regress(1).val = ds.difficulty(strcmp(ds.event,'DetectedScan'));
    
    clear ds
    % add movement parameters as regressors
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).multi_reg = {[AnalysisDir, '/Input/', subx, '/rp_',subx_runx,'.txt']};
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).hpf = 348; % must be long becuase of long stimulus presentation
end % done each session
matlabbatch{x}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{x}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0]; % no temporal dirative or dispersion
matlabbatch{x}.spm.stats.fmri_spec.volt = 1;
matlabbatch{x}.spm.stats.fmri_spec.global = 'None';
matlabbatch{x}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{x}.spm.stats.fmri_spec.mask = cellstr(...
        spm_select('ExtFPList', fullfile(AnalysisDir,'Input',subx), '^wBrain.nii', Inf )...
        );
matlabbatch{x}.spm.stats.fmri_spec.cvi = 'AR(1)';
%% model estimation
x = x+1;
matlabbatch{x}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File',...
    substruct('.','val', '{}',{x-1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{x}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{x}.spm.stats.fmri_est.method.Classical = 1;
##
clear ds control_stress ppPrefix


