function varargout = nwcomp(r,varargin)

% NWCOMP - compute network components
%
% function modules = nwcomp(r,epsilon)
%
% Compute network components of a similarity matrix r for a
% given threshold. The components are derived from the 
% all pairs shortest path matrix. This calculation requires
% the FastFloyd function available on the Matlab FileExchange.
%
% If epsilon is a is a vector the functions returns the 
% components for every threshold provided.
%
%
% Required inputs:
%	r : similarity matrix
%
% Optional parameters: 
%
%	epsilon : threshold (def = 1)
%
% Output:
%	modules : cell array holding modules
%
% Requires: FastFloyd.m (Matlab FEX)
%
% See also: ERRP 

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


% I/O check
varargin{2} = [];
if isempty(varargin{1}), epsilon = 1; else epsilon = varargin{1};end


for k = 1:length(epsilon)

	nw = zeros(size(r));  
	nw(r >= epsilon(k)) = 1;

	Dij= FastFloyd(1./nw);

	allNodes = 1:size(nw,1);
	comp = {};

	while ~all(isnan(allNodes))

		remainingNodes = find(not(isnan(allNodes)));	
		theNode = remainingNodes(1);
		idx = find( Dij(theNode,:) < Inf);
		if isempty(idx),break ;end
		comp{end+1} = idx;
		allNodes(idx) = NaN;
	end
	modules{k} = comp;
end

if length(epsilon) > 1;
	varargout{1} = modules;
else
	varargout{1} = modules{1};
end	

