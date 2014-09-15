function varargout = plot_rqaimage(varargin)

% PLOT_RQAIMAGE - plot RQAimage (or ERPimage)
%
% function hAX = plot_erp([hAX], data, chan, measure [,timeScale])
%
% The function plots RQAimages - "ERPimages" of RQA measures. 
% It can also used to plot "traditional"  ERPimages.
%
%
% Input:
%   data 	: RQA or EEG data (chan x frame x trial [x measure])
%   chan	: channel to plot (if more than one, spatial average is computed)
%   measure	: measure to plot (ignored for ERPimages)
%
% Options:
%   tScale	: time scale to plot against  
%
% PLOT_RQAIMAGE(hAX,...) plots into the axis with handle hAX
%
% Output:
%   hAX	: handle to axis of plot
%
%
% Requires: 
%
% See also: eeg_crqa.m, ERRP, CRPtool

%
% Copyright (C) 2009 Stefan Schinkel, schinkel@agnld.uni-potsdam.de 
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

%error identifiers
errID = 'ERRP:plotting:plot_rqaimage';

% I/O check

% check number of input arguments
error(nargchk(2,8,nargin))

% check number of out arguments
error(nargoutchk(0,1,nargout))

% prevent indexation errors
varargin{9}=[];


% check if hAX is given & adjust varargin acc. 
args = varargin;
if ishandle(varargin{1}), 
	hAX = varargin{1};
	varargin = {args{2:end}};
else
	hAX = [];
end

if ~isempty(varargin{1}),data = varargin{1}; 		else error(errID,'No data supplied'); end
if ~isempty(varargin{2}),chan = varargin{2}; 		else error(errID,'No channel selected'); end
if ~isempty(varargin{3}),measure = varargin{3}; 	else measure = []; end
if ~isempty(varargin{4}),tScale = varargin{4}; 		else tScale = 1:size(data,2); end


% extract the data needed
if ndims(data) == 4,
	plotData = data(chan,:,:,measure);
else
	plotData = data(chan,:,:);
end

%average on dim 1 - spatial average over chans
plotData = squeeze(mean(plotData,1));

% convert to double too

% use a moving average filter of 10x10
h=ones(10,10)/100;

%apply filter to data
plotData = filter2(h, double(plotData));

% to the actual plotting
if ishandle(hAX),
	% create surface plot
	surf(hAX,plotData');
else
	surf(plotData');
	hAX = gca;
end

%adjust to ERPimage-look
view(2);shading flat;axis tight;colorbar;


%ajust timescale
set(hAX,'XTickl',tScale(get(hAX,'XTick')+1));

%label plot (in printable fontsize)
xlabel('time','FontSize',14);ylabel('trial','FontSize',14);

%return hAX to caller
varargout{1} = hAX;
