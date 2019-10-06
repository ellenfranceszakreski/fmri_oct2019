function setup_analysis(name, preprocessing_prefix, condition_names, regressor_names, optional_subxs)
% setup_analysis make a new directory and copy preprocessed files to it
% setup_analysis(preprocessing_prefix, name, conditions, regressors)
% e.g. setup_analysis('s12wau', 'cue_difficulty_movement', {'control','stress'}, {'difficulty','rp_'}, optional_subxs)

%% directories
AnalysisDir='/data/scratch/zakell/fmri_oct2019';
addpath([AnalysisDir,'/Scripts']);
InputDir=[AnalysisDir, '/Input'];

%% parse input
narginchk(4,5);
% name
name = char(name); % name of new analysis
assert(isvarname(name), 'analysis name must be valid MATLAB variable name.');
NewDir=fullfile(AnalysisDir, name);
assert(exist(NewDir,'dir')~=7,'analysis named %s already exists.', name);

% preprocessing prefix
assert(ischar(preprocessing_prefix),'preprocessing_prefix must be character.');
assert(~isempty(preprocessing_prefix),'preprocessing_prefix must be nonempty.');

%% conditions and regressors
Datasubxs = select_conditions_and_regressors(condition_names,regressor_names); %.m file in script folder

% check subjects
if nargin == 4
    subxs = Datasubxs;
else
    subxs = optional_subxs;
    assert(iscellstr(subxs),'subxs must be cellstring.');
    subxs = unique(subxs,'stable');
    possible_subxs = regexp(ls(InputDir), '\<sub\d+\>', 'match');
    assert(~isempty(possible_subxs),'Input folder has no subjects.');
    bad_subxs_ii = ~ismember(subxs, possible_subxs);
    if any(bad_subxs_ii)
        disp('The following subjects are invalid.');
        disp(subxs(bad_subxs_ii));
        error('invalid subject names')
    end
    clear bad_subxs_ii possible_subxs
    % ensure preprocessing is done
    for n=1:numel(subxs)
        fname = [InputDir, '/', subxs{n}, '/prepro_done.mat'];
        assert(exist(fname,'file')~=2,...
            'Cannot use %s because prepro_done.mat does not exist for him/her',...
            fname);
        clear fname
    end
    clear n
end

%% make analysis dir
mkdir(NewDir);

%% copy pre-processing output
for n = 1:numel(subxs)
    subx = subxs{n};
    mkdir([NewDir,'/',subx]);
    % copy preprocessed data
    copyfile( [InputDir,'/',subx,'/',preprocessing_prefix,'sub*_run*.nii'],...
        [NewDir,'/',subx]);
    % move conditions and regressors
    movefile( [InputDir,'/',subx,'/selected_conditions*.mat'],...
        [NewDir,'/',subx]);
    movefile( [InputDir,'/',subx,'/selected_regressors*.mat'],...
        [NewDir,'/',subx]); clear subx
end
%% done

end
