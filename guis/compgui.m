function compgui(x,y,r)

%COMPGUI - a GUI to investigate NW-Components vs. threshold
%
% function compgui(x,y,r)
%
% A tiny GUI that visualises the effect of a given threshold applied 
% to a similarity matrix and visualises the formation of connected
% network components in dependence on 
%
% Input:
%	x = x-coordinates of nodes
%	y = x-coordinates of nodes
%	r = similarity matrix
%
% Output:
%	none
%
% Parameters:
%	none
%
% requires: nwcomp.m 
%
% see also: ERRP
%


% Copyright (C) 2011- Stefan Schinkel, HU Berlin
% people.physik.hu-berlin.de/~schinkel
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
	msg = nargchk(3,3,nargin);

	if ~isempty(msg), help(mfilename),error(msg);end

	% check number of out arguments
	error(nargoutchk(0,0,nargout))


	% Define GUI			
	screenSize = get(0,'Screensize');
	figHandle = figure('Name','Network Components GUI',... 
		'Position',[50,screenSize(4)-650,600,600],... % top left corner 
		'Color',[1 1 1 ], ... 
		'Tag','mainFigure',...
		'Menubar','none');% choose 'Menubar','figure' to run into trouble

	% hide GUI while preping
	set(figHandle,'visible','off');
	
	% axes, title & slider
	axPlot = axes('Parent',figHandle,...
		'Position',[.1 .1 .8 .8],...
		'Tag', 'axPlot',...
		'NextPlot','replacechildren',...
		'Box','on',...
		'XTick',[],...
		'YTick',[]);
		
	slider = uicontrol('Parent',figHandle, ...
		'Units', 'normalized', ...
		'Position',[.1 .05 .8 .04],...
		'BackgroundColor',[0.7020 0.7020 0.7020], ...
		'Style','slider',... 
		'String','Dimension:',...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'Tooltip','Move the slider to increase/decrease the threshold.',...
		'Min',0,...
		'Max',1,...
		'Value',1,...
		'Tag','slider',...
		'SliderStep',[0.01 0.1],...
		'Callback',{@sliderCallback});

	title = uicontrol('Parent',figHandle, ...
		'Units', 'normalized', ...
		'Position',[.1 .925 .8 .05],...
		'Backgroundcolor',[1 1 1 ], ... 
		'Style','text',... 
		'String',sprintf('Threshold: %02.3f',get(slider,'Value')),...
		'HorizontalAlignment','right',...
		'Visible','on',...
		'FontSize',15,...
		'Tag','title',...
		'HorizontalAlignment','center');


	%fancy stuff
	textNLD = uicontrol('Parent',figHandle,...
		'Units', 'normalized', ...
		'Position',[.49 .01 .5 .02],...
		'Style','text',... 
		'BackgroundColor',[1 1 1], ... 
		'Tag', 'NLD ',...
		'FontSize',9,...
		'String',sprintf('Stefan Schinkel HU Berlin (c) 2011-%s',datestr(now,'yy')),...
		'ToolTip','people.physik.hu-berlin.de/~schinkel');


	% initial plot of data
	hold(axPlot,'on')
	for i=1:length(x)
		hNodes(i)=plot(x(i),y(i),'ok','MarkerSize',5,'MarkerFaceColor',[1 1 1]);
	end
	set(axPlot,'Xlim',[min(x) - range(x)*.02 max(x) + range(x)*.02])
	set(axPlot,'Ylim',[min(y) - range(y)*.02 max(y) + range(y)*.02])
	set(axPlot,'YDir','reverse')
	axis off

	% store necc data in GUI
	data.r = r;
	data.x = x;
	data.y = y;
	data.hNodes = hNodes;
	set(figHandle,'Userdata',data);

	% show GUI when all is done
	set(figHandle,'visible','on');


end % main()

%%%%%%%%%%%%%%%%%%%%%%%%%
% callback definitions	%
%%%%%%%%%%%%%%%%%%%%%%%%%


function sliderCallback(source,eventdata,varargin)
	
	%get what we need
	figHandle = get(source,'Parent');
	hTitle = findobj(figHandle,'Tag','title');
	hSlider = findobj(figHandle,'Tag','slider');
	axPlot = findobj(figHandle,'Tag','axPlot');

	%acquire user data
	data = 	get(figHandle,'Userdata');

	%disentangle
	r = data.r;
	x = data.x;
	y = data.y;
	hNodes = data.hNodes;

	%get threshold	
	thresh = get(source,'value');

	%compute the components
	comps = nwcomp(r,thresh);

	% delete with \leq one node
	t = cellfun(@length,comps);
	comps = comps(find(t > 1));

	% make a colour map
	cMap = jet(length(comps)); 

	% clear plot before redrawing
	cla(axPlot);
	hold(axPlot,'on')
	for i=1:length(x)
		hNodes(i)=plot(x(i),y(i),'ok','MarkerSize',5,'MarkerFaceColor',[1 1 1]);
	end
	set(axPlot,'Xlim',[min(x) - range(x)*.02 max(x) + range(x)*.02])
	set(axPlot,'Ylim',[min(y) - range(y)*.02 max(y) + range(y)*.02])
	set(axPlot,'YDir','reverse')
	axis off
	
	%colour the electrodes accourding to components  
	for i=1:length(comps)
		theComponent = comps{i};
		set(hNodes(theComponent),'MarkerSize',15,'MarkerFaceColor',cMap(i,:))
	end
	
	% display threshold
	set(hTitle,'String',sprintf('Threshold: %02.3f',get(hSlider,'Value')));
	set(hSlider,'Tooltip',sprintf('Treshold: %02.3f',get(hSlider','Value')));
	drawnow
end % sliderCallback
