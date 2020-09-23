scores = zeros(70,1);
for i=1:70 
    scores(i) = Fisher_score(data(:,i), data(:,71));
end

[sorted, index] = sort(scores, 'descend');
result = [index,sorted];