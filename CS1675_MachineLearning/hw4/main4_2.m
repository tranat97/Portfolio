function [trainError, testError, w] = main4_2()
%loads in testing and training sets, calculates weights 
%from training set. Returns mean squared error for both sets, and weights

%load in data
train = importdata('housing_train.txt');
test = importdata('housing_test.txt');
%solve for weights
w = LR_solve(train(:,1:13), train(:,14));
%calculate predictions
trainPredict = LR_predict(train(:,1:13), w);
testPredict = LR_predict(test(:,1:13), w);
%mean squared error
trainError = immse(train(:,14),trainPredict);
testError = immse(test(:,14), testPredict);
end

