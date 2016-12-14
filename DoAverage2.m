function D = DoAverage2(D)

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);


S   = [];
S.D = D;

S.robust = 1;
S.prefix = 'm';

D = spm_eeg_average(S);

% re-reference
S   = [];
S.D = D;

S.refchan = 'average';

%try
    D = spm_eeg_reref_eeg(S);
%end

end