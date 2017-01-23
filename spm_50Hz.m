function D = spm_50Hz(D)

if iscell(D)
    for i = 1:length(D)
        d = spm_eeg_load(D{i});
        fprintf('Running dataset %d of %d\n',i,length(D));
        spm_50Hz(d);
    end
    D = [];
    return;
else
    D = spm_eeg_load(D);
end

ech = D.indchantype('EEG');
mch = D.indchantype('MEG');
pch = D.indchantype('MEGPLANAR');
lfp = D.indchantype('LFP');
ch  = [ech mch pch lfp];

Fline   = 50;
Fsample = D.fsample;
dat     = D(ch,:,:);
Q       = @squeeze;

for i = 1:size(D,3)
    if i == 1; fprintf('Fitting 50 Hz noise\n'); end
    filt(:,:,i) = ft_preproc_dftfilter(Q(dat(:,:,i)), Fsample, Fline);
end


D(ch,:,:) = filt;
D.save;