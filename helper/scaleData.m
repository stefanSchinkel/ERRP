function y = scaleData(x,z)
%SCALEDATA - scale & normalise data 
%
% function Y = scaleData(X,R)
%
% Scale a given vector X to a given range R
% such that the resulting vector Y is represented
% within half the range. The data is the normalised 
% a mean of zero.
%
% Hence, the interval [-1 1] correspondes to the
% [ -range range ]. 
% 
% The input X may be a scalar vector
% or an MxN matrix, in which case the 
% function operates along M. This corresponds 
% to the channels in a single EEG epoch.
%
% Input:
%	X = data
%	R = range
%
% Output:
%	Y = rescaled data
%
% requires: 
%
% see also: ERRP:plotting:plot_eeg


y  = (x./( (z) - ( - (z) )) .*  (1 - (-1) ))   + (-1);
y =  y - repmat(mean(y,2),1,size(y,2)); 


% the generic function to scale data is defined as:
% y  = (x./(max(x)-min(x)) .*  (1 - (-1) ))   + (-1);
% which maps [min max] to [-1 1]
