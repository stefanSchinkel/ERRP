function [data meta trigger] = bdfreader(filename,nRecs)

% BDFREADER - simple BDF Reader
%
% function [data meta trigger] = bdfreader(file[,nRecs])
%
% This function reads a given .bdf file and returns
% the data and meta info. If a status channel is present, 
% it also returns the triggers. This is set to work with
% BioSemi for sure. It will return a 3 row array with the
% individual bytes (as uint8). 
%
% IMPORTANT: The function assumes that all channels have the
% same sampling rate. If not it fails. See edfreader() on how
% to handle this.
%
% Input:
%	file = BDF file
%
% Parameters:
%	nRecs = number of records to read (def: all)
%
% Output:
%	data = double array
% 	trigger = array with trigger bytes (as uint8)
%	meta = struct with meta data
%
% requires:
%
% see also: edfreader.m
%
% The BDF+ specs & Calibration signals can be found at:
% http://www.biosemi.com/faq/file_format.htm

% Copyright (C) 2012 Stefan Schinkel, HU Berlin
% http://people.physik.hu-berlin.de/~schinkel/
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


flagDebug = false;

if nargin < 1
	help(mfilename)
	error('ERRP:io:bdfreader','Supply filename');
end

if nargin == 2
	recsToRead = nRecs;
else
	recsToRead = [];
end

% open file for reading
fp = fopen(filename,'r','ieee-le');

if fp == -1
	error('ERRP:io:bdfreader','Could not open BDF file');
end

% read header in on go 256bits ASCII
buffer = char(fread(fp,256)');

meta = struct;

% extract info from header as described in specs
meta.ID =  int16(buffer(1));						% 255 for BDF
meta.identifier =	char(buffer(2:8));				% should be BIOSEMI
meta.patient = buffer(9:88);						% Patient Info
meta.recording = buffer(89:168);					% Record Info
meta.date = buffer(169:176);						% Date of recording
meta.time = buffer(177:184);						% Time of recording
meta.headerLength = str2double(buffer(185:192));	% length of header
meta.version = buffer(193:236);						% reserved part 1
meta.nRecords = str2double(buffer(237:244));		% no of Records (trials)
meta.duration = str2double(buffer(245:252));		% duration of record in seconds
meta.nChans = str2double(buffer(253:256));			% no of channels

% note: all values can be different for each channel!
meta.label = cellstr( char(fread(fp,[16,meta.nChans])') );			% labels
meta.transducer = cellstr(  char(fread(fp,[80,meta.nChans])') );	% sensors
meta.unit =  cellstr( char(fread(fp,[8,meta.nChans])') );			% units
meta.minValue = str2num( char(fread(fp,[8,meta.nChans])') );		% physical max
meta.maxValue = str2num( char(fread(fp,[8,meta.nChans])') );		% physical min
meta.digiMin =  str2num( char(fread(fp,[8,meta.nChans])') );		% digital max
meta.digiMax =  str2num( char(fread(fp,[8,meta.nChans])') );		% digital min
meta.preproc = cellstr(  char(fread(fp,[80,meta.nChans])') );		% preprocessing
meta.samplePerRecord = str2num( char(fread(fp,[8,meta.nChans])') );	% samples/frames
meta.reserved2 = char(fread(fp,[32,meta.nChans])');					% reserved part 2


% check if all records have sampling rate
% if not - give up (for now) 
if 1 ~= numel(unique(meta.samplePerRecord))
	help(mfilename)
	error('Channels have different sampling rates. Giving up :''(')
end
% compute sampling rate
meta.fs = meta.samplePerRecord / meta.duration;

% compute gain and offset for the channels
gain = (meta.maxValue - meta.minValue) ./ (meta.digiMax - meta.digiMin);
offSet = (meta.maxValue - meta.minValue) / 2 + meta.minValue;

% and store in meta
meta.gain = gain;
meta.offset = offSet;

% seek to point where data starts
fseek(fp,meta.headerLength,'bof');

% adjust no. of trials to read
if isempty(recsToRead)
	recsToRead = meta.nRecords;
end

% pre-allocation data, to speedup things
data = single( zeros(meta.nChans,recsToRead*meta.samplePerRecord(1)) );

% preset room for status/trigger
idxStatus = [];
trigger = [];


% some status
disp(sprintf('Will read  %d records from %s',recsToRead,filename));

% actual reading loop
for iRecord = 1:recsToRead
	for iChan=1:meta.nChans
		%read data chunk
		if strcmpi(meta.label{iChan},'Status')
			idxStatus = iChan;
			rawData = fread(fp,[3*meta.samplePerRecord(iChan)],'*uint8');
			rawData = reshape(rawData,3,size(rawData,1)/3);
			trigger = [trigger rawData];
			tmp = zeros(1, meta.samplePerRecord(iChan));
		else
			rawData = fread(fp,[meta.samplePerRecord(iChan)*meta.duration],'bit24');
			% and adjust to gain & offset
			tmp  = rawData * gain(iChan) + offSet(iChan);
		end

		% locate where to place the data
		idx = (iRecord-1) *	meta.samplePerRecord(iChan) + 1;
	
		data(iChan,idx : idx+meta.samplePerRecord(iChan)-1) = single(tmp);

	end %iChan

	%just so we see its doing sth
	fprintf('.');

end

fprintf('\n');
fclose(fp);


% check if there is a channel -> if so, delete it
if ~isempty(idxStatus)
	fprintf('Deleting status channel from data and meta info.\n');
	% data
	data(idxStatus,:) = [];
	
	% meta info in doubles
	meta.samplePerRecord(idxStatus) = [];
	meta.minValue(idxStatus) = []; 
	meta.maxValue(idxStatus) = []; 
	meta.digiMin(idxStatus) = [];
	meta.digiMax(idxStatus) = [];
	meta.fs(idxStatus) = [];
	meta.gain(idxStatus) = [];
	meta.offset(idxStatus) = [];
	meta.reserved2(idxStatus,:) = [];
	% meta info in cells
	meta.label{idxStatus} = [];	
	meta.label = meta.label(~cellfun('isempty',meta.label));
	meta.transducer{idxStatus} = [];
	meta.transducer = meta.transducer(~cellfun('isempty',meta.transducer));
	meta.unit{idxStatus} = [];
	meta.unit = meta.unit(~cellfun('isempty',meta.unit));
	meta.preproc{idxStatus} = [];
	meta.preproc = meta.preproc(~cellfun('isempty',meta.preproc));

end


