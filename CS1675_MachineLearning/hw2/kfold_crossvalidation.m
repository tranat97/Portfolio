function [train,test] = kfold_crossvalidation(data,k,m)
if m>k || m<1
    error('m must be in range [1,k]')
end
%Makes k folds of data and returns the mth fold
    n = size(data,1);
    foldSize = floor(size(data,1)/k);
    folds{k,1} = [];
    lower = 1;
    upper = foldSize;
    
    %create list of random numbers
    rnds = randperm(n,n);
    %divide data into folds of equal numbers
    for i=1:k
        folds{i} = data(rnds(lower:upper));
        lower = upper+1;
        upper = lower+foldSize-1;
    end
    %if possible, divide rest of the data between the arrays
    i=1;
    while lower<=n
        folds{i} = [folds{i};data(rnds(lower))];
        i = i+1;
        lower = lower+1;
    end
    test = folds{m};
    train = [];
    for i=1:k
        if i~=m
            train = [train;folds{i}];
        end
    end
end

