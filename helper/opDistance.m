function D = opDistance(dim)

%OPDISTANCE - Levenshtein distance between all patterns
%
% function D = opDistance(dim)
%
% Compute all distance between possible order patterns
% for a given dimension dim.
% 
%
% Input:
% 	dim = dimension (number of points)
%
% Output:
% 	D = matrix of distances
%
% requires: 
%
% see also: 

	nPies = factorial(dim);
	% usually we would use perms()
	% to compute all permutations, 
	% but this kills the memory
	% therefore iterative appraoch
	tic
 	pies = [];

	cnt = 0;
	while numel(pies) ~= nPies
		 pies = unique( [ pies; unique(opCalc(rand(1000,1),dim,1)) ]  ) ; 
		 cnt = cnt+1;
	end
	
	fprintf('For Dim %d patterns took %d runs and %f secs \n',dim,cnt,toc);
%	% allocate output
	D = zeros(nPies);
	tic
	for iPie = 1:nPies
		for jPie = iPie:nPies
			D(iPie,jPie) = levenshtein(num2str(pies(iPie)),num2str(pies(jPie)));
		end
	end
	fprintf('For Dim %d distance took %d runs and %f secs  \n',dim,cnt,toc);

end
% helper function to compute
% levenshtein distance, code from wikipedia
% improve, iff time
function [dist,L]=levenshtein(str1,str2)
    L1=length(str1)+1;
    L2=length(str2)+1;
    L=zeros(L1,L2);
 
    g=+1;%just constant
    m=+0;%match is cheaper, we seek to minimize
    d=+1;%not-a-match is more costly.
 
    %do BC's
    L(:,1)=([0:L1-1]*g)';
    L(1,:)=[0:L2-1]*g;
 
    m4=0;%loop invariant
    for idx=2:L1;
        for idy=2:L2
            if(str1(idx-1)==str2(idy-1))
                score=m;
            else
                score=d;
            end
            m1=L(idx-1,idy-1) + score;
            m2=L(idx-1,idy) + g;
            m3=L(idx,idy-1) + g;
            L(idx,idy)=min(m1,min(m2,m3));
        end
    end
 
    dist=L(L1,L2);
    return
end
