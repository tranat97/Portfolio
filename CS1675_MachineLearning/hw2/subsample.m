function [newdata] = subsample(data,k)
%Takes a random subsample from data of size k
    newdata = data(randperm(size(data,1),k),:);
end

