function F = GetUpdateRawFiles(string)
% Auto update Files.txt list of MEG datasets in my imaging project
%
% switch type;
%     case{'rov'}; updt = 'ls /imaging/as08/drug/*/*/*/[Rr]ov*.fif';
%     case{'act'}; updt = 'ls /imaging/as08/drug/*/*/*/[Aa]ct*.fif';
% end

if isempty(string); 
     updt = 'ls *.mat';
else updt = ['ls ' string];
end

%updt = 'ls /imaging/as08/drug/*/*/*/*_[Rr]ov*.fif';
str  = [updt ' >! Files.txt']; unix(str);
F    = ReadverifyDatasets('Files.txt');