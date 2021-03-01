function [DiffIm] = QuarterScan(Scan,Num1,Num2,Mask,ct)
%% Quarter averages two images in a scan and gives the dI/Iat. Num1 and Num2
% should be the index of the two images you want the difference of 
% Num2 - Num1


Peak = (Scan(:,:,Num2));
[QI] = quarterAverage(Peak.*Mask,round(ct));
[Peak] = unpackQuarterImage(QI);
[Peak] = FillCenterPolar(Peak);

Static = (Scan(:,:,Num1));
[QI] = quarterAverage(Static.*Mask,round(ct));
[Static] = unpackQuarterImage(QI);
[Static] = FillCenterPolar(Static);

% Pw = wiener2(Peak, [25 25]);
% Sw = wiener2(Static, [25 25]);
Pw = medfilt2(Peak,[12 12]);
Sw = medfilt2(Static,[12 12]);
Dw = Pw - Sw;
% Dw = wiener2(D-mean(mean(D,'omitnan')), [25 25]);
Path = 'C:\Users\Kyle\Documents\MATLAB\Coordinates\C7H4F4.xyz';
[~,~,I_at,~] = Diffraction90keV(Path,ct);
[QI] = quarterAverage(I_at,round(ct));
[Iat] = unpackQuarterImage(QI);
% DiffIm = Dw./Iat;
DiffIm = Dw./Static;
figure;imagesc(DiffIm)
caxis([-2 2])