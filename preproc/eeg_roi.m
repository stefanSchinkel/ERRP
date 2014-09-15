function [out] = eeg_roi(eeg,roi)

% EEG_ROI - average EEG data in ROIs
%
% function [eeg] = eeg_roi(eeg,roi)
%   
% Average EEG data according to the defintions
% provided in the struct roi. The struct has
% to have the field: roi. The returned EEG-set
% will be of shape length(roi) x frame x trial.
%
%  inputs:
%	eeg : EEG-set (chan x frame x trial)
%	roi : struct with ROI definitions 
%
% Output:
%   eeg	= EEG-set (roi x frame x trial)
%
%
%
% Requires: 
%
% See also: ERRP

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


% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(2,2,nargin))
error(nargoutchk(0,1,nargout))


for i = 1:length(roi)
	out(i,:,:) = squeeze(mean(eeg(roi(i).chan,:,:)));
end

