close all
distances=[];
sizes=[];
for i=1:30
    [s,d] = k_means(4);
    distances = [distances;d];
    sizes = [sizes;s];
end
[min, i]=min(distances)
