function [AScore] = AUROC_score(x,y)
%Computes AUROC score
[X,Y,T,AScore] = perfcurve(y,x,1);
end

