function quickCenterCheck(Image,center)
sz=size(Image);

[XX,YY] = meshgrid((1:sz(2))-center(2),(1:sz(1))-center(1));
[~,R] = cart2pol(XX,YY);
Check = ones(sz(1),sz(2));
Check(R<65) = 0;
figure;imagesc(Image.*Check)