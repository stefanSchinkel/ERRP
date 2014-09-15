function rejectEEGlab(inFile,varargin)

%REJECTEEGLAB - reject epochised sets in given file
%
% function rejectEEGlab(inFile,outFile)
%
% Reject measurements from multiple epochised EEGsets 
% stored in inFile using reasonable presets. 
% 
% EEGlab has to be enabled !
%
% Input:
%	inFile = name of file holding EEG-sets
%
% Output:
%	outFile = 	file to store rejected sets in 
%				(if none given, data is not stored)
%
% requires: EEGlab
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
%

% debug settings
debug = 1;
if debug;warning('on','all');else warning('off','all');end

varargin{2} = [];
if ~isempty(varargin{1}), outFile  = varargin{1}; else outFile = [];end

%enable eeglab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

allFiles = who('-FILE',inFile)
t = struct2cell(load(inFile));


for i=1:length(allFiles)


	data = t{i};
	
	theVar = sprintf('%s',allFiles{i});
	
	if debug
		disp(sprintf('Probing data: %s',theVar));
		size(data)
	end

	EEG  = pop_importdata('data',data,'setname','testset');
	%set some params
	EEG.nbchan = size(data,1);
	EEG.pnts =  size(data,2);
	EEG.trials = size(data,3);

	EEG.srate = 1000;
	EEG.xmin = -.4;

	%% make a new set, so EEGlab works properly
	[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, CURRENTSET, 'setname', 'dataset');

%  	%% reject abnormal values by threshhold
	EEG = pop_eegthresh( EEG,1,1:EEG.nbchan, -40, 40,-.3,.8,0,1);

	% reject abnormal by kurtosis
	EEG= pop_rejkurt( EEG, 1, 1:EEG.nbchan,5, 5, 0, 2, 0);

	% reject due to linear trend
	EEG = pop_rejtrend( EEG, 1, 1:EEG.nbchan, 50, 50, .3, 0, 1,0);

	% reject due to improabable values
	EEG = pop_jointprob(EEG, 1,1:EEG.nbchan,5, 5, 1, 1,0);

	eval([theVar ' = EEG.data;'])
	ALLEEG = pop_delset(ALLEEG,[1]);

end

% save the data if requested
if ~isempty(outFile);	save(outFile',allFiles{:});end
