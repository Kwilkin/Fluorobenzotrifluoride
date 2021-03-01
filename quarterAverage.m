function [QI] = quarterAverage(I,center);


% Get size of image
szx=size(I,2);
szy=size(I,1);

% Get size of quarters based on the center
xLeft = 1:center(2)-1;
xRight = center(2)+1:szx;

yTop = 1:center(1)-1;
yBottom = center(1)+1:szy;

% Make the output the biggest possible size
qSizeY = max(length(yTop),length(yBottom))+1;
qSizeX = max(length(xLeft),length(xRight))+1;

QI = zeros(qSizeY,qSizeX);

% Only one center
QI(end,1) = I(center(1),center(2));

qY = zeros(qSizeY-1,2)+NaN;
qX = zeros(2,qSizeX-1)+NaN;

qY(length(qY)-length(yTop)+1:end,1) = I(yTop,center(2));
qY(length(qY)-length(yBottom)+1:end,2) = flipud(I(yBottom,center(2)));

QI(1:end-1,1) = mean(qY,2,'omitnan');

qX(1,1:length(xRight)) = I(center(1),xRight);
qX(2,1:length(xLeft)) = fliplr(I(center(1),xLeft));

QI(end,2:end) = mean(qX,1,'omitnan');

% |1|2|
% |3|4|
q1 = I(yTop,xLeft);
q2 = I(yTop,xRight);
q3 = I(yBottom,xLeft);
q4 = I(yBottom,xRight);

qHolder = zeros(qSizeY-1,qSizeX-1,4)+NaN;

qHolder(size(qHolder,1)-length(yTop)+1:end,1:length(xLeft),1) = fliplr(q1);
qHolder(size(qHolder,1)-length(yTop)+1:end,1:length(xRight),2) = q2;
qHolder(size(qHolder,1)-length(yBottom)+1:end,1:length(xLeft),3) = rot90(q3,2);
qHolder(size(qHolder,1)-length(yBottom)+1:end,1:length(xRight),4) = flipud(q4);

QI(1:end-1,2:end) = mean(qHolder,3,'omitnan');
    