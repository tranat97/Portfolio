function [norm] = normalize_class(X)
%Assigns class 0 if <0; 1 if >0
norm = zeros(size(X,1), 1);
n = find(X<=0);
norm(n) = 0;
n = find(X>0);
norm(n) = 1;
end

