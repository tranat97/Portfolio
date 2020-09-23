function [y, p0, p1] = predict_NB(X)
%Predicts Classification
[P, prior0] = main2_2;
prior1 = 1-prior0;
y = zeros(size(X,1),1);
p0 = zeros(size(X));
p1 = zeros(size(X));

for i=1:8
    if(size(P{1,i},2)==1) %exponential
        mu = P{1,i};
        p0(:,i) = exppdf(X(:,i),mu);
        mu = P{2,i};
        p1(:,i) = exppdf(X(:,i),mu);
    else %normal
        para = P{1,i};
        p0(:,i) = normpdf(X(:,i),para(1), para(2));
        para = P{2,i};
        p1(:,i) = normpdf(X(:,i),para(1), para(2));
    end
end
p0(:,9) = sum(log(p0(:,1:8)),2)+log(prior0);
p1(:,9) = sum(log(p1(:,1:8)),2)+log(prior1);
for j=1:size(X)
    if(p1(j,9)>p0(j,9))
        y(j) = 1;
    end
end
end

