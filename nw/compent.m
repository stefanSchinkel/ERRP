function h = compent(comp)

%COMPENT - entropy of component distribution
%
%
% Input:
%	comp = component (cf. nwcomp)
%
% Output: 
%	h = normalised shannon entropy of component distribution
%
% see also: nwcomp.m, shannon.m
%
% requires:
%

nX = sum(cellfun(@numel,comp));
pX = cellfun(@numel,comp) / nX; 
h = - sum(pX.* log(pX)) / log(nX);
