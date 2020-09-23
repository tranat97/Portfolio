function [s,d] = k_means(k)
%
data = importdata('clustering_data.txt');
[x,m]=kmeans(data,k);
d = 0;
s = [];
figure();
hold on
for i=1:k
    cluster = data(find(x==i),:);
    s = [s,size(cluster,1)];
    d = d + sqrt(sum(sum((cluster-m(i)).^2)));
    scatter(cluster(:,1),cluster(:,2), 'filled');
    hold on
end
scatter(m(:,1), m(:,2),'k', 'filled');
hold off
end

