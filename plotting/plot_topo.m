function hAX = plot_topo(x,y,v,varargin)

% PLOT_TOPO - topological plot of EEG dat
%	
% function hAX = plot_topo(x,y,r[,flagElecs,labels])	
%
% This function plots the EEG values on a surface
% interpolated ('cubic') over the area covered.
%
% If requested the electrodes can be plotteds as well.
%
% If labels are provided, those will be.
%
% Required inputs:
%	x = x-coordinates of nodes
%	y = y-coordinates of nodes
%	v = values (voltage)
%
% Optional inputs:
%	flagElecs = flag to plot electrode markers
%	labels = strings to label electrods
%
% Output:
%	hAX = handle of axes used (gca)
%	
% Requires:  
%
% See also: plot_links()
%
%

% Copyright (C) 2012- Stefan Schinkel, HU Berlin
% http://people.physik.hu-berlin.de/~schinkel 
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


% I/O check
if nargin < 3
	help(mfilename)
	error('ERRP:plotting:plot_topo','Not enough input elements');
end

% optionals
varargin{3} = [];

if ~isempty(varargin{1}), flagElecs = varargin{1}; else	flagElecs = false; end
if ~isempty(varargin{2}), labels = varargin{2}; else labels = []; end

% ensure doubles
v = double(v);

% find maximal range (radius)
r = ceil(max([x y]));
gridStep = r / 150;
% make a neat grid
%fprintf('Making Grid\n')
[X Y] = meshgrid(-r:gridStep:r, -r:gridStep:r);

% interpolate data
%fprintf('Interpolating data\n')
gd = griddata(x,y,v,X,Y,'cubic');

%surface plot of the data
contourf(X,Y,gd);
shading flat
hold on
%surf(X,Y,gd);shading flat;view(2)
% electrode markers
if flagElecs
	% we need to plot in 3D to be above the surface
	z = repmat(max(zlim),numel(x),1);
	plot3(x,y,z,'ok','MarkerSize',2,'MarkerFaceColor','k');
end

% electrode labels
if ~isempty(labels)
	z = max(zlim);
	offSet = range(ylim)*.01;
	for i=1:numel(x)
		text(x(i),y(i)+offSet,z,labels{i} );
	end %for
end %if 

% fancy plot

% switch off axes for a better look
axis tight
axis off
% adjust colormap to eeg format
colormap(eegcmap);

% and add colorbar
hCB = colorbar;
set( get(hCB,'YLabel'),'String','\mu Volt' )


% return values
if nargout > 0 
	hAX = gca;
end
