function nw = opnw(x,varargin)

% OPNW - construct order patterns networks
%
% function nw = opnw(x,[dim,tau])
%
% Construct a network from the observed time
% series at the individual nodes. A link is
% defined as the simultaneous occurence of
% a symbol (order pattern) at two nodes.
% For the construction for order patterns
% a dimension and a delay can be provided.
%
% Input:
%	x = set of time series
%
% Parameters
%	dim = dimension (def: 2)
%	tau = dimension (def: 1)
%
% Output:
%	out = network of significant links
%
% requires: opCalc.m
%
% see also: ERRP/nw
%

% Copyright (C) 2012 Stefan Schinkel, HU Berlin
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

varargin{3} = [];
if ~isempty(varargin{1}), dim =  varargin{1}; else dim = 2; end
if ~isempty(varargin{2}), tau =  varargin{2}; else tau = 1; end
	
nChan = size(x,1);
nEpoch = size(x,2);

% pre-allocate space for patterns
ops = zeros(nChan,nEpoch-(dim-1)*tau);

for iChan = 1:nChan
	ops(iChan,:) = opCalc(x(iChan,:),dim,tau);
end

% pre allocate output
nw = uint8( zeros( nChan,nChan, nEpoch - (dim-1)*tau ));


for iEpoch = 1:size(ops,2)

	% this roughly is makeRP	
	X = ops(:,iEpoch);
	Y = X';
	nw(:,:,iEpoch) =  uint8(X(:,ones(1,nChan)) == Y(ones(1,nChan),:))';		

end % epoch loop

