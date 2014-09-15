function r = jrpmat(rps,win)

nChans = size(rps,1);

% compute joint recurrence rates of sliced out windows
for i=1:nChans
	for j=i:nChans
		clear JRP
			rpi = rps(i,win,win);
			rpj = rps(j,win,win);
			JRP = rpi.*rpj;
			% r has to be normalised by the maximum JRR possible, which
			% is the MINIMUM of the indiviual Recurrence Rates
			warning off MATLAB:divideByZero	

			r(i,j) = mean(JRP(:)) / (min(mean(rpi(:)),mean(rpj(:))));
			r(j,i) = r(i,j);


	end %inner chan loop
end %out chan loop



