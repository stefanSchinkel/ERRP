function eeg_corrmovie(eeg,ws,ss,varargin)

%EEG_CORRMOVIE - movie of correlation matrices of EEGset
%
% function eeg_corrmovie(eeg,ws,ss[,timescale,fileName])
%
% Correlation matrix movie, if a fileName is given it is 
% stored in a corrsponding .avi file.
%
% Input:
%	eeg = EEG-set 
%	ws = window size
%	ss = step size	(default : 1)
%
% Options: 
%	timeScale = timescale for title of plot
%	fileName = name for avi-file
%
% Output:
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

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

% I/O check
if (nargchk(2,5,nargin)), help(mfilename),return; end
if (nargchk(0,1,nargout)), help(mfilename),return; end

varargin{3} = [];
if ~isempty(varargin{1}), timeScale = varargin{1};else timeScale = 1:size(eeg,2);end
if ~isempty(varargin{2}), fileName = varargin{2};else fileName = '';end


%open AVIfile if neccessary
if ~isempty(fileName)
	aviobj = avifile(fileName,'fps',1,'quality',100); 

	for i=1:ss:size(eeg,2) - ws

		cMat = eeg_corrmat(eeg(:,i:i+ws,:));

		hImage = imagesc(cMat,[-1 1]);
		title(sprintf('TimeWindow: %d to %d (ms)',timeScale(i),timeScale(i+ws)));

		aviobj = addframe(aviobj,getframe(get(get(hImage,'parent'),'parent')));

	end

	%close file
	aviobj = close(aviobj);
else
	for i=1:ss:size(eeg,2) - ws
		cMat = eeg_corrmat(eeg(:,i:i+ws,:));
		hImage = imagesc(cMat,[-1 1]);
		title(sprintf('TimeWindow: %d to %d (ms)',timeScale(i),timeScale(i+ws)));
		drawnow
		pause(.5)
	end

end

