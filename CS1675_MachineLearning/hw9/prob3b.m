figure()
for i=1:4
    cluster = Y(find(C==i),:);
    scatter(cluster(:,1),cluster(:,2), 'filled');
    hold on
end