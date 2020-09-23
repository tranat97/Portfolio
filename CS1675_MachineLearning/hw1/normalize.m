function [normalized] = normalize(data)
    if ~isvector(data)
        error('Input must be a vector')
    end
    normalized = (data - mean(data))./std(data);
end

