function [Struct,Peak,Rand] = RunFluorobenzotrifluoride(Struct,Block,center);
%% Remove noise and combine images for Fluorobenzotrifluoride
% Input should be the DataMat structure from ScanScript
% DataMat(1) == images; DataMat(2) == Stage positions; DataMat(3) == Images per stage position
% DataMat(3) == Images per stage position; DataMat(4) == time

l = length(fieldnames(Struct));

Peak = zeros(999,999); % Initialize peak image assuming standard size
Rand = zeros(999,999); % Initialize random image assuming standard size
Tot = 0; % Initialize counts for total number of images
for ii = 1:l % Start of the for loop for each scan
    
    if length(size(Struct(1).Scan1)) > 3
        CurrScan = mean(Struct(1).(genvarname(['Scan' num2str(ii)])),4);  % Average the scan.
    else
        CurrScan = Struct(1).(genvarname(['Scan' num2str(ii)]));  % Scan is already averaged.
    end
    
    CurrScanQ = zeros(999,999,size(CurrScan,3)); % Initialize array for quartered and unpacked images. Assumes Standard size used in unpacking.
    for iii = 1:size(CurrScan,3)  % Reduce the noise and normalize
        Thresh = 45000; % Threshold for hot pixels
        CurrScan(CurrScan > Thresh) = NaN;
        [rc,~,~,~,CurrScan(:,:,iii),~]=SubtractRadialMean(CurrScan(:,:,iii).*Block,center(2),center(1),-1, 4);
        Norm = sum(rc(150:300)); % Normalize between pixel range
        if iii == 1
            Norm0 = Norm;
            
        end
        CurrScan(:,:,iii) = Norm0/Norm*CurrScan(:,:,iii); % Normalize but don't want to deal with small numbers to avoid rounding errors.
        [QI] = quarterAverage(CurrScan(:,:,iii).*Block,round(center));
        [CurrScanQ(:,:,iii)] = unpackQuarterImage(QI,1); % Quarter and unpack the images making them centered the same.
    end
    
    [Struct(5).(genvarname(['Scan' num2str(ii)]))] = Ani_Simple_Mat(CurrScanQ,[500 500],ones(999,999),0.0245,1,2); % Do the anisotropy for each timed scan.
    
    Struct(6).(genvarname(['Scan' num2str(ii)])) = find(max(Struct(5).(genvarname(['Scan' num2str(ii)])))==Struct(5).(genvarname(['Scan' num2str(ii)])));
    PeakInd = Struct(6).(genvarname(['Scan' num2str(ii)]));
    
    NumIm = Struct(3).(genvarname(['Scan' num2str(ii)]));
    if PeakInd ~= size(CurrScanQ,3)
        Peak = Peak + NumIm*mean(CurrScanQ(:,:,PeakInd-1:PeakInd+1),3);
    else
        Peak = Peak + NumIm*mean(CurrScanQ(:,:,PeakInd-1:PeakInd),3);
    end
    Rand = Rand + NumIm*CurrScanQ(:,:,1);
    Tot = Tot + NumIm;
    
    Struct(1).(genvarname(['Scan' num2str(ii)])) = CurrScanQ;
    
end
Peak = Peak/Tot;
Rand = Rand/Tot;