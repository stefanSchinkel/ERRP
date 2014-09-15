function out = eeg_laplace(eeg,distMatrix,order)


for i=1:size(eeg,3);

	out(:,:,i) = laplace(eeg(:,:,i),distMatrix,order);
	
end
