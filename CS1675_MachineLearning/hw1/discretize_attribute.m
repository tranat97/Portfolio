function [discrete] = discretize_attribute(data,bins)
    if ~isvector(data)
        error('Input must be a vector')
    end
    
    maximum = max(data);
    binSize = (maximum-min(data))/bins;
    lower = min(data);
    upper = lower+binSize;
    discrete{bins,1} = [];
    temp = [];
    for i=1:bins
        if upper==maximum %make sure to include the max value
            temp = data(find(data>=lower & data<=upper));
        else
            temp = data(find(data>=lower & data<upper));
        end
        discrete{i} = temp;
        lower = upper;
        upper = lower+binSize;
    end
    
end

