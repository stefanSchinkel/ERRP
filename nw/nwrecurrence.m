function out = nwrecurrence(x)

out = zeros(size(x,3),size(x,3));

for iFrame = 1:size(x,3)
	for jFrame = 1:iFrame
		nwX = x(:,:,iFrame);
		nwY = x(:,:,jFrame);
		
		out(iFrame,jFrame) = sum(sum(nwX .* nwY)) / sum(nwX(:));
		out(jFrame,iFrame) = out(iFrame,jFrame);
		
	end %jFrame
end % iFrame