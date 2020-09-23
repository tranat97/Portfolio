function [] = histogram_analysis(data)
    if ~isvector(data)
        error('Input must be a vector')
    end
    histogram(data, 20)
end

