function out = eeg_words(eeg,wordLength)

%EEG_WORDS - encode an EEG set as words
%
% function eeg = eeg_words(eeg,wordLength)
%
% Convert an EEG set to words of given length.
%
% Input:
%	eeg = EEG-set 
%	wordLength = length of words
%
% Output:
%	eeg = EEG-set (encoded as words)
%
% requires: 
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

% average reference the EEG data

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

% I/O check
if (nargchk(2,2,nargin)), help(mfilename),return; end
if (nargchk(0,1,nargout)), help(mfilename),return; end

for i = 1:size(eeg,1)
	for j = 1:size(eeg,3)
		
		out(i,:,j) = sym2words(squeeze(eeg(i,:,j)),wordLength);
	
	end
end
