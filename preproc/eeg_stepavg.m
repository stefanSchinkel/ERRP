function varargout = eeg_stepavg(eeg,step)

%EEG_STEPAVG - stepwise averaging on EEG
%
% function EEG = eeg_stepavg(eeg,step)
%
% Estimate the embedding dimension of an EEG set per channel
% 
% Input:
%	eeg = eeg-set (channel x time x trial)
%	step = number of trials to be averaged
%
% Output:
%	eeg = eeg-set (channel x time x trial/step)
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

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(2,2,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))

cnt = 1;
% loop trialwise
for i=1:step:size(eeg,3)-step
	out(:,:,cnt) = mean(eeg(:,:,i:i+step),3);
	cnt = cnt+1;
end

varargout{1} = out;
