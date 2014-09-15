
function plot_nw(varargin)

%PLOT_NW plot network with node and link weights
%
% function plot_nw(A,x,y [,val,label])
% 
% plot_nw(A,x,y) plots a weighted or unweighted adjacency A
% matrix as a network with nodes located at the positions
% definded by the coordinates x and y. Thickness and color
% are adjusted according to the weight of the links.
%
% plot_nw(A,x,y,val) additionally the adjusts size and colour
% of the nodes according to the values provided to encode
% node-specific measures eg. degree
%
% plot_nw(A,x,y,val,labels) addtionally labels the nodes
% according to the labels provided (This might look tacky).
%
%
% Required inputs:
%	A = adajcency matrix (weigthed or unweighted)
%	x = x-coordinates of the nodes
%	y = y-coordinates of the nodes
%
% Optional Inputs:
%	val = values for indidual nodes
%	label = label for nodes
%
%
% Output:
%
% Requires:  
%
% See also: ERRP
%
%

% Copyright (C) 2011 Stefan Schinkel, HU Berlin
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

%% I/O check
if (nargchk(3,5,nargin)), help(mfilename),return; end
if (nargchk(0,0,nargout)), help(mfilename),return; end

varargin{7} = [];

% input assignment 
if ~isempty(varargin{1}), A = varargin{1}; else help(mfilename),return; end
if ~isempty(varargin{2}), x = varargin{2}; else help(mfilename),return; end
if ~isempty(varargin{3}), y = varargin{3}; else help(mfilename),return; end
if ~isempty(varargin{4}), val = varargin{4}; else val = [];end
if ~isempty(varargin{5}), label = varargin{5}; else label = {};end

% check for weighted network
if any(mod(A(:),1) ~= 0 ) 
	flagWeighted = true; 
else
	flagWeighted = false;
end

% check if nodes have values
flagLoaded = boolean(~isempty(val) & sum(val) ~= 0);


% store min/max of data for later use
minLink = min(min(A));
maxLink = max(max(A));
minVal = min(val);
maxVal = max(val);

% normalise data to better handle
% adaptive color and size
if sum(sum(A)) ~= 0, 
	A = A/maxLink;
end
val = val/maxVal;

%selfloops are ignored
A = double(A)  .* (1 - eye(size(A)) );

% merge coordinates
% ensure shape
x = x(:)';y = y(:)';
xy = [x; y]';

%find links
[i,j] = find(A);

%match to coordinates
X = [ xy(i,1) xy(j,1)]';
Y = [ xy(i,2) xy(j,2)]';

%aquire graphics handles
hFig = gcf;
hAx = gca;

% colormaps for links and nodes
cMapLinks = flipud(hot(100));
cMapNodes = flipud(bone(100));

% clear then hold plot
cla(hAx);
hold(hAx,'on');


%get the link weights
weights = A(find(A));


if flagWeighted
	% determine color of links
	linkColor = ceil( weights*length(cMapLinks) );
	linkWidth = ceil( weights*2 );
else
	linkColor = repmat(size(cMapLinks,1),size(weights));
	linkWidth = repmat(1,size(weights));
end

% order weights to have thickest lines plotted on top
[dummy idx] = sort(weights);

%plot links
for i=1:length(X)
	plot(X(:,idx(i)),Y(:,idx(i)),...
	'LineWidth',linkWidth(idx(i)),...
	'Color',cMapLinks(linkColor(idx(i)),:))
end

% fancy up plot by adding a second "colorbar" 
% if links are weighted
% to the values of the nodes
if flagWeighted

	% get limits of main axes
	pos = get(hAx,'Position');

	% add axis for colorbar
	surfAx = axes('Position',[ pos(1)+pos(3)/10 pos(2)/2 pos(3)-pos(3)/4 pos(2)/4],'Box','On');

	%plot the range of 
	xScale = linspace(minLink,maxLink,length(cMapLinks)+1);

	for i=1:length(cMapLinks)
		x0 = xScale(i);
		x1 = xScale(i+1);
		line([x0 x1],[0 0],'LineWidth',10,'Color',cMapLinks(i,:))
	end
	set(surfAx,'YTick',[]);
end %flag weighted

% re-enable gca to plot nodes
axes(hAx);

%adjust node color & size only if needed
if flagLoaded
	%plot nodes in colour
	idColor = ceil( val *length(cMapNodes));
	idColor(idColor == 0) = 1;
	nodeColor = cMapNodes(idColor,:);
	nodeSize = ceil( val * 200);
	nodeSize(nodeSize == 0) = 15;
	
	%plot nodes
	scatter(xy(:,1),xy(:,2),nodeSize,nodeColor,'filled') 
	
	%set colourmap
	colormap(cMapNodes);
	% add colourbar
	%hCb = colorbar;
	%and label accordingly
	%set(hCb,'YTickl',linspace(minVal,maxVal,numel(get(hCb,'YTick'))));

else
	%plot nodes
	scatter(xy(:,1),xy(:,2),15,'k','filled');
end


if ~isempty(label)
	for i=1:length(xy)
		text(xy(i,1),xy(i,2),num2str(label{i}),...
		'FontSize',10,'FontWeight','bold','HorizontalAlignment','center')
	end   
end



%hide main axes
axis(hAx,'off');
