function [P, prior0] = main2_2()
%Returns parameter estimates
%load training set
x = importdata('pima_train.txt');
P = cell(2,8);
Dist_type = [0 1 1 1 0 1 0 0]; %0=>Exponential 1=>Normal
%split up set into classes
x0 = x(find(x(:,9)==0),:);
x1 = x(find(x(:,9)),:);
prior0 = size(x0)/(size(x0)+size(x1));

for i=1:8
    if(Dist_type(i) == 0)
        P{1,i} = expfit(x0(:,i));
        P{2,i} = expfit(x1(:,i)); 
    else
        [mu, sigma] = normfit(x0(:,i));
        P{1,i} = [mu, sigma];
        [mu, sigma] = normfit(x1(:,i));
        P{2,i} = [mu, sigma];
    end
end
end

