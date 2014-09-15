function eeg = eeg_avgref(eeg,varargin)

%EEG_AVGREF - re-reference EEG data to average reference
%
% function eeg = eeg_avgref(eeg)
%
% Convert an EEG set to average reference, thereby 
% re-gaining the genuine reference. The optional value
% chan determines iff the reference will be included in 
% the dataset or not.
% 	chan = 0 -> reference in set
%	chan = int(n) -> reference will be placed as channel n
%	chan = [] -> reference will be appended to end
%
%
% Input:
%	EEG = eeg-set (chan x time x trial OR chan x time)
%	chan = index of channel to reference

% Output:
%	EEG = eeg-set (chan x time x trial OR chan x time) + 1 channel
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

%% check number of input arguments
error(nargchk(0,2,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))


%% check && assign input
varargin{2} = [];
if ~isempty(varargin{1}), chan = varargin{1}; else chan = [];end

% no. of chans
nChans = size(eeg,1);

%switch for epochized data
if ndims(eeg) == 3

	%disp('Running on epochised data')
	
	if chan == 0

		%do nothing
		pass =1;

	elseif	isempty(chan)

		% when chan is empty, reference will be appended
		eeg(nChans+1,:,:) = 0;

	else

		%all zeros to fill
		filler = zeros(1,size(eeg,2),size(eeg,3));
		% concat array
		eeg = cat(1,eeg(1:chan-1,:,:),filler,eeg(chan:end,:,:));
	end

	%loop over trials and substract average
	for i=1:size(eeg,3)
		y = mean(eeg(:,:,i));
		for j = 1:nChans
			eeg(j,:,i) = eeg(j,:,i) - y;
		end
	end


elseif ndims(eeg) == 2


	%disp('Running on continous data')
	
	if chan == 0

		%do nothing
		pass =1;

	elseif	isempty(chan)

		% when chan is empty, reference will be appended
		eeg(nChans+1,:) = 0;

	else

		%all zeros to fill
		filler = zeros(1,size(eeg,2));
		% concat array
		eeg = cat(1,eeg(1:chan-1,:),filler,eeg(chan:end,:));
	end

	%loop over channels and substract average
	for i=1:size(eeg,1)
		y = mean(eeg);		
			eeg(i,:) = eeg(i,:) - y;
		end
	end
end
