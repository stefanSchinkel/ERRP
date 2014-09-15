function EEG = eeg_filter(EEG,varargin)

%EEG_FILTER zero-phase filter an EEG set 
%
% function [EEG] = eeg_filter(EEG,numerator [,denominator])
%
% Filter an EEG set with the filter decribed by numerator and
% denominator supplied (B and A in terms of filtfilt.m). 
% If no denominator is supplied '1' is used. 
%
% Use fdesign/fdatool for filter construction
%
% Input:
%  EEG      = EEG set (chan x time x trial OR chan x time)
%  numerator   = numerator (B)
%  denominator = denominator (A)
%
% Output:
%  EEG      = filtered EEG set
%
% requires: filtfilt.m (Signal Processing Toolbox)
%
% see also: ERRP, fdstool, Signal Processing Toolbox
%
% References:


% Copyright (C) 2010 Stefan Schinkel, University of Potsdam
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
error(nargchk(2,3,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))

% prevent indexation errors
varargin{3}=[];

% assign parameters
if isempty(varargin{1}), error('Need at least numerator');else B = varargin{1};end
if ~isempty(varargin{2}), A = varargin{2};else A = 1;end

if ndims(EEG) == 2,

	%loop through data
	for i = 1:size(EEG,1) %chans
			EEG(i,:) = filtfilt(B,A,EEG(i,:));
	end
else

	%loop through data
	for i = 1:size(EEG,1) %chans
		for j = 1:size(EEG,3) %trials
			EEG(i,:,j) = filtfilt(B,A,EEG(i,:,j));
		end
	end
end
