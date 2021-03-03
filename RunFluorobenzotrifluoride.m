function [StructOut] = RunFluorobenzotrifluoride(StructIn);
%% Remove noise and combine images for Fluorobenzotrifluoride
% Input should be the DataMat structure from ScanScript
% DataMat(1) == images; DataMat(2) == Stage positions; DataMat(3) == Images per stage position
% DataMat(3) == Images per stage position; DataMat(4) == time

