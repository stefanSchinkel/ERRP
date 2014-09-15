 function adjMat = corr2adj(corrMat,varargin)

%CORR2ADJ convert correlation matrix to adjacency matrix
%
% function [adjMat] = corr2adj(corrmat,n)
%
% 
% 
% 
% 
%
% Input:
%	corrMat = correlation matrix
%
% Options:
%	n = number of levels (def: 4)
%
% Output:
%	adjMat = adjacency matrix
%
% requires: histX.m
%
% see also: opTool, ERRP
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

% $Log:$

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(1,2,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))

%% check and assing input
varargin{2} = [];
if isempty(varargin{1}); nBins = 4; else nBins = varargin{1};end

%compute histogramm with nBins from flattened corrMat
[p z x] = histX(corrMat(:),nBins); 

%reshape 
adjMat = reshape(x,size(corrMat));
