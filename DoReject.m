function D = DoReject(D)

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);


S   = []; 
S.D = D.fullfile;

S.methods(1).fun = 'jump';
S.methods(1).channels = 'EOG';
S.methods(1).settings.threshold = 50;

S.methods(1).fun = 'peak2peak';
S.methods(1).channels = 'MEG';
S.methods(1).settings.threshold = 20e-2;%20e-12

S.methods(2).fun = 'peak2peak';
S.methods(2).channels = 'MEGPLANAR';
S.methods(2).settings.threshold = 200e-12;%200e-12

S.methods(3).fun = 'peak2peak';
S.methods(3).channels = 'EEG';
S.methods(3).settings.threshold = 100e-2;%100e-6


D = spm_eeg_artefact(S);

try nbadchan = length(D.badchannels);end
try nrejects = sum(D.reject);        end

try fprintf('setting %d bad channels\n',nbadchan);end
try fprintf('rejecting %d bad trials\n',nrejects);end



end