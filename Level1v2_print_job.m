% Level1v2_print_job.m
matlabbatch = {}; 

k=1; 
matlabbatch{k}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.name = 'subx dir';
matlabbatch{k}.cfg_basicio.file_dir.dir_ops.cfg_named_dir.dirs = {'<UNDEFINED>'};

k=2;
% depends on {1}
matlabbatch{k}.cfg_basicio.file_dir.dir_ops.cfg_cd.dir(1) = cfg_dep('Named Directory Selector: subx dir(1)',...
    substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));

k=3; % look for SPM.mat
% depends on {1}
matlabbatch{k}.cfg_basicio.file_dir.file_ops.file_fplist.dir(1) = cfg_dep('Named Directory Selector: subx dir(1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dirs', '{}',{1}));
matlabbatch{k}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^SPM.mat$';
matlabbatch{k}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';

k=4;
% depends on {3} (SPM.mat finder)
matlabbatch{k}.spm.stats.review.spmmat(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^SPM.mat$)',...
    substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{k}.spm.stats.review.display.matrix = 1;
matlabbatch{k}.spm.stats.review.print = 'ps';
