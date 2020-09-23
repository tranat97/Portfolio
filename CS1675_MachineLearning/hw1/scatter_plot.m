function [] = scatter_plot(x,y)
    %both inpuuts muist be vectors of the same size
    if ~isvector(x) || ~isvector(y)
        error('Both inputs must be vectors')
    end
    if size(x) ~= size(y)
        error('Both inputs must be the same size')
    end
    scatter(x,y, 'filled')
end

