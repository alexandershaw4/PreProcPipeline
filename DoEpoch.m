function D = DoEpoch(D)

addpath(genpath('/home/as08/old_spm12/'));

D = spm_eeg_load(D);

%i     = find(strcmp(D.chanlabels,'STI101'));
%vals  = [10, 30, 50, 70, 90, 110, 130, 150, 170]; % with +1 for reps

%D(i,:,:) = D(i,:,:)/10^7;


% prepare for spm trial define
%--------------------------------------------------
S.D        = D;
S.timewin  = [-100 300];
S.save     = 0;
S.reviewtrials = 0;


[vals,lb,i] = GetTrig(D);

N = find(strcmp(D.chanlabels,'STI101'));
D(N,:) = vals;

for v = 1:length(i)

    S.trialdef(v).conditionlabel = lb{v};
    S.trialdef(v).eventtype      = 'STI101_up';
    S.trialdef(v).eventvalue     = i(v);
end

[trl,conditionlabels,S2] = spm_eeg_definetrial(S);

S    = [];
S.D  = D;
S.bc = 1;

S.trl = trl;
S.conditionlabels = conditionlabels;
D2 = spm_eeg_epochs(S);

% save D2:
D2.save;

clear D;
D = D2;

end

function [t,lb,ii] = GetTrig(D)
% t = new channel with transformed values
% l = labels
% i = trigger vals in t per l

%----------------
% trigger find and name

ch = {'STI001' 'STI002' 'STI003' 'STI004'...
      'STI005' 'STI006' 'STI007' 'STI008'...
      'STI009' 'STI010' 'STI011' 'STI012'...eege
      'STI013' 'STI014' 'STI015' 'STI016'};

for i = 1:length(ch)
    x(i,:) = find(strcmp(D.chanlabels,ch{i}));
end
  
STIM = D(x,:,:); B = STIM;

on = find(any(B'));
B  = B(on,:);

C = B*0;
for k=1:size(B,1)
   C(k,B(k,:)>0) = 2^(k-1);
end

new = sum(C,1);

%t   = n(2:end)-9; % faces 1:40

t = new;


% labels:
% Neut face 1:10 = 1:10
% Angry     11:20
% Happy     21:30
% FT        31:40

ii = (1:40)+9;

for i = 1:10
    lb{i}    = ['Neutral_',num2str(i)];
    lb{i+10} = ['Angry_',num2str(i)];
    lb{i+20} = ['Happy_',num2str(i)];
    lb{i+30} = ['FT_',num2str(i)];
end

end