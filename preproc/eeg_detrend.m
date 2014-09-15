function [eeg]= eeg_detrend(eeg)

%EEG_DETREND - detrend eeg-set
%
% function [eeg] = eeg_detrend(eeg)
%
% Remove linear trends from every measurement
% of an eeg-set.
% 
% Input:
%	eeg = eeg-set (trial x time x channel)
%
% Output:
%	eeg	= detrended eeg-set 
%
% requires: 
%
% see also:ERRP
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
error(nargchk(1,2,nargin))

%% check number of out arguments
error(nargoutchk(1,2,nargout))

%% loop trialwise
for i=1:size(eeg,1)
	for j=1:size(eeg,3)
		eeg(i,:,j) = detrend(eeg(i,:,j));
	end
end

varargout{1} = eeg;
