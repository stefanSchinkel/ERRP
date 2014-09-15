function [varargout] = eeg_eps(varargin)

% EEG_EPS - estimate RQA threshold of EEGset
%
% function [varargout] = eeg_crqa(eeg,dim,tau,epsFactor,method)
%   
%
% Required inputs:
%	eeg :   EEG-data (chan x frame x trial)
%   dim	:	embedding dimesion 
%   tau	:	embedding delay
%	epsFactor: fraction of max(PSS)
%   method	: method for neighbour detection (def: 'max')
%	maxnorm     - Maximum norm.
%	euclidean   - Euclidean norm.
%	minnorm     - Minimum norm.
%	nrmnorm     - Euclidean norm between normalized vectors
%	maxnorm     - Maximum norm, fixed recurrence rate.
%	fan         - Fixed amount of nearest neighbours.
%	inter       - Interdependent neighbours.
%	opattern    - Order patterns recurrence plot.
%
% Output:
%   eps	= chan X trial array containing estimated eps value
%
% Requires: CRPtool, eeg_crqa
%
% See also: CRPtool, ERRP

%
% Copyright (C) 2008 Stefan Schinkel, schinkel@agnld.uni-potsdam.de 
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

%error identifiers
errID = 'ERRP:eeg_eps:missingParams';


% debug settings
debug = 1;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(1,5,nargin))

%% check number of out arguments
error(nargoutchk(0,2,nargout))

varargin{6} = [];

if ~isempty(varargin{1}),data = varargin{1}; 	else error(errID,'No data supplied'); end
if ~isempty(varargin{2}),dim = varargin{2}; 	else error(errID,'No dimension supplied'); end
if ~isempty(varargin{3}),tau = varargin{3}; 	else error(errID,'No tau supplied'); end
if ~isempty(varargin{4}),epsFactor = varargin{4}; 	else error(errID,'No epsFactor supplied'); end
if ~isempty(varargin{5}),norm = varargin{5}; 	else norm = 'max'; end



% get common params
nChans = size(data,1);
nTrials = size(data,3);
	
%loop over the data, by trial
for i = 1:nChans
	for j = 1:nTrials 
		eps(i,j) = pss(double(data(i,:,j)),norm) *epsFactor;
	end
end 


varargout{1} = eps;

