function [fScore] = Fisher_score(x,y)
%Compute Fisher Score
pos = x(find(y==1));
neg = x(find(y==0));
fScore = ((mean(pos)-mean(neg))^2) / (std(pos)^2+std(neg)^2);
end

