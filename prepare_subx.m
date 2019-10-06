function [subxDir, runxs] = prepare_subx(subx)
%prepare_subx import raw data for subject, subx and specify runs
% [subxDir, runxs] = prepare_subx(subx)
% subxDir is absolute location of subject subx directory
% runxs is cellstring of runs e.g. {'run1','run2','run3'}
% e.g. [subxDir, runxs] = prepare_subx('sub3');
% assumes analysis directory is /data/scratch/zakell/fmri_oct2019
% WARNING: Deletes any files in Analysis directory for this subject if they exist

%% validate subx
assert(ischar(subx),'subx must be character vector.');
assert(~isempty(subx),'subx cannot be empty.');
%% subxDir (subject directory)
subxDir = ['/data/scratch/zakell/fmri_oct2019/Input/',subx];
if exist(subxDir,'dir')==7
    rmdir(subxDir); % delete old subx directory if it exists
end
mkdir(subxDir);
%% import raw data
switch subx
    case 'sub1'
        % no valid run 1
        runxs = {'run2','run3'};
        subfun_cp_file('5', 'run2'); % function nested in this function
        subfun_cp_file('6', 'run3');
        subfun_cp_file('7', 'anat');
    case 'sub5'
        % 4th and 5th scans we bad
        runxs = {'run1','run2','run3'};
        subfun_cp_file('3', 'run1');
        subfun_cp_file('6', 'run2');
        subfun_cp_file('7', 'run3');
        subfun_cp_file('8', 'anat');
    case {'sub6','sub10','sub21','sub28','sub68'}
        % 3rd scan was bad
        runxs = {'run1','run2','run3'};
        subfun_cp_file('4', 'run1');
        subfun_cp_file('5', 'run2');
        subfun_cp_file('6', 'run3');
        subfun_cp_file('7', 'anat');
    otherwise
        % no bad scans
        runxs = {'run1','run2','run3'};
        subfun_cp_file('3', 'run1');
        subfun_cp_file('4', 'run2');
        subfun_cp_file('5', 'run3');
        subfun_cp_file('6', 'anat');
end


%%--- subfunctions
    function subfun_cp_file(ScanInd, Type)
        % subfun_cp_file('3', 'run1');  % 3rd scan is run 3
        % subfun_cp_file('6', 'anat');  % 6th scan is the anatomical scan
        copyfile(...
            ['/data/chamal/projects/zakell/subx_nii/',subx,'_',ScanInd,'.nii'],... % e.g. sub3_1.nii
            [subxDir, '/',subx,'_',Type,'.nii']);
    end
%%---

end
