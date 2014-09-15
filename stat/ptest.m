
function varargout = ptest(varargin)

% PTEST - permutation tests of two samples
% 
% [p z P] = ptest(x,y [,n]) 
% 
% The function performs a permutation test 
% ("non-parametric t-test") on the samples 
% provided in x and y. The number of permutations
% can be chosen by n and defaults to 500. 
% 
% Input:
%	x = sample 1 (vector)
%	y = sample 2 (vector)
%
% Parameters: 
%	n = number of permutations (def: 500)
%
% Output:
%	p = p-value of two-sided test
%	z = z-value derived from erfinv 
% 	P = p-value of permutation test
%
% Requires:
% 
% See also: 
% 
% Example: 
%	%data form german wikipedia on t-test
%	x = [223,259,248,220,287,191,229,270,245,201];
%	y = [220,244,243,211,299,170,210,276,252,189];
%	
%	%permutation test with 1000 repetions
%	[p z] = ptest(x,y,1000);
%	%validate with t-test
%	[h pttest ci stat] = ttest2(x,y);
%
%	Both p-values are around .75 and we cannot reject the Null-Hypothesis. 



% debugging options
debug = true;

%% check input

if nargin <2 || nargin >4, error('Bad Input. Usage:[z p P] = permtest2(x,y,n)');end

%% avoid indexation error
varargin{4}= []; 

if ~isempty(varargin{1}), x=varargin{1}; else help(mfilename),error('Input Error');end
if ~isempty(varargin{2}), y=varargin{2}; else help(mfilename),error('Input Error');end
if ~isempty(varargin{3}), nPerms=varargin{3}; else nPerms=500; end

% check if we have 2 vectors
if ~isVector(x) | ~isVector(y)
	help('ptest')
	error('ERRP:ptest:inputError','Samples have to be vectors');
elseif numel(x) ~= numel(y)
	% and if they have the same no of elements
	help('ptest')
	error('ERRP:ptest:xyMismatch','Samples have to be of same size');

end

% ensure colunm vector (Nx1)
x = x(:);
y = y(:);


% number of elements in sample
nX = numel(x);
nY = numel(y);
nXY = nX + nY;

% pool samples
xy = [x; y];

% compute obsered statistic
ostat = mean(x)-mean(y);


% construct random indeces for resampling
[ignore k]=sort(rand(nXY,nPerms)); 


% construct a set of those permutations
pSamples = xy(k);

% and compute the statistics
stats = mean(pSamples(1:nX,:)) - mean(pSamples(nX+1:end,:));

% compute temporary P - values (one-sided !)
P = mean( stats <= ostat); 

%  convert to twosided p-value
p=min(2*P,2*(1-P));

% and look up z-value
z = quantileNormal(P);

varargout{1} = p;
varargout{2} = z;
varargout{3} = P;

% when debugging we show the distribution of values
% and the postion of the original statistic
if debug & nargout < 1
	clf
	plot(sort(stats),1:nPerms);hold on; 
	line([ostat ostat],ylim,'LineStyle','--','Color','k')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% helper functions
function status = isVector(x)

% determine whether data is a vector
if ndims(x) == 2 && min(size(x)) == 1
	status = boolean(1);
else
	status = boolean(0);
end


function z = quantileNormal(P)

% calculate quantile of the standard normal distribution
% (inverse of the cumulative distribution function)
%
% z = quantileNormal(P)
%
% P:        probability
% z:        P-quantile of N(0,1)

z = sqrt(2) * erfinv(2 * P - 1);
