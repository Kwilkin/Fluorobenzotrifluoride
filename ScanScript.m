clear Path
Path='C:\Users\Kyle\Documents\MATLAB\Temp Data Storage\02262021\Fluo\4.90W\';

FolderNames = dir(Path);

TimedScans = strncmp('Time',{FolderNames.name},4);
% TotalMat100 = [];
j = 0;
for ii = 1:length(TimedScans)
    if TimedScans(ii)
        j = j + 1;
        [DataMat5W.(genvarname(['Scan' num2str(j)])),DataMat5W(2).(genvarname(['Scan' num2str(j)])),Index,DataMat5W(3).(genvarname(['Scan' num2str(j)]))] =...
            LoadTimeScanImages([FolderNames(ii).folder '\' FolderNames(ii).name],0);  % DataMat(1) == images; DataMat(2) == Stage positions; DataMat(3) == Images per stage position
        [Rat5W.(genvarname(['Scan' num2str(j)]))] = Ani_Simple_Mat(DataMat5W.(genvarname(['Scan' num2str(j)])),ctFl,Mask,0.0245,1,2);
        DataMat5W(4).(genvarname(['Scan' num2str(j)])) = (SPV5W.(genvarname(['Scan' num2str(j)])) - 1.47)*20/3; % DataMat(4) == time
    end
end