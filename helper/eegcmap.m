function cmap = eeg(M)


% EEG -- blue to red colormap for EEG plots
%
% function cmap = eeg((M)
%
% Construct a colourmap with M levels going from 
% blue to red via white. Such a map is commonly used
% for EEG topography plots. It can be use just like 
% any other colormap: >>colormap(eeg)
%
% Adapted from Matlab FileExchange (FEX File ID: #25536)
%
% Input:
%	m =  no of levels (def: 128)
%
% Output:
%	lines = M-by-3 matrix
%
% requires: 
%
% see also: 
%

% I/O check
if nargin < 1
	M = 128;
end

% the actual map
n = fix(0.5*M);
r = [(0:1:n-1)/n,ones(1,n)];
g = [(0:n-1)/n, (n-1:-1:0)/n];
b = [ones(1,n),(n-1:-1:0)/n];
cmap = [r(:), g(:), b(:)]; 
