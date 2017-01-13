function D = DoEpochRov(D,varargin)

if isdeployed
    fprintf('Running on cluster\n');
    fprintf(D);
    %D = char(D); 
end

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);

i     = find(strcmp(D.chanlabels,'STI101'));
vals  = [10, 30, 50, 70, 90, 110, 130, 150, 170]; % with +1 for reps

D(i,:,:) = D(i,:,:)/10^7;


% prepare for spm trial define
%--------------------------------------------------
S.D        = D;
S.timewin  = [-100 300];
S.save     = 0;
S.reviewtrials = 0;

nn     = 0;
for n  = 1:10
    
    if n == 1;
         nm = 'Dev';
    else nm = sprintf('rep%d',(n-1));
    end
    
    for v = 1:length(vals)
    nn = nn +1;
    S.trialdef(nn).conditionlabel = nm;
    S.trialdef(nn).eventtype      = 'STI101_up';
    S.trialdef(nn).eventvalue     = (vals(v)+(n-1));
    end
end

[trl,conditionlabels,S2] = spm_eeg_definetrial(S);

S    = [];
S.D  = D;
S.bc = 1;

S.trl = trl;
S.conditionlabels = conditionlabels;

try varargin{1}; catch varargin{1} = []; end
if ischar(varargin{1})
     S.prefix = varargin{1};
else S.prefix = 'f';
end

D2 = spm_eeg_epochs(S);

% save D2:
D2.save;

clear D;
D = D2;

end
