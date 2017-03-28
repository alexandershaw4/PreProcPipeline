
P = PreProcessingPipeline2;
P.GetFiles;


P.addjob({'ICA','FastICA','NEWICA_',''});              % name, function, prefix, prevfile
P.addjob({'Epoch','DoEpoch','e','NEWICA_'});           % Epoch
P.addjob({'Filter','DoFilter','f','eNEWICA_'});        % Filter into 3 new datasets
P.addjob({'Reject1','DoReject','a','feNEWICA_'});      % Artifact reject each one
P.addjob({'Average1','DoAverage','m','afeNEWICA_'});     % Robust average
P.addjob({'Baseline1','DoBase','b','afeNEWICA_'})        % Baseline
P.addjob({'Beamform','Beamform','bfm_','wbafeNEWICA_'}); % source loc

% Run each job [a job for each dataset is submitted to cluster]
%P.SelectJob(''); P.Do;

P.overview;                % Progress plot
P.SelectJob('Beamform');   % Select a job
P.Do;                      % submit cluster jobs [writes .sh] / run locally