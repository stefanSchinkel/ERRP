function rp = makeRP(varargin);

%makeRP - make an RP with eps = 0 
%
% function rp = rp(X [,Y])
%
% If no Y is given then Y = X
%
% Input:
%	X = symbol vector
%	Y = symbol vector
% Output:
%	rp = rp matrix
%
% requires: 
%
% see also: reversi.m wordstat.m

debug = 0;

% check number of input arguments
error(nargchk(1,2,nargin))

% check number of out arguments
error(nargoutchk(0,1,nargout))
varargin{3} = [];
X = varargin{1};

if size(X,1) < size(X,2); X = X';end
if ~isempty(varargin{2});Y = varargin{2}; else Y = X; end

%reshape for matching
Y = Y';

if debug, size(X),size(Y),end

rp =  uint8(X(:,ones(1,length(X)),:) == Y(ones(1,length(Y)),:,:))';	
