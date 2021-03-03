function [Rat] = Ani_Simple_Mat(Scan,center,Block,ds,smin,smax);
% smin=1.3;
% smax=1.9;

[maskH,mask2,qmap1] = arcCompQ(ds,center,90,smin,smin,smax);
[maskV,mask2,qmap1] = arcCompQ(ds,center,0,smin,smin,smax);
maskV(~maskV)=NaN;
maskH(~maskH)=NaN;

NumIm = size(Scan,3);
f = waitbar(1/NumIm,'Checking Anisotropy...');

Rat = zeros(1,NumIm);
for i=1:NumIm
%     Ac = Scan(:,:,i);
    [~,~,~,~,Ac,~]=SubtractRadialMean(Scan(:,:,i).*Block,center(2),center(1),-1, 4);
%     Ac(isnan(Ac)) = 1e10;
%     Ac = medfilt2(Ac,[7 7]);
%     Ac(Ac > 1e6) = NaN;
    rV=mean(Ac(:).*Block(:).*maskV(:),'omitnan');
    rH=mean(Ac(:).*Block(:).*maskH(:),'omitnan');
%     Counts = ones(size(Ac));
%     aV = sum(Counts.*Block.*maskV,'all','omitnan');
%     aH = sum(Counts.*Block.*maskH,'all','omitnan');
    Rat(i)=sum((rH - rV)./(rV+rH),'omitnan');
    waitbar(i/NumIm,f,'Checking Anisotropy...');
end
close(f)

% figure;plot(SPU,Rat)