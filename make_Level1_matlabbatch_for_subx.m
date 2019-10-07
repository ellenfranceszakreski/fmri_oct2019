function matlabbatch = make_Level1_matlabbatch_for_subx(subx)
% make_Level1_matlabbatch_for_subx make a matlabbatch cell array for level1 model specification
% e.g. matlabbatch = make_Level1_matlabbatch_for_subx('sub2');

Level1Version='Level1v1';
ppPrefix = 's12wau';
AnalysisDir='/data/scratch/zakell/fmri_oct2019'; % <-make sure this correct!

matlabbatch = {};

matlabbatch{x}.spm.stats.fmri_spec.dir = {fullfile(AnalysisDir, Level1Version, subx)};
matlabbatch{x}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{x}.spm.stats.fmri_spec.timing.RT = 2.552;
matlabbatch{x}.spm.stats.fmri_spec.timing.fmri_t = 44;
matlabbatch{x}.spm.stats.fmri_spec.timing.fmri_t0 = 22; % reference slice from slice time correction
nRun=3;
control_stress = {'control','stress'};
for r=1:nRun
    subx_runx = [subx,'_run',num2str(r)];
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
    %     % for other conditions ...
    %     k = k+1;
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).name = '<UNDEFINED>';
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).onset = '<UNDEFINED>';
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).duration = '<UNDEFINED>';
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).tmod = 0; % time modulation
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).pmod.name = '<UNDEFINED>';
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).pmod.param = '<UNDEFINED>'; % Nx1
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).pmod.poly = 1; % 1st order polynomial (can be up to 6, 6th order)
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(k).orth = 1;
    
    %% regressors
    %     % if no single regressor
         matlabbatch{x}.spm.stats.fmri_spec.sess(r).regress = struct('name', {}, 'val', {});
    
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).regress(1).name = 'difficulty';
    %     matlabbatch{x}.spm.stats.fmri_spec.sess(r).regress(1).val = ds.difficulty(strcmp(ds.event,'DetectedScan'));
    
    clear ds
    % add movement parameters as regressors
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).multi_reg = {[AnalysisDir, '/Input/', subx, '/rp_',subx_runx,'.txt']};
    
end

end
