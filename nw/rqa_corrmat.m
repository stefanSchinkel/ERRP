function [varargout]= rqa_corrmat(varargin)

%RQA_CORRMAT (weighted) Correlation matrix of an RQA set
%
% function [corrmat] = rqa_corrmat(eeg,measure [,trial,dmat,t0,t1])
%
% Computed a weighted correlation matrix of an RQA set 
% for a given RQA measure in selected trial(s). 
% If more than one trial is selected
% the average over trials is used. 
%
% The correlation can weighted by a distance matrix, if
% one is provided, otherwise the matrix is not weighted. 
% Further the matrix can be limited to an interval. If
% no interval is given, the whole time is considered.
%
% Input:
%	eeg = EEG set (chan x time x trial)
%	measure = RQA measure (numerical)
%
% Options:
%	trial = trials to be considered
%	distMat = distance matrix (def: ones)
%	t0 = begin of interval (def: 0)
%	t1 = end of interval (def: end)
%
% Output:
%	corrmat = correlation matrix
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

% $Log:$
%error identifiers
errID = 'ERRP:nw:rqa_corrmat';

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(2,6,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))

%% check if wrong function was called
if ndims(varargin{1}) == 3;
	error(errID, 'Data shape not matching. Try eeg_corrmat for EEG data');
end

%% check and assing input
varargin{6} = [];
if isempty(varargin{1}), error(errID,'No Data provided');	else rqa = varargin{1};		end
if isempty(varargin{2}), error(errID,'No measure selected');else measure = varargin{2};	end
if isempty(varargin{3}), trials = 1:size(rqa,3);			else trials = varargin{3};	end
if isempty(varargin{4}), distMat =[];				 		else distMat = varargin{4};	end
if isempty(varargin{5}), t0 = 1; 							else t0 = varargin{5};		end
if isempty(varargin{6}), t1 = size(rqa,2); 					else t1 = varargin{6};		end

% extract measure & timeWindow
rqa = mean(rqa(:,t0:t1,trials,measure),3);

%construct correlation matrix
corrMat = corrcoef(rqa');

%check distancematrix
if isempty(distMat)
	distMat = ones(size(rqa,1)) - eye(size(rqa,1));
end


%normalise the distance matrix
distMat = distMat / max(max(distMat));

%apply weighting matrix
corrMat = corrMat .* distMat;

if 	nargout
	varargout{1} = corrMat;
else
	figure;
	surf(corrMat);
	view(2);
	axis tight;
	shading flat;
	colorbar;
end

