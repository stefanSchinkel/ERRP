function out = eeg_cicompare(cis1,cis2)

%EEG_CICOMPARE - compares CIs of two EEGCI-sets
%
% function out = eeg_cicompare(EEGCIS1,EEGCIS2)
%
% The function compares two EEGCI-sets (output of eeg_bootstrap)
% and encodes their relation analogue to cicompare.m
%
%	X > Y = -1
%	X = Y = 0
%	Y > X = 1 
% 
%  With the default pcolor colourmap that ensures that X > Y is 
%  is blue, X=Y is green and Y > X is red in a pcolor plot 
%  (which will be shown if no output is required)
%
% Input:
% 	EEGCI1 = first EEGCI-set
% 	EEGCI2 = second EEGCI-set
%
% Parameters:
%
% Output:
%	out = colour-coded comparison framewise and by 
%	      channels analogue to cicompare.m
%
% requires: cicompare.m
%
% see also: eeg_bootstrap.m (ERRP)


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

% I/0 check

if ndims(cis1) ~= 3, error('Need EEGCI-set');end
if ~isequal(size(cis1),size(cis2)), error('Need EEGCI-sets of same size');end

% loop over channels and feed to cicompare.m
% squeezed data has to be rotated !!!
for i=1:size(cis1,1)
	out(i,:) = cicompare(squeeze(cis1(i,:,:))',squeeze(cis2(i,:,:))');
end
