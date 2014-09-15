function plot_links(varargin)

% PLOT_LINKS - plot links in a graph
%	
% function hAX = plot_links([hAX,]x,y,r)	
%
% This function plots the links found in an 
% adajancency matrix r on the with the node
% coordinates provided in xy. It uses gplot
% to extract the links. 
%
% plot_links(hAX,x,y,r) plots in the axes provided
% by hAX instead to gca.
%
% Required inputs:
%	x = x-coordinates of nodes
%	y = y-coordinates of nodes
%	r = adjacency matrix
%
% Optional inputs:
%	hAX = handle of axes to use
%
% Output:
%	
% Requires:  gplot() from matlab/sparfun/gplot.m
%
% See also:
%
%

if nargin < 3
	help(mfilename)
	error('ERRP:plotting:plot_links','Not enough input elements');
end

if axescheck(varargin{1})
	hAX = varargin{1};
	args = {varargin{2:end}};
else
	hAX = gca;
	args = varargin;
end


% get coordinates and ensure column vector
x = args{1}; x = x(:);
y = args{2}; y = y(:);

%make r binary for sure 
r = uint8(args{3});


%clear and hold plot
%cla(hAX);
hold(hAX,'on');

% get z-value in case we overlay a surface
z = max(zlim);
%first plot all nodes as circles
plot3(hAX,x,y,repmat(z,numel(x),1),'ok','MarkerSize',5,'MarkerFaceColor','k');

%erase potential self-loops
r = r .*  uint8( ones(size(r)) - eye(size(r)) ) ;

%get links from gplot
[gx,gy] = gplot(r,[x y]);

%and plot
plot3(hAX,gx,gy,repmat(z,numel(gx),1),'-k','LineWidth',1.5);


%fancy up
%set(hAX,'YDir','reverse');
axis(hAX,'off');
axis(hAX,'equal');
