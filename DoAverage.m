function D = DoAverage(D,varargin)

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);


S   = [];
S.D = D;

S.robust = 1;

% if any(varargin{1});
%     S.prefix = varargin{1};
% else
    S.prefix = 'm';
    try S.prefix = varargin{1}; end
% end

D = spm_eeg_average(S);

% re-reference
S   = [];
S.D = D;

S.refchan = 'average';

%try
    D = spm_eeg_reref_eeg(S);
%end

end