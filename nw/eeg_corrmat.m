function [varargout]= eeg_corrmat(varargin)

%EEG_CORRMAT (weighted) correlation matrix of an EEG set
%
% function [corrmat] = eeg_corrmat(eeg,[,trial, dmat,t0,t1])
%
% Computed a weighted correlation matrix of an EEG set 
% in a selected trial. If more than one trial is selected
% the average over trials is used. 
%
% ‚The shape of the EEG set matches those used in EEGlab. 
% (channel x time x trial)
%
% The correlation can weighted by a distance matrix, if
% one is provided, otherwise the matrix is not weighted. 
% Further the matrix can be limited to an interval. If
% no interval is given, the whole time is considered.
%
% Input:
%	eeg = EEG set (chan x time x trial)
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
% see also: ERRP, rqa_corrmat
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
errID = 'ERRP:nw:eeg_corrmat';

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(1,5,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))

%% check if wrong function was called
if ndims(varargin{1}) == 4;
	error(errID, 'Data shape not matching. Try rqa_corrmat for RQA data');
end


%% check and assing input
varargin{6} = [];
if isempty(varargin{1}), error(errID,'No Data provided');	else eeg = varargin{1};		end
if isempty(varargin{2}), trials = 1:size(eeg,3);			else trials = varargin{2};	end
if isempty(varargin{3}), distMat =[];				 		else distMat = varargin{3};	end
if isempty(varargin{4}), t0 = 1; 							else t0 = varargin{4};		end
if isempty(varargin{5}), t1 = size(eeg,2); 					else t1 = varargin{5};		end

% convert to double & average extract trials and time
eeg = double(mean(eeg(:,t0:t1,trials),3));

%construct correlation matrix
corrMat = corrcoef(eeg');

%check distancematrix
if isempty(distMat)
	distMat = ones(size(eeg,1)) - eye(size(eeg,1));
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

