function out = subjectAverage(vars,allConds)

%GRANDAVERAGE - grand average ofsubject averages per condition
%
% function subjectAverage(vars,conds,[formatGA])
%
% Computes the subject averages of all subjecs and conditions
% in the workspace. 
%
% THE FUNCTION EVALUATES IN THE BASE WORKSPACE !
%
% Required inputs:
%	cond :   all onditions ([11,12,22,...])
%
% Parameter:
%   formatGA: sprintf format for averages (def: GAc%d',cond)
%
% Output:
%	vars = name of grand averages
%
% 	THE CORRESPONDING GRAND AVERAGES ARE STORED IN THE WORKSPACE.
%
% Requires: 
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
error(nargchk(2,3,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))

varargin{2} = [];
if ~isempty(varargin{1}),formatGA = varargin{1}; 	else formatGA = 'GAc%d'; end


vars = sort(vars);
for i = 1:length(allConds);

	gaVars = vars(i:length(allConds):end);
	
	%make an empty, temporary cell array in the base space
	evalin('base',['tempData = {};']);
	
	%assing subject averages to (again in base)
	for j=1:length(gaVars),
		evalin('base',['tempData{end+1} =' gaVars{j} ';']);
	end  
	
	%construct name of GA variable
	GA = sprintf(formatGA,allConds(i));
	
	%assign grandaverage in base
	evalin('base',[GA ' = mean(cat(3,tempData{:}),3);'])
	
	%store variable name
	out{i} = GA;
end

