function cis = eeg_bootstrap(eeg,varargin)

%EEG_BOOTSTRAP - framewise bootstrap of channel CIs of an EEG-set
%
% function EEGCI = eeg_bootstrap(EEG,[nBoot,alpha])
%
% The function bootstraps the channel mean of an EEG-set (
% chan x time x epoch) and returns corresponding two-sided
% alpha/2 confidence intervals. 
%
% Input:
% 	nBoot = number of bootstrap samples (def: 500)
%
% Parameters:
% 	nBoot = number of bootstrap samples (def: 500)
% 	alpha = confidence level in % (def: 5-two-sided)
%
% Output:
%	EEGCI = EEGCI-set (chan x time x 2 (upper/lower percentile))
%
%
% requires: bootstrp.m, prctile.m (Statistics Toolbox)
%
% see also: cicompare.m (ERRP)
%


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


%% I/O check
if (nargchk(1,3,nargin)), help(mfilename),return; end
if (nargchk(0,1,nargout)), help(mfilename),return; end

varargin{3} = [];

% input assignment 
if ~isempty(varargin{1}), nBoot = varargin{1}; else nBoot = 500;end
if ~isempty(varargin{2}), alpha = varargin{2}; else alpha = 5;end

% size check
if ndims(eeg) ~= 3,	error('Need epochised EEG-set');end

% necessary parameters
nChans = size(eeg,1);
confBounds = [100-alpha/2 0+alpha/2];

%loop over channels, bootraping epoch means at each frame

for i = 1:nChans

	bsMeans = bootstrp(nBoot,@(x)[mean(x,2)],squeeze(eeg(i,:,:)));
	% the prctile output is rotated 
	% since people could be using OPtool/prctile.m 
	% which doesnt support DIM arguments
	cis(i,:,:) = prctile(bsMeans,confBounds)';
end





