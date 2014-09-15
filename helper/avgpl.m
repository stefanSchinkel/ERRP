function [apl] = avgpl(nw)

% AVGPL - arage pathlength of a network
% 
% Average pathlength of undirected nework.
%
% requires: FastFloyd.m (FEX)

N = size(nw,1);

dij = FastFloyd(1./nw);
dij= 1./dij;
apl = sum(dij(:)) /2 / (N*(N-1)/2);
