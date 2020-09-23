tr_x = hw10_train(:,1:65);
tr_y = hw10_train(:,66);
tst_x = hw10_test(:,1:65);
tst_y = hw10_test(:,66);

bagging_error = zeros(10,2);

%1
for i=1:20
    train_error = Bag_classifier(tr_x,tr_y,tr_x,'[@DT_base_full,1,[]]');
    test_error = Bag_classifier(tr_x,tr_y,tst_x,'[@DT_base_full,1,[]]');
    avgErr = avg_Error(tr_y, train_error, tst_y, test_error);
    bagging_error(1,:) = bagging_error(1,:) + avgErr;
end
%2
for i=1:20
    train_error = Bag_classifier(tr_x,tr_y,tr_x,'[@DT_base_full,2,[]]');
    test_error = Bag_classifier(tr_x,tr_y,tst_x,'[@DT_base_full,2,[]]');
    avgErr = avg_Error(tr_y, train_error, tst_y, test_error);
    bagging_error(2,:) = bagging_error(2,:) + avgErr;
end
%3
for i=1:20
    train_error = Bag_classifier(tr_x,tr_y,tr_x,'[@DT_base_full,3,[]]');
    test_error = Bag_classifier(tr_x,tr_y,tst_x,'[@DT_base_full,3,[]]');
    avgErr = avg_Error(tr_y, train_error, tst_y, test_error);
    bagging_error(3,:) = bagging_error(3,:) + avgErr;
end
%4
for i=1:20
    train_error = Bag_classifier(tr_x,tr_y,tr_x,'[@DT_base_full,4,[]]');
    test_error = Bag_classifier(tr_x,tr_y,tst_x,'[@DT_base_full,4,[]]');
    avgErr = avg_Error(tr_y, train_error, tst_y, test_error);
    bagging_error(4,:) = bagging_error(4,:) + avgErr;
end
%5
for i=1:20
    train_error = Bag_classifier(tr_x,tr_y,tr_x,'[@DT_base_full,5,[]]');
    test_error = Bag_classifier(tr_x,tr_y,tst_x,'[@DT_base_full,5,[]]');
    avgErr = avg_Error(tr_y, train_error, tst_y, test_error);
    bagging_error(5,:) = bagging_error(5,:) + avgErr;
end
%6
for i=1:20
    train_error = Bag_classifier(tr_x,tr_y,tr_x,'[@DT_base_full,6,[]]');
    test_error = Bag_classifier(tr_x,tr_y,tst_x,'[@DT_base_full,6,[]]');
    avgErr = avg_Error(tr_y, train_error, tst_y, test_error);
    bagging_error(6,:) = bagging_error(6,:) + avgErr;
end
%7
for i=1:20
    train_error = Bag_classifier(tr_x,tr_y,tr_x,'[@DT_base_full,7,[]]');
    test_error = Bag_classifier(tr_x,tr_y,tst_x,'[@DT_base_full,7,[]]');
    avgErr = avg_Error(tr_y, train_error, tst_y, test_error);
    bagging_error(7,:) = bagging_error(7,:) + avgErr;
end
%8
for i=1:20
    train_error = Bag_classifier(tr_x,tr_y,tr_x,'[@DT_base_full,8,[]]');
    test_error = Bag_classifier(tr_x,tr_y,tst_x,'[@DT_base_full,8,[]]');
    avgErr = avg_Error(tr_y, train_error, tst_y, test_error);
    bagging_error(8,:) = bagging_error(8,:) + avgErr;
end
%9
for i=1:20
    train_error = Bag_classifier(tr_x,tr_y,tr_x,'[@DT_base_full,9,[]]');
    test_error = Bag_classifier(tr_x,tr_y,tst_x,'[@DT_base_full,9,[]]');
    avgErr = avg_Error(tr_y, train_error, tst_y, test_error);
    bagging_error(9,:) = bagging_error(9,:) + avgErr;
end
%10
for i=1:20
    train_error = Bag_classifier(tr_x,tr_y,tr_x,'[@DT_base_full,10,[]]');
    test_error = Bag_classifier(tr_x,tr_y,tst_x,'[@DT_base_full,10,[]]');
    avgErr = avg_Error(tr_y, train_error, tst_y, test_error);
    bagging_error(10,:) = bagging_error(10,:) + avgErr;
end

bagging_error = bagging_error./20;
figure();
scatter(1:10, bagging_error(:,1), 'filled')
hold on
scatter(1:10, bagging_error(:,2), 'filled')
