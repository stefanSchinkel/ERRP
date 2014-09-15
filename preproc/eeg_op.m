function out = eeg_op(eeg,dim,tau)

%EEG_OP - encode an EEG set as order patterns
%
% function eeg = eeg_op(eeg,dim,tau)
%
% Convert an EEG set to order patterns with the given
% dimension and delay.
%
%
% Input:
%	EEG = eeg-set 
%	dim = dimension (times of points considered)
%	tau = embedding delay (distance between points)
%
% Output:
%	EEG = eeg-set 
%
% requires: 
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

% average reference the EEG data

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

% I/O check
if (nargchk(3,3,nargin)), help(mfilename),return; end
if (nargchk(0,1,nargout)), help(mfilename),return; end

nChans = size(eeg,1);
nTrials = size(eeg,3);

if length(dim) == 1, dim = ones(1,nChans)*dim;end
if length(tau) == 1, tau = ones(1,nChans)*tau;end


out = zeros(nChans,size(eeg,2) - (max(dim)-1) * max(tau));


for i = 1:nChans
	for j = 1:nTrials
		
		t = opCalc(squeeze(eeg(i,:,j)),dim(i),tau(i));
		out(i,1:length(t),j) = t;
	
	end
end
