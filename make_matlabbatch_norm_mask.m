function matlabbatch = make_matlabbatch_norm_mask(subxDir, maskName, tissue_channels, norm_voxel, use_biascor)
% make_matlabbatch_norm_mask make normalised and native mask bias corrected image
% NOTE: assumes segmentation has been performed successfully and that the tissue channels files are written
% e.g. make_matlabbatch_norm_mask('/data/scratch/fmri_oct2019/Input/sub10', 'Gm', 1, [3 3 3], false)
% e.g. make_matlabbatch_norm_mask('/data/scratch/fmri_oct2019/Input/sub2', 'GmWmCsf', 1:3, [3 3 3], false)

%% parse input
% 1 subxDir
subxDir = char(subxDir);
assert(exist(subxDir,'dir')==7,'Invalid subject directory\n\t%s',subxDir);
assert(~isempty(regexp(subxDir, '/sub\d+(/)*$', 'once')), 'Invalid subject directory\n\t%s', subxDir);
% 2 mask name
maskName = char(maskName);
assert(isvarname(maskName),'maskName must be valid matlab variable name.');

% 3 tissue channel indices
assert(isnumeric(tissue_channels),'tissue_channels must be numeric (numbers 1 - 6).');
assert(~isempty(tissue_channels),'tissue_channels must be not empty.');
chN=numel(tissue_channels);
tissue_channels = reshape(tissue_channels,chN,1); % make 1xN so cellstr(num2str(tissue_channels)) converts to 1xN cellstring
tissue_channels = cellstr(num2str(tissue_channels)); % e.g. {'1';'2';'3'}

% 4 voxel size to write normalised images to (e.g. [3 3 3])
assert(isnumeric(norm_voxel),'norm_voxel must be numeric.');
assert(isequal(size(norm_voxel), [1 3]),'norm_voxel must be 1x3.');

% 5 multiply by bias corrected anatomical image
assert(islogical(use_biascor),'use_biascor must be logical')
assert(numel(use_biascor)==1,'use_biascor must be scalar.');

%% matlabbatch
matlabbatch = {};
%% imcalc
% tissue channel and basic corrected to input
for ii = 1:chN
    matlabbatch{1}.spm.util.imcalc(1).input(ii,1) = subfun_get_file(... % input must be a column vector
        ['tissue channel ',tissue_channels{ii}], ['^c',tissue_channels{ii},'sub\d+_anat.nii']); %#ok<AGROW>
end; clear ii tissue_channels
if use_biascor
% add bias corrected image at end of input
    matlabbatch{1}.spm.util.imcalc(1).input(chN+1,1) = subfun_get_file('bias corrected anatomical image','^msub\d+_anat.nii');
end
matlabbatch{1}.spm.util.imcalc(1).input = cellstr(matlabbatch{1}.spm.util.imcalc.input);

% new file name
maskFile=fullfile(subxDir, [maskName,'.nii']);
% delete old mask file
if exist(maskFile,'file')==2
    delete(maskFile);
end
matlabbatch{1}.spm.util.imcalc.output = maskName;
matlabbatch{1}.spm.util.imcalc.outdir = {subxDir}; % where mask file is saved to
% imcalc expression
i2sum='i1';
if chN > 1
    for ii=2:chN
        i2sum=strcat(i2sum,'+i',num2str(ii));
    end; clear ii
end
if use_biascor
    matlabbatch{1}.spm.util.imcalc.expression=sprintf('(%s).*i%d', i2sum, chN+1); % e.g. (i1+i2) .* i3
else
    matlabbatch{1}.spm.util.imcalc.expression=i2sum; % e.g. i1+i2 .* i3
end
clear i2sum 
% other parameters
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 7; % highest quality
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

%% normalise
defFile=subfun_get_file('forward deformation','^y_sub\d+_anat.nii');
% the frame index needs to be removed from the deformation file
defFile=regexprep(defFile,',1$','');
matlabbatch{2}.spm.spatial.normalise.write.subj.def(1) = defFile; clear defFile
matlabbatch{2}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep('Image Calculator: ImCalc Computed Image: output', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{2}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                           78 76 85];
matlabbatch{2}.spm.spatial.normalise.write.woptions.vox = norm_voxel;
matlabbatch{2}.spm.spatial.normalise.write.woptions.interp = 7;
matlabbatch{2}.spm.spatial.normalise.write.woptions.prefix = 'w';
%%--subfunction
function cstr = subfun_get_file(filedescription, ptrn)
    [f,~] = spm_select('ExtFPList', subxDir, ptrn, Inf);
    assert(~isempty(f),'Could not find %s (%s)', filedescription, ptrn);
    cstr = cellstr(f);
end
%---

end
