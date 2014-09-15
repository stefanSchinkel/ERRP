function [NI D DC] = nwstats(mat,thresh)

% NWSTATS - primitive network stats of similarity matrix
%
% function [NI D DC] = nwstats(mat,thresh)

if nargin < 2, thresh = 1;end

for i = 1:size(mat,3)

	r = abs(mat(:,:,i));

	NI(i,:) = nodeIntensity(r);

	id1 = r >= thresh;
	theNW = zeros(size(r));
	theNW(id1) = 1;

	D(i,:) = nodeIntensity(theNW);

	%find the shortest pathes
	paths = FastFloyd(1./theNW);

	%erase self loops
	for k=1:size(paths,1)
		paths(k,k) = 0;
	end

	% set distance to unreachable members to zero
	paths(paths == Inf) = 0;
	DC(i,:) = mean(paths);

end
