A modular preprocessing [object] pipeline for spm meeg objects.


- Add a set of spm files
- Set up [pre]processing steps
- Run everything on cluster 
- Track each dataset in pipeline


% Set up a new preprocessing pipeline and apply it


To start:
```
P = PreProcessingPipeline; 
P.SetFiles('m_file_with_list_of_spm.mats');
```

To add steps to the pipeline:
```
P.addjob({'step_name','function','new_prefix','origfile_prefix'})
```

e.g. a pipeline taking a bunch of spmeeg.mat objects, filtering, epoching and running ica:

```
P.addjob({'Filter','MyFilterFunction','f'   ,'spmeeg'})
P.addjob({'Epoch' ,'MyEpochFunction' ,'e'   ,'fspmeeg'})
P.addjob({'ICA'   ,'MyICAFunction'   ,'ica_','efspmeeg'})
```

Each function (MyFilterFunction.m) is a function taking either 1 input (a single meeg object filename) or 2 (object filename + the new prefix).
These could be the standard SPM preprocessing functions, custom code, or wrappers on existing functions.

To select a job to run:
```
P.SelectJob('Filter');
```
To submit these jobs to the cluster (1 per dataset in P.GetFiles):
```
P.Do;
```
This checks that the files from the previous steps already exist, and that the new file doesn't already exist (otherwise it skips that dataset).
Cluster submission is done via qsub and an automatically created bash script, using ClusterMatlabSubmit (see my github).

To see where you're up to, do:
```
P.overview
```
To get updates of your current cluster processes (in matlab), do:
```
checkjobs;
```
