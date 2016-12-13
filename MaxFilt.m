function MaxFilt(f)

addpath /imaging/local/meg_misc
addpath /neuro/meg_pd_1.2/


% sort hpipoints first: [stolen from max000 wiki]
%----------------------------------------------------
[co ki]    = hpipoints(f);
tmppoints  = co(:,ki>1)'; % exclude fiducial points & nose
nloc       = find(~(tmppoints(:,3)<0 & tmppoints(:,2)>0));
headpoints = tmppoints(nloc,:);

save('headpoints','-ASCII','headpoints');

cmd_fit = ['/neuro/bin/util/fit_sphere_to_points headpoints'];
[status spherefit] = unix(cmd_fit);

fit = str2num(spherefit)*1000; % m to mm;


% now call maxfilter
%-----------------------------------------------------
n       = @num2str;
logfile = strrep(f,'_raw.fif','.log');
mf_str  = ['maxfilter -f ',f,...           input
    ' -o ',strrep(f,'raw','sss'),    ...   output
    ' -ctc /neuro/databases/ctc/ct_sparse.fif',...
    ' -cal /neuro/databases/sss/sss_cal.dat',...
    ' -st false',...
    ' -frame head',...
    ' -origin ',n(fit(1)),...             headpos (x)
    ' ',        n(fit(2)),...             headpos (y)
    ' ',        n(fit(3)),...             headpos (z)
    ' -autobad on',...                    autobad chans
    ' -movecomp ',...                     movement comp
    ' -v | tee ',logfile,...
    ' -format short',...
    ' -force'];

success = ~unix(mf_str);

D = spm_eeg_convert(strrep(f,'raw','sss'));


