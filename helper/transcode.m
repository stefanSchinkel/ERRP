function varargout = transcode(varargin)

%TRANSCODE transcode OPs to 3 Symbol distribution
%
% function Y = transcode(X)
%
% The function maps an array of order patterns into an array of
% 3 symbols - which can later on be subjected to a reversi 
% transformation (see reversi.m). The order patterns may be of 
% dimension 3 or 4. No other supported (yet?)
%
% Input:
%	X = OP vector (from opCalc.m with dim = 3|4)
% Output:
%	Y = 3 Symbol vector
%
% requires: 
%
% see also: 
%

% Copyright (C) 2009 Stefan Schinkel, University of Potsdam
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
%
% $Log$


%% debug settings
debug = 0;

% check number of input arguments
error(nargchk(1,1,nargin))

% check number of out arguments
error(nargoutchk(0,1,nargout))

X = varargin{1};

% determine whether dim is 3 or 4
xMax = max(X);
if 100 > xMax | 5000 < xMax
	help(mfilename),error(); 
elseif	xMax < 400
	dim = 3;
else
	dim = 4;
end


%the alphabets :
max3d = [231,213]; 
min3d = [312,132];
max4d = [3421,2341,2431,1342,1243,1432];
min4d = [4312,4213,4123,3214,3124,2134];


if dim == 3;
	Xmax = ismember(X, max3d);
	Xmin = ismember(X, min3d);
else
	Xmax = ismember(X, max4d);
	Xmin = ismember(X, min4d);
end

Y = ones(size(X));

%% common routine
Y(Xmax) = 0;
Y(Xmin) = 2;
%Y(~max & ~min) = 1;

% assign output
varargout{1} = Y;
