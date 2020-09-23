function [] = main2_3()
%Predicts classification for test and training sets
train = importdata('pima_train.txt');
test = importdata('pima_test.txt');

train_predict = predict_NB(train);
test_predict = predict_NB(test);

[C_train, SENS, SPEC, trainErr] = confusion_matrix(train_predict,train(:,9))
[C_test, SENS, SPEC, testErr] = confusion_matrix(test_predict,test(:,9))
end

