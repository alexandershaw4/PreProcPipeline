function D = DoFilter(D)

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);


S   = [];
S.D = D;

S.type  = 'butterworth';
S.order = 5;
S.band  = 'bandpass';
S.freq  = [1 80];        % .1 - 80 Hz
S.prefix= 'f';
D       = spm_eeg_filter(S);

end