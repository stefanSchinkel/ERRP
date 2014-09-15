function varargout = plot_erpconf(varargin)

% PLOT_ERP - plot ERPs, in classical fashion
%
% function hFig = plot_erp(EEG1, EEG2, spec, time)
%
% PLOT_ERP plots ERPs in the "classical" fashion. 
% The data in EEG1/2 has to be averaged EEG data.
% measures (infact any measure if it conforms to the ERRP data 
% structure). The function will not clear exitsting elements in 
% the plot, hence twho different conditions can be plotted using
% the function repeatedly.
%
%
% Input:
%   EEG1 : average EEG data 1(chan x frame)
%   EEG2 : average EEG data 2(chan x frame)
%   spec : struct containing specs of plot
%	.rows = rows of subplot
%	.cols = cols of subplot
%	.dataChan = channel indeces (in the data)
%	.labels = labels of those channels
%	.plotOrder = where (subplot index) to plot channels
%   time = a timescale for plotting
%
% Options:
%
% PLOT_ERP(hFig,...) plots into the figure with handle hFig
%
% Output:
%   hFig : handle of figure
%
% Requires: axes2origin.m
%
% See also: plot_erpconf.m ERRP, CRPtool

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
error(nargchk(4,5,nargin))

% check number of out arguments
error(nargoutchk(0,1,nargout))

% prevent indexation errors
varargin{6}=[];

% check if hAX is given & adjust varargin acc. 
args = varargin;
if ishandle(varargin{1}), 
	hFig= varargin{1};
	varargin = {args{2:end}};
else
	hFig = gcf;
end

if ~isempty(varargin{1}),EEG1 = varargin{1}; 	else error(errID,'Not enough data'); end
if ~isempty(varargin{2}),EEG2 = varargin{2}; 	else error(errID,'Not enough data'); end
if ~isempty(varargin{3}),spec = varargin{3}; 	else error(errID,'Not plot specs'); end
if ~isempty(varargin{4}),time = varargin{4}; 	else error(errID,'Not timescale supplied'); end


%% unpack the struct
rows = spec.rows;
cols = spec.cols;
plotOrder = spec.plotOrder;
dataChan = spec.dataChan;
labels = spec.labels;

maxY = double(max(max([EEG1(dataChan,:),EEG2(dataChan,:)])));
minY = double(min(min([EEG1(dataChan,:),EEG2(dataChan,:)])));
limY = ceil(max(abs(maxY),abs(minY)));

minX = time(1);
maxX = time(end);
rangeX = maxX-minX;
rangeY = maxY-minY;

figure(hFig);
clf
for i=1:length(plotOrder)
	subplot(rows,cols,plotOrder(i))
	plot(time,EEG1(dataChan(i),:),'b');
	hold on;
	title(labels(i));axis tight
	plot(time,EEG2(dataChan(i),:),'r');

	xlim([minX maxX])
	set(gca,'Xtick',[minX:200:maxX]);
	set(gca,'Xtickl',[]);

	ylim([-limY limY]);
	set(gca,'ytick',[-limY:rangeY/4:limY]);
	set(gca,'ytickl',[]);
	axes2origin
end

subplot(rows,cols,rows*cols);
xlim([minX maxX])
set(gca,'Xtick',[minX:200:maxX]);
set(gca,'Xtickl',[]);
ylim([-limY limY]);
set(gca,'ytick',[-limY:rangeY/4:limY]);
set(gca,'ytickl',[]);
hold on
axes2origin


text(minX/2,-limY,num2str(-limY))
text(minX/2,limY,num2str(limY))
text(minX,minY*2/3,num2str(minX))
text(maxX,minY*2/3,num2str(maxX))




varargout{1} = hFig;
