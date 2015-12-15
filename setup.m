% script to add paths
me = mfilename;                                            % what is my filename
mydir = which(me); mydir = mydir(1:end-2-numel(me));        % where am I located
addpath(mydir(1:end-1))
addpath([mydir,'libs'])
addpath([mydir,'libs','/','data_gen'])
addpath([mydir,'libs','/','data_gen','/','common'])
addpath([mydir,'sims'])
addpath([mydir,'libs','/','gpml'])
addpath([mydir,'libs','/','libsvm'])
addpath([mydir,'libs','/','bbob'])
addpath([mydir,'thesis'])
addpath([mydir,'thesis','/','code'])
addpath([mydir,'exp'])

% initiate gpml library
startup