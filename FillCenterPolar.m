function [Image] = FillCenterPolar(Image);

sz = size(Image);

rRez = round(max(sz)/2);

imP = ImToPolar (Image, 0, 1, rRez, 360*2);

imP2 = imP;
imP2(1,:) = 0;
for ii = 1:size(imP,2)
    xv = [1 sum(isnan(imP(1:200,ii)))+1:sum(isnan(imP(1:200,ii)))+10+1];
    bb=interp1(xv,imP2(xv,ii),1:sum(isnan(imP(1:200,ii)))+10+1,'linear');
    imP2(1:sum(isnan(imP(1:200,ii)))+10+1,ii)=bb;
end
imP2(isnan(imP2)) = 0;

Image = PolarToIm (imP2, 0, 1, sz(1) + mod(sz(1),2), sz(2) + mod(sz(2),2)); % Program was breaking if the size was odd.

Image = Image(1:end - mod(sz(1),2), 1:end - mod(sz(2),2)); % Make the size of the output the same as the input.