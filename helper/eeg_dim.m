function varargout = eeg_dim(eeg,delay)

%EEG_DIM - estimate embedding dimension for EEG
%
% function [mode mean median all] = eeg_dim(eeg [,tau])
%
% Estimate the embedding dimension of an EEG set per channel
% 
% Input:
%	eeg = eeg-set (channel x time x trial)
%
% Output:
%	mode = mode of estimated dimensions (1 per channel)
%	mean = mean of estimated dimensions (1 per channel)
%	median = median of estimated dimensions (1 per channel)
%	all = all estimated dimensions (channel x trials)
%
% requires: ERRP
%
% see also: ERRP
%

% Copyright (C) 2012 Stefan Schinkel, HU Berlin
% http://people.physik.hu-berlin.de/~schinkel
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
error(nargchk(1,2,nargin))

%% check number of out arguments
error(nargoutchk(0,4,nargout))

%% do we have a delay? 
if nargin <  2
	delay = [];
end
	

dim = ones(size(eeg,1),size(eeg,3));

% loop trialwise
for i=1:size(eeg,1)
	for j=1:size(eeg,3)
		dim(i,j) = estDim(double(eeg(i,:,j)),[],delay);
	end
end

varargout{1} = mode(dim,2);
varargout{2} = mean(dim,2);
varargout{3} = median(dim,2);
varargout{4} = dim;
