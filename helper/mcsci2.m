function [out str] = mcsci2(x,y,win,varargin)

%MCSCI - Monte-Carlo confidence bound comparisons
%
% function out = mcsci(x,y [,dim,tau,eps,meth,nSamples,nBoot,alpha,theiler,minL,minV])
%
%
% Compute confidence bounds of RQA measures from an RP
% by bootstrapping the diagonal and vertical line structures.
%
% Input:
% 	x = MxN matrix (set of vectors)
% 	y = MxN matrix (set of vectors)
%	win = window
%
% MCSCI-options:
%	dim = embedding dimension (def: 1)
%	tau = embedding delay (def: 1)
%	eps = recurrence threshold	(def: .1)
%	meth = recurrence criterion (def: 'fan')
% 	nSamples = number of MCS comparsions (def: 500)
%
% RQACI-options:
% 	nBoot = number of bootstrap samples in rqaci() (def: 500)
% 	alpha = confidence level in % (def: 5)
% 	theiler = size of the theiler window (def: 1)
% 	minL = minimal size of diagonal lines in RQA (def: 2)
% 	minV = minimal size of vertical lines in RQA (def: 2)
%
% Output:
%	out = ...
%
% requires: rqaci.m, crp.m
%
% see also: ERRP, CRPtool
%
% References: 
% S. Schinkel, N. Marwan, O. Dimigen & J. Kurths (2009): 
% "Confidence Bounds of recurrence-based complexity measures"
% Physics Letters A,  373(26), pp. 2245-2250
%

% Copyright (C) 2010 Stefan Schinkel, University of Potsdam
% http://www.agnld.uni-potsdam.de/~schinkel
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

verbose = true;

%% I/O check
if (nargchk(3,10,nargin)), help(mfilename),return; end
if (nargchk(0,2,nargout)), help(mfilename),return; end

varargin{10} = [];

% input assignment 
if ~isempty(varargin{1}), dim = varargin{1}; else dim = 1;end
if ~isempty(varargin{2}), tau = varargin{2}; else tau = 1;end
if ~isempty(varargin{3}), eps = varargin{3}; else eps = .1;end
if ~isempty(varargin{4}), meth = varargin{4}; else meth = 'fan';end
if ~isempty(varargin{5}), nSamples = varargin{5}; else nSamples = 500;end

if ~isempty(varargin{6}), nBoot = varargin{6}; else nBoot = 500;end
if ~isempty(varargin{7}), alpha = varargin{7}; else alpha = 1;end
if ~isempty(varargin{8}), theiler = varargin{8}; else theiler = 1;end
if ~isempty(varargin{9}), minL = varargin{9}; else minL = 2;end
if ~isempty(varargin{10}), minV = varargin{10}; else minV = 2;end


% names of input, for summary
varA = inputname(1);
varB = inputname(2);

% create random samples, w/ replacement
trialsX = randsample(1:size(x,2),nSamples,1);
trialsY = randsample(1:size(y,2),nSamples,1);

% create all rps in set
% maybe include some short-circuting here, 
% to prevent memory errors if data is really large

allRPsX = allrps(x,dim,tau,eps,meth);
allRPsY = allrps(y,dim,tau,eps,meth);


% loop over samples and compare bounds
for iSample = 1:nSamples

	% to be sure we dont get annoyed
	warning off all

	[valA ciA] = rqaci(squeeze(allRPsX(trialsX(iSample),win,win)),nBoot,alpha,theiler,minL,minV);
	[valB ciB] = rqaci(squeeze(allRPsY(trialsY(iSample),win,win)),nBoot,alpha,theiler,minL,minV);

	out(iSample,:) = cicompare(ciA,ciB);

end


% assemble summary string
% parameters
str = '';
str = 	strvcat(str,sprintf('Using the following parameters:'));
str = 	strvcat(str,sprintf('dim: %d, tau: %d, eps: %01.3f meth : %s',dim,tau,eps,meth));
str = 	strvcat(str,sprintf('Window: %d to %d',win(1),win(end)));
str = 	strvcat(str,sprintf('MCSCI-Samples: %d, RQACI-Samples: %d alpha: %d',nSamples,nBoot,alpha)); 
% results
str = 	strvcat(str,printSummary(out,nSamples,varA,varB));

% if output is not assigned, print summary
if ~nargout
	disp(str);
end

end % function mcsci()

%%%%%%%%%%%%%	SUBFUNCTIONS %%%%%%%%%%%%%%%%%%%%

function rps = allrps(x,dim,tau,eps,meth)

	for i = 1:size(x,2)

		% get trial and cast to double
		data = double(x(:,i));
		%create RP and store in out
		rps(i,:,:) = crp(data,dim,tau,eps,meth,'sil');

	end

end % function allrps()


function string = printSummary(out,nSamples,varA,varB)
	
	string = '';
	
	measures = {'DET','L','LAM','TT'};
	theVars = repmat({varA;varB},3,1);

	% print a summary statistic	
	string = strcat(string,sprintf('\t%s > %s\t%s=%s\t%s<%s\n', theVars{:}));

	for i = 1:4

		percentMinus =  numel(find(out(:,i) == -1))/nSamples*100; 	% x is larger
		percentZero =  numel(find(out(:,i) == 0))/nSamples*100;		% both are equal
		percentPlus =  numel(find(out(:,i) == 1))/nSamples*100;			% y is larger

		string = strvcat(string,sprintf('(%s)\t %03.2f%% \t %03.2f%% \t %03.2f%%',... 
			measures{i},percentMinus,percentZero,percentPlus));
				
	end

end % printSummary()
