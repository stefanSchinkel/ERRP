function eeg = eeg2mat(headerDir,headerFile)

% FUNCTION EEG = EEG2MAT(DIR,FILE)
%
% Convert Brain Vision Data File (.eeg) to 
% a Matlab Array using EEGlab (bvaio-plugin)
%
% Input: 
%	DIR = directory holding file
%	FILE = Brain Vision Header File (.vhdr)
%
% Output:
%	eeg = chan x time Matlab Array
%
% Requires: 
%	EEGlab with bvaio-plugin
%

EEG = pop_loadbv(headerDir,headerFile);  
eeg = EEG.data;
