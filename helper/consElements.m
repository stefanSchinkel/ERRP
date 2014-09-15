function out = consElement(varargin)

% consElement: length of all consecutive elements in a vector
%
% Usage: lines = maxConsElement(vector, element)
%
% Return the number of consecutive occurences of an element in 
% a vector. If no element is given
%
% Input:
%	vector =  a vector
% 	element = element to find (def: 1)
%
% Output:
%	lines = length of consecutive lines
%
% requires: 
%
% see also: maxConsElements (opTool/helper)
%

% Copyright (C) 2008 Stefan Schinkel, University of Potsdam
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

% $Log$

%% I/O check
if (nargchk(1,2,nargin)), help(mfilename),error(lasterr); end
if (nargchk(0,1,nargout)), help(mfilename),error(lasterr); end

varargin{3} = [];

% input assignment 
vector = varargin{1};
if ~isempty(varargin{2}), element = varargin{2}; else element = 1;end

% the actual routine

%find element in question
index = vector==element;

%save time if nth. is found
if isempty(index), 
	out = [];
else
	%pad with zeros
	index = [0 index 0];
	tmp = diff(index);
	ind1 = find(tmp==1);
	ind2 = find(tmp==-1);
	out = ind2-ind1;
end


