function EEG = eeg_lowpass(EEG,cutoff,sampRate,varargin)

%EEG_LOWPASS low-pass filter an EEG set
%
% function [EEG] = eeg_lowpass(EEG,cutoff,sampRate[,order])
%
% Lowpass filter an EEG set at the given cutoff frequency using 
% a Butterworth filter of a given order. The sampling rate has 
% to be given. The order is not mandatory.
%
%
% Input:
%  EEG      = EEG set (chan x time x trial OR chan x time)
%  cutoff   = cutoff frequency
%  sampRate = sampling rate
%  order    = order used for butterworth filter
%
% Output:
%  EEG      = low-pass filtered EEG set
%
% requires: lowPass.m (ERRP/helper)
%
% see also: ERRP
%
% References:


% Copyright (C) 2009 Stefan Schinkel, University of Potsdam
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
debug=0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(3,4,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))

% prevent indexation errors
varargin{1}=[];

% assign parameters
if ~isempty(varargin{1}), order = varargin{1};else order = 4;end

if ndims(EEG) == 2,

	%loop through data
	for i = 1:size(EEG,1) %chans
			EEG(i,:) = lowPass(EEG(i,:),cutoff,sampRate,order);
	end
else

	%loop through data
	for i = 1:size(EEG,1) %chans
		for j = 1:size(EEG,3) %trials
			EEG(i,:,j) = lowPass(EEG(i,:,j),cutoff,sampRate,order);
		end
	end
end
