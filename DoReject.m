function D = DoReject(D)

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);


S   = []; 
S.D = D.fullfile;

eog_thr = [100e-6]; 


    S.methods(1).fun = 'flat';
    S.methods(1).channels = 'MEG';
    S.methods(1).settings.threshold = 0;
    S.methods(1).settings.seqlength = 4;

    S.methods(end+1).fun = 'flat';
    S.methods(end).channels = 'EEG';
    S.methods(end).settings.threshold = 0;
    S.methods(end).settings.seqlength = 4;

    %  S.methods(end+1).fun = 'peak2peak';
    S.methods(end+1).fun = 'threshchan';
    S.methods(end).channels = 'EOG';
    S.methods(end).settings.threshold = eog_thr;

    % S.methods(end+1).fun = 'threshchan';
    % S.methods(end).channels = 'MEG';
    % S.methods(end).settings.threshold = meg_thr(ss);
    % 
    % S.methods(end+1).fun = 'threshchan';
    % S.methods(end).channels = 'EEG';
    % S.methods(end).settings.threshold = eeg_thr(ss);

    %D = spm_eeg_artefact(S);



% S.methods(1).fun = 'jump';
% S.methods(1).channels = 'EOG';
% S.methods(1).settings.threshold = 50;
% 
 S.methods(end+1).fun = 'peak2peak';
 S.methods(end).channels = 'MEG';
 S.methods(end).settings.threshold = 20e-2;%20e-12
% 
 S.methods(end+1).fun = 'peak2peak';
 S.methods(end).channels = 'MEGPLANAR';
 S.methods(end).settings.threshold = 200e-1;%200e-12
% 
 S.methods(end+1).fun = 'peak2peak';
 S.methods(end).channels = 'EEG';
 S.methods(end).settings.threshold = 100e-2;%100e-6
% 
% 
 D = spm_eeg_artefact(S);

try nbadchan = length(D.badchannels);end
try nrejects = sum(D.reject);        end

try fprintf('setting %d bad channels\n',nbadchan);end
try fprintf('rejecting %d bad trials\n',nrejects);end



end