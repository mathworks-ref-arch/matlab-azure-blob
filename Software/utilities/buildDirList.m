function dirs = buildDirList(rootDir)

% Copyright 2018 The MathWorks, Inc.

dirObjs = dir([rootDir,filesep,'@*']);
dirPkgs = dir([rootDir,filesep,'+*']);

tmpDirs = {};
for n = 1:length(dirObjs)
    tmpDirs{end+1} = [dirObjs(n).folder, filesep, dirObjs(n).name]; %#ok<AGROW>
end

for n = 1:length(dirPkgs)
    recursedDirs = buildDirList([dirPkgs(n).folder, filesep, dirPkgs(n).name]);
    for m = 1:numel(recursedDirs)
        tmpDirs{end+1} = recursedDirs{m}; %#ok<AGROW>
    end
end

dirs = tmpDirs;

end
