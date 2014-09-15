function varargout = eeg_delay(eeg,nBins)

%EEG_DELAY - estimate embedding delay for EEG
%
% function [mode mean median all] = eeg_delay(eeg,nBins)
%
% Estimate the embedding delay of an EEG set per channel
% 
% Input:
%	eeg = eeg-set (channel x time x trial)
% Parameters:
%	nBins = no. of bins used in histogrammes (def: 100)
%
% Output:
%	mode = mode of estimated delays (1 per channel)
%	mean = mean of estimated delays (1 per channel)
%	median = median of estimated delays (1 per channel)
%	all = all delays (channel x trials)
%
% requires: estDelay.m
%
% see also: ERRP
%

% Copyright (C) 2008 Stefan Schinkel, University of Potsdam
% http://www.agnld.uni-potsdam.de 
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

% $Log$

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(1,3,nargin))

% check if we use the default bin size or not
if nargin < 2, nBins = 100; end
%% check number of out arguments
error(nargoutchk(0,4,nargout))

delay = ones(size(eeg,1),size(eeg,3));

% loop trialwise
for i=1:size(eeg,1)
	for j=1:size(eeg,3)
		delay(i,j) = estDelay(double(eeg(i,:,j)),[],nBins);
	end
end

varargout{1} = mode(delay,2);
varargout{2} = mean(delay,2);
varargout{3} = median(delay,2);
varargout{4} = delay;
