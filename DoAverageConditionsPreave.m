function D = DoAverageConditionsPreave(D,varargin);

addpath(genpath('/home/as08/old_spm12'));

D = spm_eeg_load(D);

S.D = D;

c   = D.conditions;

N = ~cellfun(@isempty,strfind(c,'Neutral'));
H = ~cellfun(@isempty,strfind(c,'Happy'));
A = ~cellfun(@isempty,strfind(c,'Angry'));
F = ~cellfun(@isempty,strfind(c,'FT'));


S.c = [N;H;A;F];
S.label = {'Neutral','Happy','Angry','Fourier'};

S.prefix = 'w';
try S.prefix = varargin{1}; end

spm_eeg_contrast(S)