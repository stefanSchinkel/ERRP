function vars = subjectAverage(allSubs,allConds)

%SUBJECTAVERAGE - subject averages of all subject&conditions
%
% function subjectAverage(subs,conds,[formatSA,formatVar])
%
% Computes the subject averages of all subjecs and conditions
% in the workspace. 
%
% THE FUNCTION EVALUATES IN THE BASE WORKSPACE !
%
% Required inputs:
%	subs :   all subjects ([1,2,3,...])
%	cond :   all conditions ([11,12,22,...])
%
% Parameter:
%   formatSA: sprintf format for averages (def: SA%02dc%d',sub,cond)
%   formatVar: sprintf format of variables (def: s%02dc%d',sub,cond)
%
% Output:
%	vars = name of subject averages
%
% 	THE CORRESPONDING SUBJECT AVERAGES ARE STORED IN THE WORKSPACE.
%
% Requires: allcomb.m (FEX)
%
% See also:  ERRP

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
% debug settings

debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(2,4,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))

varargin{3} = [];
if ~isempty(varargin{1}),formatSA = varargin{1}; 	else formatSA = 'SA%02dc%d'; end
if ~isempty(varargin{2}),formatVar = varargin{2}; 	else formatVar = 's%02dc%d'; end

combos = allcomb(1:length(allSubs),1:length(allConds));

for i=1:size(combos,1);
	SA = sprintf(formatSA,allSubs(combos(i,1)),allConds(combos(i,2)));
	var = sprintf(formatVar,allSubs(combos(i,1)),allConds(combos(i,2)));
	evalin('base',[SA '= mean(' var ',3);'])
	varNames{i} = SA;
end

if nargout,
	vars = varNames;
end
	
