


P = PreProcessingPipeline2;
P.GetFiles;


P.addjob({'ICA','FastICA','NEWICA_',''}); % name, function, prepend, to

P.addjob({'Epoch','DoEpoch','e','NEWICA_'}); 

% Filter into 3 new datasets
P.addjob({'Filter','DoFilter','f','eNEWICA_'});
P.addjob({'FilterE','DoFilterEvoked','f1_30','eNEWICA_'}); 
P.addjob({'FilterG','DoFilterGamma','f30_90','eNEWICA_'});

% Artifact reject each one
P.addjob({'Reject1','DoReject','a','feNEWICA_'});
P.addjob({'Reject2','DoReject','a','f1_30eNEWICA_'});
P.addjob({'Reject3','DoReject','a','f30_90eNEWICA_'});

% Robust average
P.addjob({'Average1','DoAverage','m','afeNEWICA_'});
P.addjob({'Average2','DoAverage','m','af1_30eNEWICA_'});
P.addjob({'Average3','DoAverage','m','af30_90eNEWICA_'});

% Baseline
P.addjob({'Baseline1','DoBase','b','afeNEWICA_'})
P.addjob({'Baseline2','DoBase','b','af1_30eNEWICA_'})
P.addjob({'Baseline3','DoBase','b','af30_90eNEWICA_'})

% Robust average [baselined data]
P.addjob({'Average4','DoAverage','m','bafeNEWICA_'});
P.addjob({'Average5','DoAverage','m','baf1_30eNEWICA_'});
P.addjob({'Average6','DoAverage','m','baf30_90eNEWICA_'});

% Average face types
P.addjob({'AveFaces1','DoAverageConditions','w','mbafeNEWICA_'});
P.addjob({'AveFaces2','DoAverageConditions','w','mbaf1_30eNEWICA_'});
P.addjob({'AveFaces3','DoAverageConditions','w','mbaf30_90eNEWICA_'});

% Run each job [a job for each dataset is submitted to cluster]
%P.SelectJob(''); P.Do;

P.addjob({'Beamform','Beamform','','wmbafeNEWICA_'});
P.addjob({'BeamformE','Beamform','','wmbaf1_30eNEWICA'});
P.addjob({'BeamformG','Beamform','','wmbaf30_90eNEWICA'});

P.SelectJob('BeamformE');
P.Do;

