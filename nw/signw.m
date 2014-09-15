function out = signw(varargin)

% SIGNW - significant links of a network
%
% function out = signw(r,[p])
%
% Extract significant links from a weighted
% adjacency matrix. The significance defined
% as all links with a weigth higher than the
% value of "p"th percentile.
%
% Input:
%	r = adjacency matrix
%
% Parameters
%	p = percentile (def: 90)
%
% Output:
%	out = network of significant links
%
% requires: 
%
% see also: ERRP/nw
%

% Copyright (C) 2011 Stefan Schinkel, University of Potsdam
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


% input check
varargin{3} = [];
if ~isempty(varargin{1})
	r =  varargin{1}; 
else 
	error('ERRP:nw:signw','No network provided');
	help(mfilename); 
end
if ~isempty(varargin{2}), p =  varargin{2}; else p = 90; end



for iFrame = 1:size(r,3)
	
	
	rTemp = r(:,:,iFrame);
	rTemp = rTemp - eye(size(rTemp));
	thresh = prctile(rTemp(:), p );
	idx = rTemp >  thresh;
	rTemp(idx) = 1;
	rTemp(~idx) = 0;
	out(:,:,iFrame) = rTemp;
	
	
end
