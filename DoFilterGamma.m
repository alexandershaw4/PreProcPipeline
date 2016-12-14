function D = DoFilterGamma(D)

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);


S   = [];
S.D = D;

S.type  = 'butterworth';
S.order = 5;
S.band  = 'bandpass';
S.freq  = [30 90];        % .1 - 80 Hz

S.prefix= 'f30_90';

D       = spm_eeg_filter(S);

end