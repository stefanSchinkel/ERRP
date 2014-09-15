function z = quantileNormal(P)

% calculate quantile of the standard normal distribution
% (inverse of the cumulative distribution function)
%
% z = quantileNormal(P)
%
% P:        probability
% z:        P-quantile of N(0,1)


% $Log: quantileNormal.m,v $
% Revision 1.2  2006/05/11 15:05:07  schinkel
% Fixed Bug in real Pvalue calculation and increased computing speed
%
% Revision 1.1.1.1  2006/03/31 12:50:35  schinkel
% Initial Import
%
    z = sqrt(2) * erfinv(2 * P - 1);
