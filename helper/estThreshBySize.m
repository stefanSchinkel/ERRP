function t = estThreshBySize(r,n)

%
% estThreshBySize - estimate threshold for similarity matrix
%
% function thresh = estThreshBySize(r,n [,t0])
%   
% Estimate the threshold for a similarity matrix so that the
% number of links (n) in the matrix (r) = n +/- 5%
%
% Inputs:
%	r : similarity matrix
% 	n : number of nodes 
%
% Output:
%	t : threshold for required number of links
%
% Requires: 
%
% See also: ERRP/nw

%
% Copyright (C) 2008 Stefan Schinkel, schinkel@agnld.uni-potsdam.de 
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

%error identifiers
errID = 'ERRP:helper:estThreshBySize';

t =1;


nw = zeros(size(r));
while abs(numel(find(nw))-n) > ceil(n*.05)
	nw = zeros(size(r));
	nw(r > t) =1;			
	if t == 0; t= NaN; error('FAILURE');break ;end
	t = t - .001;

end


