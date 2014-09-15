function corrthresh(X)

%CORRTHRESH - graphic helper from estimating networks from correlation matrices
%
% function corrthresh(X)
%
% A tiny GUI that visualises the effect of a given  threshold
% on a correlation matrix. 
%
% Input:
%	X = correlation matrix
%
% Parameters:
%	none
%
% requires: 
%
% see also: rqathresh.m
%


% Copyright (C) 2009 Stefan Schinkel, University of Potsdam
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

	%% debug settings
	debug = 0;
	if debug;warning('on','all');else warning('off','all');end

	% check number of input arguments
	error(nargchk(1,1,nargin))

	% check number of out arguments
	error(nargoutchk(0,0,nargout))

	if ndims(X) ~= 2;help(mfilename);error('Sorry 2-dimensional require');end
	

	% Define GUI			
	screenSize = get(0,'Screensize');
	figHandle = figure('Name','CORRTHRESH',... 
		'Position',[50,screenSize(4)-650,600,600],... % top left corner 
		'Color',[.801 .75 .688], ... 
		'Tag','mainFigure',...
		'Menubar','none');% choose 'Menubar','figure' to run into trouble

	% hide GUI while preping
	set(figHandle,'visible','off');
	
	% axes, title & slider
	axSurf = axes('Parent',figHandle,...
		'Position',[.1 .1 .8 .8],...
		'Tag', 'axSurf',...
		'NextPlot','replacechildren',...
		'Box','on',...
		'XAxisLocation','Top');
		
	title = uicontrol('Parent',figHandle, ...
		'Units', 'normalized', ...
		'Position',[.1 .925 .8 .05],...
		'BackgroundColor',[.801 .75 .688], ... 
		'Style','text',... 
		'String','Threshold: xx.xxx',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'FontSize',15,...
		'Tag','title',...
		'HorizontalAlignment','center');

	slider = uicontrol('Parent',figHandle, ...
		'Units', 'normalized', ...
		'Position',[.1 .05 .8 .04],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','slider',... 
		'String','Dimension:',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Move the slider to increase/decrease the threshold.',...
		'Min',min(min(abs(X))),...
		'Max',max(max(abs(X))),...
		'Callback',{@sliderCallback});


	%fancy stuff
	textNLD = uicontrol('Parent',figHandle,...
		'Units', 'normalized', ...
		'Position',[.49 .01 .5 .02],...
		'Style','text',... 
		'BackgroundColor',[.801 .75 .688], ... 
		'Tag', 'NLD ',...
		'FontSize',9,...
		'String',sprintf('Stefan Schinkel University of Potsdam (c) 2007-%s',datestr(now,'yy')),...
		'ToolTip','The Nonlinear Dynamics Group http://www.agnld.uni-potsdam.de');


	% initial plot of data
	imagesc(X,'Parent',axSurf);
	axis tight
	set(axSurf,'YDir','normal');

	% store X in GUI
	set(figHandle,'Userdata',X);

	% show GUI when all is done
	set(figHandle,'visible','on');


end % main()

%%%%%%%%%%%%%%%%%%%%%%%%%
% callback definitions	%
%%%%%%%%%%%%%%%%%%%%%%%%%


function sliderCallback(source,eventdata,varargin)
	
	%get what we need
	figHandle = get(source,'Parent');
	title = findobj(figHandle,'Tag','title');
	axSurf = findobj(figHandle,'Tag','axSurf');
	X = abs(get(figHandle,'Userdata'));
	
	%get threshold
	thresh = get(source,'Value');
	set(title,'String',sprintf('Threshold: %03.3f',thresh));

	%filter colourmap
	larger = find(X>thresh);smaller = find(X <= thresh);

	X(larger) = 0;
	X(smaller) = 1;

	%plot
	imagesc(X,'Parent',axSurf);
	shading flat;
	set(axSurf,'YDir','normal');
	cMap = gray(2);
	colormap(cMap);
	
end % sliderCallback
