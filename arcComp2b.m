function [mask0,mask1,qmapOUT] = arcComp2b(dq,cent,theta0,s1,s2,s3);
if isempty(theta0)
    theta0=0;
end
%s1=2.2;s2=2.5;s3=3;
N=1024;
phi=pi/6;
sz=[N N];
if isempty(cent)
    cent=[round(sz(1)/2) round(sz(2)/2)];
end

x1=(-N/2+1):N/2;
y1=(-N/2+1):N/2;
[xx1,yy1]=meshgrid(x1,y1);
[theta1,rho1]=cart2pol(xx1,yy1);
qmap1=rho1*dq;
qmapOUT=zeros(N,N);
x=(-min(sz(2)-cent(2),cent(2)-1)+1):(min(sz(2)-cent(2),cent(2)-1));
y=(-min(sz(1)-cent(1),cent(1)-1)+1):(min(sz(1)-cent(1),cent(1)-1));
[xx,yy]=meshgrid(x,y);
[theta,rho]=cart2pol(xx,yy);
theta=theta+pi;
qmap=rho*dq;
qmap=interp2(xx1,yy1,qmap1,xx,yy);

holder=ones(size(theta));
holder(theta<(pi/2-phi))=0;
holder(theta>(pi/2+phi))=0;
holder2=holder;
holder(qmap<s1)=0;
holder(qmap>s2)=0;
holder2(qmap>s3)=0;
holder2(qmap<s2)=0;
holder=holder+flipud(holder);
holder=imrotate(holder,theta0,'crop');
holder2=holder2+flipud(holder2);
holder2=imrotate(holder2,theta0,'crop');
out1=zeros(sz);out2=out1;
if sz(1)/2-cent(1) > 0
    if sz(2)/2-cent(2) > 0
        out1(1:length(y),1:length(x))=out1(1:length(y),1:length(x))+holder;
        out2(1:length(y),1:length(x))=out2(1:length(y),1:length(x))+holder2;
        qmapOUT(1:length(y),1:length(x))=qmapOUT(1:length(y),1:length(x))+qmap;
    else
        out1(1:length(y),(end-length(x)+1):end)=out1(1:length(y),(end-length(x)+1):end)+holder;
        out2(1:length(y),(end-length(x)+1):end)=out2(1:length(y),(end-length(x)+1):end)+holder2;
        qmapOUT(1:length(y),(end-length(x)+1):end)=qmapOUT(1:length(y),(end-length(x)+1):end)+qmap;
    end
else
    if sz(2)/2-cent(2) > 0
        out1((end-length(y)+1):end,1:length(x))=out1((end-length(y)+1):end,1:length(x))+holder;
        out2((end-length(y)+1):end,1:length(x))=out2((end-length(y)+1):end,1:length(x))+holder2;
        qmapOUT((end-length(y)+1):end,1:length(x))=qmapOUT((end-length(y)+1):end,1:length(x))+qmap;
    else
        out1((end-length(y)+1):end,(end-length(x)+1):end)=out1((end-length(y)+1):end,(end-length(x)+1):end)+holder;
        out2((end-length(y)+1):end,(end-length(x)+1):end)=out2((end-length(y)+1):end,(end-length(x)+1):end)+holder2;
        qmapOUT((end-length(y)+1):end,(end-length(x)+1):end)=qmapOUT((end-length(y)+1):end,(end-length(x)+1):end)+qmap;
    end
end
out=holder;
mask0=out1+out2;
mask1=out1-out2;
