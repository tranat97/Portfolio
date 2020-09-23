function [y] = apply_svml(x, w, b)
%Predicts class 
y = double(x*w+b>=0);
end

