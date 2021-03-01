% Help
% This fuctions calculates the azimuthal average for electron diffraction
% patterns.
%taking the center of the image as centery,centerx.

% Input: 
%   A = an image (2D array) 
%   Note: the pixels in A to be ignored can be set to NaN
%   centerx and centery = center of the pattern in pixel numbers
%   Rmax = the maximum radius to integrate, if given zero value it
%   integrates to the nearest end of the image, if -1 to the farthest end
%   of the image
%   Correct_Factor = Number of standard deviations which values outside of are ignored 

% Output: rc - Array of average radial values. (1D)
%         numberc - Array of the number of points used for each radial value. (1D)
%         Asm - A subtracted from mean (2D)
%         Asm - A subtracted from mean then divided by the mean (2D)
%         Ac - A with the values outside Correct_Factor for each radius removed (2D)
%         stand_dev - The standard deviation as a function of radius (1D)
% Martin Centurion, 9-30-2006
% Last edited Kyle Wilkin 2-7-2020

function [rc,numberc,Asm,Adm,Ac,stand_dev]=SubtractRadialMean(A,centerx,centery,Rmax, Correct_Factor);

%Correct_Factor = 3;   % How many std away a pixel needs to be to be
%removed.

[y,x]=size(A);
Ac=A;



% Calculate the maximum integration radius if given Rmax=0 or Rmax=-1.
% Use the closest edge of the image.
if Rmax == 0
    Rmax=min([y-centery, centery, x-centerx, centerx]);
end

% Use the far edge of the image.
if Rmax == -1
    Rmax=max([y-centery, centery, x-centerx, centerx]);
end

r=(1:Rmax)*0;
sigma=r;
rc=r;
number=r;
numberc=number;

% Calculate the mean value for each radius
for m=1:y
    for n=1:x
        radius=int16(sqrt((m-centery)^2+(n-centerx)^2)+1);
        if ( (radius <= Rmax) &&  ~(isnan(A(m,n)))  )
            number(radius)=number(radius)+1;
            r(radius)=r(radius)+A(m,n);
        end
    end
end
r=r./number;

% Calculate the standard deviation for each radius.
for m=1:y
    for n=1:x
        radius=int16(sqrt((m-centery)^2+(n-centerx)^2)+1);
        if ( (radius <= Rmax) &&  ~(isnan(A(m,n)))  )
            sigma(radius)=sigma(radius)+(A(m,n)-r(radius))^2;
        end
    end
end
stand_dev=sqrt(sigma./number);

for m=1:y
    for n=1:x
        radius=int16(sqrt((m-centery)^2+(n-centerx)^2)+1);
        if ( (radius <= Rmax) &&  ~(isnan(A(m,n)))  )
            if ( (A(m,n) <= r(radius)+Correct_Factor*stand_dev(radius)) && (A(m,n) >= r(radius)-Correct_Factor*stand_dev(radius)) )
            numberc(radius)=numberc(radius)+1;
            rc(radius)=rc(radius)+A(m,n);
            else
                Ac(m,n)= NaN;
            end 
        end
    end
end
rc=rc./numberc;
rc(1)=r(1); % Added because numberc(1) is always 0

Asm=zeros(size(A));Adm=Asm;
for m=1:y
    for n=1:x
        radius=int16(sqrt((m-centery)^2+(n-centerx)^2)+1);
        if ( (radius <= Rmax) &&  ~(isnan(A(m,n)))  )
            Asm(m,n)=A(m,n)-rc(radius);
            Adm(m,n)=(A(m,n)-rc(radius))/rc(radius);
        else
            Asm(m,n)= NaN;
            Adm(m,n)=NaN;
        end
    end
end
% Smoothing - running average with smoothing window W
%W=9;
%r=filter(ones(1,W)/W,1,r);



