function D = DoFilterEvoked(D)

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);


S   = [];
S.D = D;

S.type  = 'butterworth';
S.order = 5;
S.band  = 'bandpass';
S.freq  = [1 30];        % .1 - 80 Hz

S.prefix= 'f1_30';

D       = spm_eeg_filter(S);

end