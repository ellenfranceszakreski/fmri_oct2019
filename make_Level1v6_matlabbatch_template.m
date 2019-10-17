% make_Level1v6_matlabbatch_template.m
% define subx e.g. subx='sub3';
fprintf('subx = %s\n',subx);
feedbacks = {'correct','incorrect','timeout'};

AnalysisDir='/data/scratch/zakell/fmri_oct2019';

addpath(genpath([spm('dir'),'/config']));

subxDir=fullfile(AnalysisDir,'Input',subx);


%% determine runxs
switch subx
    case {'sub28','sub1'}
        runxs={'run2';'run3'};
    case {'sub35','sub21','sub22'}
        error('This subjects cannot be used b/c they don''t have mist data or did not do task.');
    otherwise
        runxs={'run1';'run2';'run3'};
end
runN=numel(runxs);
runxs=reshape(runxs,runN,1);% make runxs cellstring a column vector
%% table for tracking dependencies etc.
deptbl = dataset;
deptbl.rep = [1;2];
deptbl.FrameInd= {25:70; 94:139}; % first:last frame of the 1st and 2nd stress conditions (46 frames each) 

deptbl = repmat(deptbl,runN,1); % repeat for each run
deptbl.runx = sort(repmat(runxs, 2, 1));
deptbl.matlabbatch_fileselector_dep = NaN(runN*2, 1);  %index of matlabbatch file select (filled later)
deptbl.ds = cell(runN*2,1); % for cell array of datasets for stress rep1 and stress rep2 respectively
deptbl.bad = false(runN*2,1); %if its missing a condition

for r=1:runN
    subx_runx=[subx,'_',runxs{r}];
    %% mist data
    ds = importdata(fullfile(AnalysisDir,'Data',['dataset_',subx_runx,'.mat']));
    H = size(ds,1);
    ds.runx = repmat(runxs(r),H,1);

    %% determine condition
    ds.condition=cell(H,1);
    NewConditionInds=find(strcmp(ds.event,'NewCondition'));
    if numel(NewConditionInds)>4
        warning('efz:warning','%s unexpected number of condition changes (choosing up to the 5th condition).',subx_runx);
        ds = ds(1:(NewConditionInds(5)-1), :);
        NewConditionInds = NewConditionInds(1:4);
    end
    for nci = 1:numel(NewConditionInds)
        this_ind = NewConditionInds(nci);
        ds.condition(this_ind:H) = ds.info(this_ind);
    end; clear this_ind nci
    
    %% determine rep
    % (use NewConditionInds)
    ds.rep=ones(H,1);
    ds.rep(NewConditionInds(3):H)=2; % block 2 starts after presenting control and stress (stars with the 3rd condition change)
    clear NewConditionInds
    
    %% add rp_ movement parameters (6 column matrix)
    % varnames: rp_1, rp_2, rp_3, ... rp_6
    ExpectedScanInd=strcmp(ds.event,'ExpectedScan'); %used for adding file name and rp_
    rp_mat = importdata([subxDir,'/rp_',subx_runx,'.txt']);
    
    assert(size(rp_mat,1)==sum(ExpectedScanInd),'ExpectedScanInd and rows in rp_%s don'' match', subx_runx);
    for w=1:6
        rp_w=['rp_',num2str(w)]; 
        ds.(rp_w) = NaN(H,1);
        ds.(rp_w)(ExpectedScanInd) = rp_mat(:,w);
    end
    clear rp_w w rp_mat ExpectedScanInd
    
    %% select only stress blocks
    ds = ds(strcmp(ds.condition,'stress'),:);
    H=size(ds,1); % height changed
   
    %% CALCULATE onset_stress_rep (onset relative to beginning of each stress rep)
    ds.onset_stress_rep = NaN(H,1);     
    for rep=1:2
        subds=ds(ds.rep==rep,:);
        subds.onset_stress_rep = subds.onset-nanmin(subds.onset);
        deptbl_ii = deptbl.rep == rep & strcmp(deptbl.runx, runxs{r});
        deptbl.ds{deptbl_ii} = subds;
    end
    clear subds ds rep H subx_runx deptbl_ii
end
clear r

%% ======== now make matlabbatch ======== %% 

x=0; matlabbatch={};

%% change directory ------- ------- ------- ------- ------- ------- ------
x=x+1; 
matlabbatch{x}.cfg_basicio.file_dir.dir_ops.cfg_cd.dir = {subxDir};
%% expand image frames 
% for each run and rep
for r=1:size(deptbl,1)
    runx = deptbl.runx{r};
    x=x+1; % new matlabbatch
    deptbl.matlabbatch_fileselector_dep(r) = x;
    matlabbatch{x}.spm.util.exp_frames.files = {fullfile(subxDir,['s09wau',subx,'_',runx,'.nii'])};
    % cellstr(spm_select('ExtFPList',subxDir,['^s09wausub\d+_',runx,'.nii'],1:200)); <-don't use this because it will expand each image
    %% index of frames for stress rep (whatever)
    matlabbatch{x}.spm.util.exp_frames.frames =deptbl.FrameInd{r};   
end
clear runx r

%% spm stats ------- ------- ------- ------- ------- ------- ------- ------
x=x+1;
matlabbatch{x}.spm.stats.fmri_spec.dir = {subxDir};
matlabbatch{x}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{x}.spm.stats.fmri_spec.timing.RT = 2.552;
matlabbatch{x}.spm.stats.fmri_spec.timing.fmri_t = 44;
matlabbatch{x}.spm.stats.fmri_spec.timing.fmri_t0 = 22;
% for each run and rep of stress...
for r=1:size(deptbl,1)
    % add scans for this session (e.g. run 2 stress 1)
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).scans(1) = cfg_dep(...
        'Expand image frames: Expanded filename list.',....
        substruct('.','val', '{}',{deptbl.matlabbatch_fileselector_dep(r)},...
        '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    rep_run_ds = deptbl.ds{r};
    %----- for each condition in feedback
    for c=1:numel(feedbacks)
        feedback=feedbacks{c};
        evii = strcmp(rep_run_ds.event, feedback);
        if ~any(evii)
            warning('efz:warning','NO %s FOR %s %s stress %d', feedback, subx, deptbl.runx{r}, deptbl.rep(r));
            deptbl.bad(r) = true; % this run*rep is bad
            continue
        end
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(c).name     = feedback;
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(c).onset    = rep_run_ds.onset_stress_rep(evii);
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(c).duration = ones(sum(evii),1)*3.01; %duration is consistent xs subjects
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(c).tmod = 0;
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(c).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).cond(c).orth = 1;
    end; clear c feedback evii
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).multi = {''};
    %------ done feedback conditions
    
    %------ level 1 regressors
    
    acqii = strcmp(rep_run_ds.event,'ExpectedScan'); % index frames
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).regress(1).name = 'difficulty';
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).regress(1).val = rep_run_ds.difficulty(acqii);
    % movement parameters
    for p=1:6
        rp_name = ['rp_',num2str(p)];
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).regress(p+1).name = rp_name;
        matlabbatch{x}.spm.stats.fmri_spec.sess(r).regress(p+1).val = rep_run_ds.(rp_name)(acqii); clear rp_name
    end; clear p acqii
    
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).multi_reg = {''};
    clear rep_run_ds
    matlabbatch{x}.spm.stats.fmri_spec.sess(r).hpf = 128;
end
% remove bad sessions
if any(deptbl.bad)
    assert(~all(deptbl.bad),'efz:NoValidSessions','%s has not valid sessions due to missing events.', subx);
    matlabbatch{x}.spm.stats.fmri_spec.sess(~deptbl.bad);
end
nGoodSessions=sum(~deptbl.bad);
clear deptbl

matlabbatch{x}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{x}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0]; % temporal derivative
matlabbatch{x}.spm.stats.fmri_spec.volt = 1;
matlabbatch{x}.spm.stats.fmri_spec.global = 'None';
matlabbatch{x}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{x}.spm.stats.fmri_spec.mask = cellstr(spm_select('ExtFPList',subxDir,'wBrain.nii',1)); %ICV mask
matlabbatch{x}.spm.stats.fmri_spec.cvi = 'AR(1)';

%% model estimation
x = x+1;
matlabbatch{x}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File',...
    substruct('.','val', '{}',{x-1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{x}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{x}.spm.stats.fmri_est.method.Classical = 1;

%% contrast manager
x = x+1;
matlabbatch{x}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File',...
    substruct('.','val', '{}',{x-1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{x}.spm.stats.con.consess{1}.tcon.name = '-correct+incorrect';
matlabbatch{x}.spm.stats.con.consess{1}.tcon.weights = [-1,+1,0]./nGoodSessions; %movement parameters are 0 padded
matlabbatch{x}.spm.stats.con.consess{1}.tcon.sessrep = 'replsc';
matlabbatch{x}.spm.stats.con.consess{2}.tcon.name = '+correct-incorrect';
matlabbatch{x}.spm.stats.con.consess{2}.tcon.weights = [+1,-1,0]./nGoodSessions; %movement parameters are 0 padded
matlabbatch{x}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
matlabbatch{x}.spm.stats.con.delete = 1;
clear nGoodSessions
