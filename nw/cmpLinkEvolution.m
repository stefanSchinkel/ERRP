function m = cmpLinkEvolution(varargin)

% cmpLinkEvolution - compare links in networks overtime
%	
% cmplLinkEvolution(r1,r2,x,y) plots the links in r1 and r2 over time
% where the position of the nodes is provided in x and y.
%
% cmplLinkEvolution(r1,r2,x,y,ws,ss) plots the link that are stable
% over a time window ws
%
% cmplLinkEvolution(r1,r2,x,y,ws,ss) plots the link that are stable
% over a time window ws and uses a time increment of ss instead
% of one.
% cmplLinkEvolution(r1,r2,x,y,ws,ss,timeScale) uses the timescale provided 
% in the vector timeScale
% cmplLinkEvolution(r1,r2,x,y,ws,ss,timeScale,flag) overrides the strict
% flag in timeavgnw.m
%
% Required inputs:
%	r1 = network one (i x j x time)
%	r2 = network two (i x j x time)
%	x = x-coordinates of nodes
%	y = y-coordinates of nodes
%
% Optional inputs:
%	ws = size of window for temporal smooting
%	ss = time increment when smoothing
%	timeScale = a time scale to use instead of discrete indeces
%
% Output:
%	m = a (Matlab) movie of the sequence
%	
% Requires:	suptitle.m (Matlab FEX) 
%			plot_links, timeavgnw (ERRP);
%
% See also:
%
%

if nargin < 4
	help(mfilename)
	error('ERRP:plotting:cmpLinkEvolution','Not enough data');
end

varargin{9} = [];

r1 = varargin{1};r2 = varargin{2};
if size(r1) ~= size(r2)
	help(mfilename)
	error('ERRP:plotting:cmpLinkEvolution','r1 and r2 have different size');
end

x = varargin{3}; 
y = varargin{4};


if isempty(varargin{5}), ws = 1; else ws = varargin{5};end
if isempty(varargin{6}), ss = 1; else ss = varargin{6};end
if isempty(varargin{7}), tScale = 1:size(r1,3); else tScale = varargin{7};end
if isempty(varargin{8}), flag  = []; else flag = 1;end

% frame counter for movie, if requested
if nargout, cnt = 1; end

%if window given, we time average
if ws > 1;
	tr1 = timeavgnw(r1,ws,ss,flag);
	tr2 = timeavgnw(r2,ws,ss,flag);

else
	tr1 = r1;
	tr2 = r2;
end

%density for plotting
rho1 = squeeze(mean(mean(tr1,1),2));
rho2 = squeeze(mean(mean(tr2,1),2));

%fix timeScale
tDiff = length(tScale) - size(r1,3);
tScale1 = tScale(tDiff/2 +1 :end- tDiff/2);

maxRho = max(max([rho1 rho2]));
maxRho = maxRho + .1 * maxRho;
tDiff = length(tScale) - size(tr1,3);
tScale2 = tScale(tDiff/2 +1 :end- tDiff/2);



%prepare axes for link plots
h1 = subplot(2,2,1);title('Primed');
h2 = subplot(2,2,2);title('Unprimed');

%plot densities
h3 = subplot(2,2,3:4);
plot(tScale2(1:ss:end),rho1(1:ss:end));
hold on;
plot(tScale2(1:ss:end),rho2(1:ss:end),'r');
title(h3,sprintf('Links stable for %d time steps. Shifting: %d',ws,ss));
ylabel('Network Density');

timeRange = tScale1(1)-ws/2 +1 : tScale1(1)+ws/2;
m1 = [ timeRange fliplr(timeRange)] ;
m2 = [ repmat(0,1,ws) repmat(maxRho,1,ws)];

hFill = fill(m1,m2,'k','FaceAlpha',.2,'EdgeAlpha',.1);


for i=1:ss:size(tr1,3);
	
	%plot links
	cla(h1)
	plot_links(h1,x,y,tr1(:,:,i));
	cla(h2)
	plot_links(h2,x,y,tr2(:,:,i));

	%make patch 
	m1 = m1 + ss;
	set(hFill,'XData',m1);

	%time
	if ws > 1
		theTitle = sprintf('Time: %03d to %03d',tScale1(i),tScale1(i+ws));
	else
		theTitle = sprintf('Time : %03d',tScale(i));
	end
	suptitle(theTitle);
	drawnow;
	pause(.2);

	%save if requested
	if nargout
		m(cnt) = getframe(gcf);
		cnt = cnt + 1;
	end

end

