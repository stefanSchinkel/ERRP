function h =  plot_cluster(x,y,components,varargin)

% PLOT_CLUSTER - plot network components in a given 2D-Space
%
% function hNode =  plot_cluster(x,y,components[,flagPlotLinks,makerSize,lineWidth])
%
% This function plots the components given at the coordinates
% given in x and y. All elements of the same component have the
% same color. Optionally links can be drawn as well, which will
% be colored according to the component they are in. 
%
%
% Required inputs:
%	x = x-coordinates of the nodes
%	y = y-coordinates of the nodes
%	mod = cell array encoding components (cf. nwcomp.m)
%
% Parameters:
%	flagLinks = flag to choose if links should be plotted  (def: 0)
%	makerSize = size of markers (def: 8)
%	lineWidth = width of links (def: 1)
%
% Output:
%	h = handles of the individual nodes
%
%
% Requires:  
%
% See also: nwcomp.m

%
% Copyright (C) 2011 Stefan Schinkel, schinkel@physik.hu-berlin.de 
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



if nargin < 3
	help(mfilename)
	error('ERRP:plotting:plot_cluster','Not enough input elements');
end

% check & assign parameters
varargin{4} = [];
if ~isempty(varargin{1}), flagPlotLinks = varargin{1};	else flagPlotLinks = false; end
if ~isempty(varargin{2}), makerSize = varargin{2}; 		else makerSize = 8;	end
if ~isempty(varargin{3}), lineWidth = varargin{3};	 	else lineWidth = 1;end

% try to make a nice colormap
% or use default maps
try
	cMap = distinguishable_colors(length(x));
catch
	disp('Info: distinguishable_colors not found. Using default maps');
	disp('See: http://www.mathworks.com/matlabcentral/fileexchange/29702');
	cMap = jet(length(x));
end

% clear current fig and enable hold
clf(gcf);hold(gca,'on');


% plot all electrodes as circles
h = zeros(1,length(x));
for i=1:length(x)
		h(i)=plot(x(i),y(i),'ok',...
		'MarkerSize',makerSize,...
		'MarkerFaceColor','w',...
		'MarkerEdgeColor','k');
end

%find the components with more than one element
idx = find( cellfun(@numel,components) > 1);
nComp = numel(idx);

% colour the electrodes accordingly
for iComp=1:nComp
	theComponent = components{idx(iComp)};
	
	set(h(theComponent),...
	'MarkerFaceColor',cMap(theComponent(1),:),...
	'MarkerEdgeColor',cMap(theComponent(1),:))
	
	if flagPlotLinks

		% this replicates two for loops
		iLink = repmat(theComponent,1,numel(theComponent));
		jLink = sort(iLink);
		for iLine = 1:length(iLink)
			plot(	[x(iLink(iLine)),x(jLink(iLine)) ],...
					[y(iLink(iLine)),y(jLink(iLine)) ],...
					'color',cMap(theComponent(1),:),'LineWidth',lineWidth );			
		end %iLink

	
	end % flag
	
end %iComp

set(gca,'YDir','reverse')
axis square
axis off

