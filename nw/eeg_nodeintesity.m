function varargout = eeg_nodeintensity(eeg,ws,varargin)


%EEG_NODEINTENSITY - time windowed node intesity of an EEGset
%
% function eeg_nodeintensity(eeg,ws[,ss,trial, distMatrix)
%
% Timesliced nodeintensity of an EEG-set. The data is
% averaged over trials/epochs.
%
% Input:
%	eeg	= EEG-set 
%	ws	= window size
%
% Parameters
%	ss = step size (default : 1)
%	trials = trials to be considered	(default : all)
%	distMat = distance matrix to weight correlation matrix 
%
%	see eeg_cormat for distMatrix details.
%
% Output:
%	nodes = chan x trial set of node intensities
%
% requires: eeg_corrmat.m, nodeIntensity.m
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

% I/O check
if (nargchk(2,5,nargin)), help(mfilename),return; end
if (nargchk(0,1,nargout)), help(mfilename),return; end

varargin{4} = [];
if ~isempty(varargin{1}), ss = varargin{1};else ss = 1;end
if ~isempty(varargin{2}), trials = 1:varargin{2};else trials = [];end
if ~isempty(varargin{3}), distMat = varargin{3};else distMat = [];end


idx = (ws/2:ss:size(eeg,2)-ws/2)+1;
for i=1:length(idx)

	r = eeg_corrmat(eeg(:,idx(i)-ws/2:idx(i)+ws/2,:),trials,distMat);
	out(i,:) = nodeIntensity(r);

end

varargout{1} = out';
