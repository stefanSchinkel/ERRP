function [eeg]= eeg_baseline(varargin)

%EEG_BASELINE baseline correct an EEG set
%
% function [eeg] = eeg_baseline(eeg,tScale,t0[,t1])
%
% Baseline-align an eeg set. The baseline interval can
% be provided as a whole or just as the pre-stimulus 
% time. 
% 
% Input:
%	eeg = eeg-set (chan x time x trial)
%	tScale = time scale of epoch
%	t0 = begin of baseline interval
%	t1 = end of baseline interval 
%
% Output:
%	eeg = baseline corrected eeg-set
%
% requires: 
%
% see also: ERRP
%

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

% $Log: eeg_baseline.m,v $
% Revision 1.1  2008/03/03 14:35:38  schinkel
% Initial Import
%

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(3,4,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))


%% check and assing input
varargin{5} = [];
if 2 <= ndims(varargin{1}) & ndims(varargin{1}) <=3 ;eeg = varargin{1};else error('Wrong data size'); end
if ~isvector(varargin{2}), error('Timescale has to be a vector');else tScale = varargin{2};end
if isempty(varargin{3}),error('Need at least a pre-stimuslus time');else t0=-abs(varargin{3});end
if isempty(varargin{4}),t1=0;else t1= varargin{4};end

%% get and check params
nChans = size(eeg,1);
if size(eeg,2) ~= length(tScale);error('Timescale and datalength not matching');end

% find indices
indt0 = find(tScale == t0);
indt1 = find(tScale == t1);

if isempty(indt0),error('Could not find t0 in time scale');end
if isempty(indt1),error('Could not find t1 in time scale');end

%% vectorise it later.
for i = 1:nChans
	for j = 1:size(eeg,3)
		baseLine = mean(eeg(i,indt0:indt1,j));
		eeg(i,:,j) = eeg(i,:,j) - baseLine;
%		d=squeeze(eeg(i,:,:))';
%		a=ones(length(tScale),1);
%		b=mean(d(indt0:indt1,:));% baseline average
%		d=d-(a*b);
%		out(i,:,:)=d';
	end
end 




