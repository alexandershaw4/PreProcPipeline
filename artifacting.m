function artifacting(D,prefix)

review = 0;
ID     = D;

if ischar(ID); ID = spm_eeg_load(ID); end
if nargin < 2; prefix = 'a'; end

% Find MEG & EEG channels
MEG = strfind(ID.chanlabels,'MEG');
MEG = find(~cellfun(@isempty,MEG));

EEG = strfind(ID.chanlabels,'EEG');
EEG = find(~cellfun(@isempty,EEG));

nche = length(EEG);
nchm = length(MEG);
    
for t = 1:size(ID,3)
    fprintf('analysing trial %d  ',t);
    
    eeg = squeeze(ID(EEG,:,t));
    meg = squeeze(ID(MEG,:,t));
    
    % sliding window deviations
    fprintf('[spike search window]');
    seeg  = slider(eeg,50);
    smeg  = slider(meg,50);
    
    seeg  = slider(seeg,100);
    smeg  = slider(smeg,100);
        
    %seeg  = slider(seeg,10);
    %smeg  = slider(smeg,10);
    
    seeg  = dohan(seeg);
    smeg  = dohan(smeg);
    
    % weight outliers
    fprintf('[weighting noisy channels]\n');
    neeg = cov_chk(seeg);
    nmeg = cov_chk(smeg);

    if review
        subplot(221),plot(eeg');subplot(222),plot(neeg');title('EEGs');
        subplot(223),plot(meg');subplot(224),plot(nmeg');title('MEGs');
        drawnow
    end
    
    ID(EEG,:,t) = neeg;
    ID(MEG,:,t) = nmeg;

end

S = clone(D,[prefix D.fname]);
S(EEG,:,:) = ID(EEG,:,:);
S(MEG,:,:) = ID(MEG,:,:);
S.save;


end

function out = slider(in,kern)
%win = 25; % n samps
win = kern;

    for ch = 1:size(in,1)
        this = in(ch,:);
        
        negs  = find(this<0);
        negs2 = this*0+1;
        negs2(negs)=-1;
        this = abs(this);
        
        % loop samples within window
        for ind = win+1:(size(this,2)-(win+1))
            thewin = [this(ind-win:ind-1) this(ind+1:ind+win)];
            if this(ind) > mean(thewin)*3;
                while this(ind) > (mean(thewin)*3)
                    this(ind) = (this(ind)*.5) + (mean(thewin));
                end
            end
        end 
        in(ch,:) = this.*negs2;
    end
    out = in;
end

function out = dohan(in)

    % shrink edges [like hann] because filter can't reach
    u = 1:size(in,2);
    u = u.*fliplr(u);
    u = u/max(u);
    t = size(in,2);
    edge = round(.0125*t);
    u(edge:end-edge) = 1;
    
    for i = 1:size(in,1)
       in(i,:) = in(i,:).*u;
    end
    out = in;
end

function Dout = cov_chk(Din)
    
    for i = 1:size(Din,1)
        chan = find(~ismember(1:size(Din,1),i));
        
        avrg = mean(Din(chan,:));
        this = Din(i,:);
        
        n = 0;
        while sum(abs(avrg-this)) > 1e4
            n = n + 1; if n == 128; continue; end
            this = .9*[this * .5] + HighResMeanFilt([avrg * .5],1,4);
        end
        
        Din(i,:) = this;
        
    end
    
    Dout = Din;
    
    
end

