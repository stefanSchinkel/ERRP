function out = tsignw(varargin)

% TSIGNW -  significant links over time
%
% function out = signw(r,[p])
%
% Extract significant links from a set of weighted
% adjacency matrix. All time points at which the
% link weight is higher then the p'th percentile, 
% the link is considered signifcant.
%
% Input:
%	r = adjacency matrices [Rij x time]
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

ij = size(r(:,:,1));

for i = 1:ij
	for j = i:ij
	
	t = r(i,j,:);
	thresh = prctile(t, p );
	idx = t >  thresh;
	t(idx) = 1;
	t(~idx) = 0;
	out(i,j,:) = t;
	out(j,i,:) = t;

	end
end	


