function [training,testing] = divideset(data,pTrain)
    if pTrain >= 1 || pTrain < 0
        error('pTrain must be positive and less than 1')
    end
    %create array of random numbers from 1 to the size of the data set
    randNums = randperm(size(data,1));
    %training size is rounded down
    trainingSize = floor(size(data,1)*pTrain);
    %preallocate space
    training = zeros(trainingSize, size(data,2));
    testing = zeros(size(data,1)-trainingSize, size(data,2));
    %populate training set first
    for i=1:trainingSize
        training(i,:) = data(randNums(i),:);
    end
    %use rest of the random numbers to populate testing set
    j=1;
    for i=(trainingSize+1):size(data,1)
        testing(j,:) = data(randNums(i),:);
        j=j+1;
    end
end

