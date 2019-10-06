function Datasubxs = select_conditions_and_regressors(condition_names,regressor_names)
%select_conditions_and_regressors select condition names and regressors
% e.g. select_conditions({'stress','control','timeout','incorrect','correct'},{'difficulty','rp_'})
% (re)makes files e.g., selected_conditions_sub3_run1.mat selected_regressors_sub3_run1.mat
% adds information about condition onsets and MIST log data from ../Data/dataset_subx_runx.mat
% do this after calling remake_Level1.sh


%% parse input
% condition names
assert(~isempty(condition_names),'condition_names cannot be empty.');
condition_names = cellstr(condition_names);
condition_names = unique(condition_names,'stable');
cellfun(@(x)validatestring(x,{'stress','control','timeout','incorrect','correct','NewQuestion','Response'}), condition_names, 'UniformOutput', false);
condition_names = reshape(condition_names, 1, numel(condition_names)); % make condition names a row vector
% regressor names
assert(~isempty(regressor_names),'regressor_names cannot be empty.');
regressor_names = cellstr(regressor_names);
regressor_names = unique(regressor_names,'stable');
cellfun(@(x)validatestring(x,{'difficulty','rp_'}), regressor_names, 'UniformOutput', false);
regressor_names = reshape(regressor_names, 1, numel(regressor_names)); % make regressor names a row vector
rp_ii = strcmp(regressor_names,'rp_');
if any(rp_ii)
    include_rp = true;
    rp_names = {'x','y','z','pitch','roll','yaw'};
    regressor_names = cellfun(@cellstr, regressor_names, 'UniformOutput', false);
    regressor_names{rp_ii} = rp_names;
    regressor_names = cellstr(horzcat(regressor_names{:}));
end
clear rp_ii

%% directories
AnalysisDir='/data/scratch/zakell/fmri_oct2019';
assert(exist(AnalysisDir,'dir')==7,'Invalid analysis directory\n%s',AnalysisDir);
DataDir=[AnalysisDir,'/Data']; % contains datasets for each subject and run (made on my mac w/ prepare_table_for_cic.m)
Level1Dir=[AnalysisDir,'/Level1']; % contains directory for each subject
assert(exist(Level1Dir,'dir')==7,'Invalid analysis level 1 directory\n%s\ncall %s/Scripts/remake_Level1.sh.',Level1Dir,AnalysisDir);
clear AnalysisDir

%% remove old selected conditions/regressors .mat for each subject in Input directory (if any exist)
Level1subxs = regexp(ls(Level1Dir),'\<sub\d+\>','match');
assert(~isempty(Level1subxs),'Could not find any subjects in Input directory.');
for n=1:numel(Level1subxs)
    if ~isempty(regexp(ls([Level1Dir,'/',Level1subxs{n}]), 'selected_(conditions|regressors)_','once'))
        delete([Level1Dir,'/',Level1subxs{n},'/selected_*.mat']);
    end
end; clear n

%% list of subjects and runs in Data directory
subx_runxs = regexp(ls(DataDir),'sub\d+_run[1-3]','match');
assert(~isempty(subx_runxs),'Could not find any subjects in Data directory.');

% ensure that Data subjects have Input too
% (not all subjects in Input have Data, e.g. sub21)
Datasubxs = regexprep(subx_runxs,'_run\d+','');
noInput = ~ismember(Datasubxs,Level1subxs);
if any(noInput)
    disp('error The following subjects are in Data but not in Input')
    disp(unique(Datasubxs(noInput)','stable'));
    error('Subjects in Data but not in Input');
end
clear noInput Level1subxs


%% make selected_conditions .mat file for each subject in Data directory (save it in Input/subx)
% the selected_conditions_subx_runx.mat file contains variables:
% names, onsets, durations
C = numel(condition_names); % number of conditions

for n = 1:numel(subx_runxs)
    subfun_(Datasubxs{n}, subx_runxs{n})
end
%%--subfunction
    function subfun_(subx, subx_runx)
        %% import dataset for this subject and run
        ds = importdata([DataDir,'/dataset_',subx_runx,'.mat']);
        % ds variable names are {'event','info','rt_ms','onset','duration','difficulty'}
        % onset and duration are in seconds, event and info are cellstring arrays.
        % onset is relative to time of first TR.
        ds = sortrows(ds, 'onset', 'ascend');
        %% regressors
        ScanInd = strcmp(ds.event, 'ExpectedScan'); % index occurance of each TR (should be 139 scans);
        % each regressor must have a row for each scan
        if include_rp % add movement parameters
            rp_mat = importdata( [Level1Dir,'/',subx,'/rp_',subx_runx,'.txt'] ); % txt file generated from realignment step
            % check size of movement parameter matrix
            assert(size(rp_mat,2)==numel(rp_names), 'rp_%s.txt has unexpected number of parameters.',subx_runx);
            assert(size(rp_mat,1)==sum(ScanInd), 'rp_%s.txt has unexpected number of rows.',subx_runx);
            % add movement parameters
            nRows = size(ds,1);
            for p=1:numel(rp_names)
                ds.(rp_names{p}) = NaN(nRows, 1);
                ds.(rp_names{p})(ScanInd) = rp_mat(:, p);
            end
            clear p rp_mat nRows
        end
        % make selected_regressor file
        names = regressor_names;
        mat = NaN(numel(ScanInd), numel(names));
        for r=1:numel(names)
            mat(:, r) = ds.(names{r})(ScanInd);
        end
        % save selected_regressor_names to a .mat file
        save([Level1Dir,'/',subx,'/selected_regressor_names.mat'], 'names','-mat');
        clear r mat names ScanInd
        %% selected conditions
        names = condition_names;
        onsets = cell(1,C);
        durations = cell(1,C);
        for c=1:C
            name = names{c};
            ii = strcmp(ds.event, name);
            if ~any(ii)
                warning('efz:warning','Could not find any %s for %s', name, subx_runx);
                continue
            end
            onsets{c} = ds.onset(ii);
            durations{c} = ds.duration(ii);
        end
        clear c name ii
        save([Level1Dir,'/',subx,'/selected_conditions_',subx_rubx,'.mat'], 'names','onsets','durations','-mat');
    end
%%--
end
