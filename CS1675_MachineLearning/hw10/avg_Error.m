function [avgError] = avg_Error(train_target,train_predict, test_target, test_predict)
%
train_miss = find(train_target ~= train_predict);
test_miss = find(test_target ~= test_predict);

trainError = size(train_miss,1)/size(train_target,1);
testError = size(test_miss,1)/size(test_target,1);
avgError = [trainError, testError];
end

