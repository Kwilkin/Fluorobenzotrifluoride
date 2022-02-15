function [Atoms] = readKyInternalCoor(filePath);
% Takes the internal coodinates in filePath 

fileID = fopen(filePath);
Coor = textscan(fileID,'%s %s %s %s %s %s %s %*[^\n]');
fclose(fileID);

l= size(Coor{1},1);

varFlag1 = 0;
varFlag2 = 0;
sanityFlag = 0;
varFlag = 1;
while varFlag
    if strcmp(Coor{1}(varFlag),'%%%')
        varFlag = varFlag + 1;
        if ~varFlag1
            varFlag1 = varFlag;
        else
            varFlag2 = varFlag;
            break
        end
    else
        varFlag = varFlag + 1;
    end
    sanityFlag = sanityFlag + 1;
    if sanityFlag == 1000
        error('You either have a lot of comments or this function is broken.')
    end
end

for ii = varFlag1:varFlag2 - 2
    eval([Coor{1}{ii} Coor{2}{ii} Coor{3}{ii}])
end
% 
% nAtoms = l - varFlag2 + 1;

Atoms(1).Posi = [0,0,0]; % Initial atom set at origin

Atoms(1).Type = Coor{3}{varFlag2}; 

indexVec = varFlag2 + 1:l;
for ii = 1:length(indexVec)
    aNum = ii + 1;
    
    Atoms(aNum).Type = Coor{3}{indexVec(ii)}; 
    
    Branch = str2double(Coor{2}{indexVec(ii)}) + 1;

    rad = str2double(Coor{4}{indexVec(ii)});
    if isnan(rad)
        eval(['rad = ' Coor{4}{indexVec(ii)} ';']);
    end
    Atoms(aNum).Posi = [0,0,rad]; % Initially set the atom along the Z axis
    
    theta = str2double(Coor{5}{indexVec(ii)}); % Angle from vertical Z axis
    if isnan(theta)
        eval(['theta = ' Coor{5}{indexVec(ii)} ';']);
    end
    
    phi = str2double(Coor{6}{indexVec(ii)}); % Polar angle about Z axis
    if isnan(phi)
        eval(['phi = ' Coor{6}{indexVec(ii)} ';']);
    end
    
    RotM = [cosd(phi) -sind(phi)*cosd(theta) sind(phi)*sind(theta); sind(phi) cosd(phi)*cosd(theta) -cosd(phi)*sind(theta); 0 sind(theta) cosd(theta)]; % Rotate about x then z
    
    Atoms(aNum).Posi = (RotM*Atoms(aNum).Posi')' + Atoms(Branch).Posi; % Rotate atom to correct angle;
end
