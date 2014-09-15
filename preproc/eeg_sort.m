function [varargout]= eeg_sort(varargin)

%EEG_SORT sort trials in an EEG/RQA set by reation times
%
% function [eeg] = eeg_sort(eeg,rts)
%
% The function sorts an EEG set by reaction times
% as provided. 
% 
% Input:
%	eeg = EEG set (chan x time x trial)
%	rts = array of reaction times
%
% Output:
%	eeg = sorted EEG set
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
errID = 'ERRP:preproc:eeg_sort';

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(2,2,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))


%% check and assing input
varargin{3} = [];
if isempty(varargin{1}); error(errID,'Need EEG/RQA set');else eeg = varargin{1};end
if isempty(varargin{2}); error(errID,'Need Reaction Times');else rts = varargin{2};end


% sort RTs
[a b] = sort(rts);

%return sorted array to caller
if ndims(eeg) == 3
	varargout{1} = eeg(:,:,b);
else
	varargout{1} = eeg(:,:,b,:);
end
