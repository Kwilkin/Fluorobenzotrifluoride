clear Path
Path='C:\Users\Kyle\Documents\MATLAB\Temp Data Storage\02252021\Fluo\4.92 W\';

FolderNames = dir(Path);

TimedScans = strncmp('Timed',{FolderNames.name},5);
TotalMat100 = [];
for ii = 1:length(TimedScans)
    if TimedScans(ii)
        [DataMat,SPV,Index] = LoadTimeScanImages([FolderNames(ii).folder '\' FolderNames(ii).name],0);
        TotalMat100 = cat(4,TotalMat100,DataMat);
    end
end