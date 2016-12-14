function D = DoBase(D,varargin)

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);


S   = []; 
S.D = D.fullfile;

S.timewin = [-100 0];

S.prefix = 'b';
try S.prefix = varargin{1}; end

D = spm_eeg_bc(S);

