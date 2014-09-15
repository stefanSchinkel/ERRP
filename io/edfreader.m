function [data meta] = edfreader(filename)

% EDFREADER - simple EDF/EDF+ Reader
%
% function [data meta] = edfreader(file)
%
% Input:
%	file = EDF/EDF+ file
%
% Parameters: 
%	none
%
% Output:
%	data = cell/double array
%	meta = struct with meta data
%
% The type of data depends on whether the number of records
% per channel is equal. If so, a [chan x record x values]
% double matrix is returned. If not (eg if a trigger channel 
% is present) a {chan,record} cell array is returned.
%
% requires: 
%
% see also: 
%
% The EDF/EDF+ specs can be found at:
% http://www.edfplus.info/specs/edfplus.html
%
% Calibration signals are available at:
% http://www.edfplus.info/downloads/files/edfcalib.zip

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

if nargin < 1
	help(mfilename)
	error('ERRP:io:edfreader','Supply filename');
end

% open file for reading
fp = fopen(filename,'r','ieee-le');

if fp == -1
	error('ERRP:io:edfreader','Could not open EDF file');
end

% read header in on go 256bits ASCII
buffer = char(fread(fp,256)');

meta = struct;

% extract info from header as described in 
% http://www.edfplus.info/specs/edf.html
meta.version = str2num(buffer(1:8));				% EDF Version
meta.patient = buffer(9:88);						% Patient Info
meta.recording = buffer(89:168);					% Record Info
meta.date = buffer(169:176);						% Date of recording
meta.time = buffer(177:184);						% Time of recording
meta.headerLength = str2num(buffer(185:192));	% length of header
meta.reserve = buffer(193:236);						% reserved part 1
meta.nRecords = str2num(buffer(237:244));		% no of Records (trials)
meta.duration = str2num(buffer(245:252));		% duration of record in seconds
meta.nChans = str2num(buffer(253:256));			% no of channels

meta.label = char(fread(fp,[16,meta.nChans])');							% labels (1/channel)
meta.transducer = char(fread(fp,[80,meta.nChans])');					% sensors (1/channel)
meta.unit = char(fread(fp,[8,meta.nChans])');							% units (1/channel)
meta.minValue = str2num( char(fread(fp,[8,meta.nChans])') );			% physical max (1/channel)
meta.maxValue = str2num( char(fread(fp,[8,meta.nChans])') );			% physical min (1/channel)
meta.digiMin =  str2num( char(fread(fp,[8,meta.nChans])') );			% digital max (1/channel)
meta.digiMax =  str2num( char(fread(fp,[8,meta.nChans])') );			% digital min(1/channel)
meta.preproc = char(fread(fp,[80,meta.nChans])');						% preprocessing (1/channel)
meta.samplePerRecord = str2num( char(fread(fp,[8,meta.nChans])') );	% samples/frames (1/channel)
meta.reserved2 = char(fread(fp,[32,meta.nChans])');						% reserved part 2

% compute sampling rate
meta.fs = meta.samplePerRecord / meta.duration;

% compute gain and offset for the channels
gain = (meta.maxValue - meta.minValue) ./ (meta.digiMax - meta.digiMin);
offSet = (meta.maxValue - meta.minValue) / 2 + meta.minValue;

% and store in meta
meta.gain = gain;
meta.offset = offSet;

% number of bytes to read: 
bytesToRead = 2* sum(meta.samplePerRecord);

% seek to point where data starts
fseek(fp,meta.headerLength,'bof');

% if all records have the same size, 
% return a matrix, otherwise a cell array
if 1 == numel(unique(meta.samplePerRecord))
	flagAllEqual = true;
	data = zeros(meta.nChans,meta.nRecords,meta.samplePerRecord(1));
else
	flagAllEqual = false;
end

for iRecord = 1:meta.nRecords

	% read necessary amount of bytes
	% for one trial as 8bit integers
	trialBuffer = fread(fp,bytesToRead,'*uint8');

	% cast 2 8bit uints to 16bit int
	rawData = typecast(trialBuffer,'int16');
	
	
	% loop over channels and cut out segments
	for iChan=1:meta.nChans
		
		if iChan == 1
			idx0 = 1;
		else
			idx0 = idx1 + 1;
		end

		% relevant segment
		idx1 = idx0 +  meta.samplePerRecord(iChan)-1;
		
		% store cell if different length and scale w/
		% gain/offSet (channeldependent)
		if 	~flagAllEqual
			data{iChan,iRecord} = rawData(idx0:idx1) .* gain(iChan) + offSet(iChan);
		else 
			data(iChan,iRecord,:) = rawData(idx0:idx1) .* gain(iChan) + offSet(iChan);
		end %flagAllEqual
		
	end % iChan
end %iRecord

% close file pointer
fclose(fp);

