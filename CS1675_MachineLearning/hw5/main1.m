function [] = main1()
    %W = Log_regression(X,y,2000);
    %load in data
    train = importdata('pima_train_norm.txt');
    test = importdata('pima_test_norm.txt');
    Y = importdata('pima_train.txt');
    Y = Y(:,9);
    testY = importdata('pima_test.txt');
    testY = testY(:,9);
    
    pgraph = init_progress_graph;
    
W = zeros(size(train, 2), 1); % initialize W to 1 to start with 

for k = 0:1:999                       %%% number of steps
    sum_err = 0;                    %%% initialize batch error function gradient
    for row = 1:1:size(train, 1)
        x = train(row,:)';
        y = Y(row,:);
        f = 1/(1 + exp(-(W'*x)));
        err = (y - f) * x;          % error (on-line gradient)
        sum_err = sum_err + err;    % update batch error function gradient
    end
    alpha = 1;
    W = W + (alpha * sum_err);
    if (mod(k,25)==0)
    [C, SENS, SPEC, trainErr] = confusion_matrix(train(:,1:8)*W,Y);
    [C, SENS, SPEC, testErr] = confusion_matrix(test*W,testY);
    pgraph = add_to_progress_graph(pgraph, k+1, trainErr, testErr);
    end
end

