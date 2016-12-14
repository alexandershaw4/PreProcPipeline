function D = DoFilter(D,varargin)

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);


S   = [];
S.D = D;

S.type  = 'butterworth';
S.order = 5;
S.band  = 'bandpass';
S.freq  = [1 80];        % .1 - 80 Hz

% if any(varargin{1})
%     S.prefix = varargin{1};
% else
    S.prefix= 'f';
% end
try S.prefix = varargin{1}; end

D       = spm_eeg_filter(S);

end