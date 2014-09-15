function out = timeavgnw(varargin)

% AVGNW - time average adjacency matrices
%	
% This function takes an adjacency matrix
% and computes the average (ie. commonly found links)
% over a certain time range
%
% Required inputs:
% x = a set of adjacency matrices ( r x time)
%
% Options: 
%
% ws = size of the window considered
% ss = time shift of window
% f = flag switching from loose to strict
%
% Output:
% r = average network, same size as x 
%
% Requires:  
%
% See also:
%

varargin{5} = [];

r = varargin{1};
ws = varargin{2};
if isempty(varargin{3}), ss = 10; else ss = varargin{3};end
if isempty(varargin{4}); flagOverride = false; else flagOverride = true;end

nX = size(r,3);

for iWin=1:ss:nX-ws;
	out(:,:,iWin) = mean(r(:,:,iWin:iWin+ws-1),3);
end

if ~flagOverride
	out(out < 1) = 0;
	out = uint8(out);

end
