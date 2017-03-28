classdef PreProcessingPipeline2 < handle
%
% A modular preprocessing pipeline with cluster submission & status
% tracking
%
% Add jobs: obj.addjob('name','function','prepend','prevprepend');
% Run jobs: obj.SelectJob('name'); obj.Do;
%
% check status on files in pipeline: obj.Status
% plot overview of status : obj.overview
%
% - Jobs are functions with input being spmeeg object (D) and optnl name
% - obj.fileswitch('name') returns full filepaths to files with that step
%
%
% Example:
%
% P = PreProcessingPipeline2; P.GetFiles;            % Initiate & get files
%
% To set a pipeline that does rawfiles -> filter -> epoch -> ica
%
% P.addjob({'Filter','DoFilter', 'f'         ,''});  % Filter 
% P.addjob({'Epoch' ,'DoEpoch2', 'e'        ,'f'});  % Epoch
% P.addjob({'ICA'   ,'FastICA' , 'NEWICA2_','ef'});  % ICA
%
% To select a step and submit jobs to cluster: 
% P.SelectJob('Filter'); P.Do
%
% AS16

    properties
        S
        Files
        cjob
        funcs
        prepend
        prev
    end
    
    
    
    
    methods
        
        % The datasets
        function obj = GetFiles(obj)
                   F = Files;
                   obj.Files = F;
        end
        
        function obj = SetFiles(obj,varargin)
           Fe = varargin{1};
           if ~iscell(Fe)
                F  = eval(Fe);
                obj.Files = F;
           else
               obj.Files = Fe(:);
           end
        end
        

       
        function DoPaths(obj)
            addpath(genpath('/home/as08/old_spm12')); % my SPM
            addpath('/home/as08/clus/');              % my cluster kit
            addpath('/home/as08/Desktop/icameeg/');   % my ica kit
        end
        
        
        
        
        
        function Status(obj)    
            if isempty(obj.funcs);
                fprintf('No methods set!\n');
                return;
            end
            
            h     = pwd;
            Files = obj.Files;
            funcs = obj.funcs;
            le    = @(x)logical(exist(x));
            names = fieldnames(obj.prepend);
            obj.S = struct;
            
            for i = 1:length(Files)
                f = Files{i};
                
                [p,fn,e] = fileparts(f);
                cd(p);
                
                for j = 1:length(names)
                    obj.S(i).(names{j}) = le([obj.prepend.(names{j}) obj.prev.(names{j}) fn e]);
                end
                
            end
        cd(h);
        end
        
        
        
        function Do(obj)
        % Run jobs - on the cluster
            obj.Status;
            
            job  = obj.cjob{2};
            TODO = find(~cat(1,obj.S.(obj.cjob{1})));
            if isempty(TODO);
                fprintf('%s already run for all datasets\n',job); 
            else
                for s = 1:length(TODO)
                    
                    FilesIn  = obj.Files{TODO(s)};
                    [go,fIn] = ready(obj,FilesIn,job);
                    
                    if go
                        fprintf('Dataset %d is ready for %s : submitting\n',s,job);
                        prefix = obj.prepend.(obj.cjob{1});
                        assignin('base','fIn',fIn);
                        assignin('base','prefix',prefix);
                        docluster(job,'fIn','prefix');
                    end
                end
            end
            obj.Status;
        end
        
        function [go,fIn] = ready(obj,FilesIn,job)
                [p,fn,e]  = fileparts(FilesIn);
                checkfile = [p '/' obj.prev.(obj.cjob{1}) fn e];
                if logical(exist(checkfile));
                    go  = 1;
                    fIn = [p '/' obj.prev.(obj.cjob{1}) fn e];
                else
                    go  = 0;
                    fIn = FilesIn;
                end
            
        end
        

        
        function SelectJob(obj,varargin)
                job = varargin{1};
                if isfield(obj.funcs,job);
                    obj.cjob{2} = obj.funcs.(job);
                    obj.cjob{1} = job;
                else
                    fprintf('Job not found!\n');
                end
            

        end
        
        
        function addjob(obj,varargin)
                name = varargin{1}{1};
                func = varargin{1}{2};
                prep = varargin{1}{3};
                prev = varargin{1}{4};
                
                obj.funcs.(name)   = func;
                obj.prepend.(name) = prep;
                obj.prev.(name)    = prev;

        end
        
        
        function X = List(varargin)
            X = cat(1,varargin{2:end});
        end
%         
        function overview(obj)
            obj.Status;
            meths = fieldnames(obj.funcs);
            for i = 1:length(meths)
                X(:,i) = obj.List(obj.S.(meths{i}));
            end
            

            imagesc(X);
            set(gca,'XTick',1:length(meths),'XTickLabel',meths);
        end
        
        function fout = fileswitch(obj,varargin)
            name = varargin{1};
            if isfield(obj.funcs,name);
                for i = 1:length(obj.Files)
                    f = obj.Files{i};
                    [p,fn,e] = fileparts(f);
                    
                    fout{i} = [p '/' obj.prepend.(name) obj.prev.(name) fn e];
                end
            end
            
        end

        
    end
    
end