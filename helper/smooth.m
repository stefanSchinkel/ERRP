function y=smooth(x,w,a)
%SMOOTH   Smoothes data.
%    Y=SMOOTH(X,U,A) smoothes the vector X with a filter A
%    of length U. The following filter are included:
%    A=1   rectangular (boxcar) window
%      2   Bartlett window
%      3   Blackman window
%      4   Chebyshev window 
%      5   Hamming window 
%      6   Hann window
%      7   Kaiser window
%

% Copyright (c) 1998-2006 by AMRON
% Norbert Marwan, Potsdam University, Germany
% http://www.agnld.uni-potsdam.de
%
% Last Revision: 2006-03-16


error(nargchk(2,3,nargin))
error(nargoutchk(0,1,nargout))

if nargin~=3
   a=1;
end
if a<1 | a>7
  disp('Argument A must be between 1 and 7. Changed to A=1.')
  a=1;
end
if w<=1
  error('Window length must be greater than 1.')
end

if size(x,1) == 1 & size(x,2) > 1; x = x'; end
if size(x,1) <= w; error('Data length too short.'); end

% filter/ window

switch(a)

case 1

   filter=boxcar(w);

case 2
   
   filter=bartlett(w);

case 3
   
   filter=blackman(w);

case 4
   
   filter=chebwin(w,100);

case 5
   
   filter=hamming(w);

case 6
   
   filter=hann(w);

case 7
   
   filter=kaiser(w,3);

end

nrm=sum(filter);

% extrapolation of data
B=interp1([1:size(x,1)]',x,[-floor(w/2)+1:0]','nearest','extrap'); 
B(floor(w/2)+1:length(x)+floor(w/2),:)=x;
B(length(x)+floor(w/2)+1:length(x)+2*floor(w/2),:)=interp1([1:length(x)]',x,[length(x)+floor(w/2)+1:length(x)+2*floor(w/2)]','nearest','extrap');

% convolution
for i = 1:size(x,2)
    yT = conv(B(:,i),filter)/nrm;	% faltung = gleitende Mittelung
    y(1:length(yT(1+w:length(x)+w)),i) = yT(1+w:length(x)+w);   % bringt r wieder auf die laenge von y
end
