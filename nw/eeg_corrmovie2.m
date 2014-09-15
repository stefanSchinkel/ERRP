function eeg_corrmovie2(eeg,eeg2,ws,ss,fileName,varargin)

%EEG_CORRMOVIE - movie of correlation matrices of EEGset
%
% function movie = eeg_corrmovie2(eeg,eeg2,ws,ss,fileName,timescale,label1,label2)
%
% Convert an EEG set to words of given length.
%
% Input:
%	eeg = EEG-set 
%	eeg = EEG-set 2
%	ws = window size
%	ss = step size	
%	fileName = name of avifile created
%
% Options: 
%	timeScale = timescale for title of plot
%	title1 = title for 1st plot
%	title2 = title for 2nd plot
%
% Output:
%	none
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
if (nargchk(5,8,nargin)), help(mfilename),return; end
if (nargchk(0,1,nargout)), help(mfilename),return; end

varargin{4} = [];
if ~isempty(varargin{1}), timeScale = varargin{1};else timeScale = 1:size(eeg,2);end
if ~isempty(varargin{2}), title1 = varargin{2};else title1 = '';end
if ~isempty(varargin{3}), title2 = varargin{3};else title2 = '';end

%open AVIfile
aviobj = avifile(fileName,'fps',3,'quality',100);



for i=1:ss:size(eeg,2) - ws

	cMat = eeg_corrmat(eeg(:,i:i+ws,:));
	cMat2 = eeg_corrmat(eeg2(:,i:i+ws,:));

	subplot(1,2,1);hImage = imagesc(cMat,[-1 1]);axis square;title(title1,'FontWeight','bold');
	subplot(1,2,2);hImage = imagesc(cMat2,[-1 1]);axis square;title(title2,'FontWeight','bold');
	
	%position for overall label borrowed from suplabel (see MATLAB FEX)
	ax=axes('Units','Normal','Position',[.08 .08 .84 .84],'Visible','off');
	set(get(ax,'Title'),'Visible','on')
	title(sprintf('Timeslice: %d to %d (ms)',timeScale(i),timeScale(i)+ws),'FontSize',14,...
		'FontWeight','bold');

	aviobj = addframe(aviobj,getframe(get(get(hImage,'parent'),'parent')));

end

%close file
aviobj = close(aviobj);

