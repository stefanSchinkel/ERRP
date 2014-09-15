function varargout = plot_erpconf(varargin)

% PLOT_ERPCONF- plot averaged EEG/RQA (with confidence bounds)
%
% function hAX = plot_erpconf([hAX], data, chan, measure [, trials, colour, timeScale])
%
% The function plots ERPs - either of RQA-measures or voltage 
% measures (infact any measure if it conforms to the ERRP data 
% structure). The function will not clear exitsting elements in 
% the plot, hence twho different conditions can be plotted using
% the function repeatedly.
%
%
% Input:
%   data 	: RQA or EEG data (chan x frame x trial [x measure])
%   chan	: channel to plot (if more than one, spatial average is computed)
%   measure	: measure to plot (ignored for ERPimages)
%
% Options:
%   trials	: trials to plot (def: all)
%   colour	: colour to plot in
%   tScale	: time scale to plot against  
%
% PLOT_ERPCONF(hAX,...) plots into the axis with handle hAX
%
% Output:
%   hAX	: handle to axis of plot
%
%
% Requires: ciplot.m
%
% See also: plot_erp.m ERRP, CRPtool

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
errID = 'ERRP:plotting:plot_erp';

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
if ~isempty(varargin{4}),trials = varargin{4}; 		else trials = 1:size(data,3); end
if ~isempty(varargin{5}),colour = varargin{5}; 		else colour = 'b';end
if ~isempty(varargin{6}),tScale = varargin{6}; 		else tScale = 1:size(data,2); end

% extract the data needed
if ndims(data) == 4,
	plotData = squeeze(data(chan,:,trials,measure));
else
	plotData = squeeze(data(chan,:,trials));
end

% average over channels
%stdData = std(plotData,0,2);

stdData = std(plotData,0,2);
plotData = mean(plotData,2);

% to the actual plotting
if ishandle(hAX),
	hold(hAX,'on')
	plot(hAX,tScale,plotData,colour);
	ciplot([plotData+ 1.96*stdData  plotData-1.96*stdData],colour,tScale)
else
	hold on;
	hAX = plot(tScale,plotData,colour);
	ciplot([plotData+1.96*stdData  plotData-1.96*stdData],colour,tScale)
end

varargout{1} = hAX;
