function [] = main4_3()
    
    %load in data
    train = importdata('housing_train.txt');
    test = importdata('housing_test.txt');
    
    % normalize both sets
    [mean_norm, std_norm] = compute_norm_parameters(train);
    train_norm = normalize(train, mean_norm, std_norm);
    pgraph = init_progress_graph;
    %calculate weights
    
    %w = gradient_descent(train_norm(:,1:13), train_norm(:,14), pgraph);
    
    w = zeros(13,1);
    n = size(train_norm,1);
    for i=0:1000
       k=mod(i,n)+1;
       alpha = 2/sqrt(i+1);
       prediction = LR_predict(train_norm(k,1:13),w);
       w = w + alpha*(train_norm(k,14) - prediction)*train_norm(k,1:13)';
       if(mod(i,50)==0)
           %calculate predictions
           trainPredict = LR_predict(train(:,1:13), w);
           testPredict = LR_predict(test(:,1:13), w);
           %mean squared error
           trainError = immse(train(:,14),trainPredict);
           testError = immse(test(:,14), testPredict);
           pgraph = add_to_progress_graph(pgraph, i, trainError, testError);
       end
       
    end
    
    %calculate predictions
    trainPredict = LR_predict(train(:,1:13), w);
    testPredict = LR_predict(test(:,1:13), w);
    %mean squared error
    trainError = immse(train(:,14),trainPredict);
    testError = immse(test(:,14), testPredict);
    
    Results = sprintf('Training Error: %d\nTest Error: %d',trainError, testError)
end

