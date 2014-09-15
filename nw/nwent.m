function [h hn]= nwent(r,nBins)

%NWENT - compute entropy of NW (complexity)

if nargin == 1;
	nBins = 10;
end

r = triu(r,1); 
r = r(r ~= 0 ); r = r(r ~= 1 );
pX = hist(r(:),nBins) / numel(r);

%entropy
h =  - sum(pX.* log(pX));
% normalised entropy
hn =  h / log(numel(r));
