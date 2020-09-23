function [] = main2_1()
%Splits the data set into to classes and plots them using a histogram
close all;
pima = importdata('pima.txt');
x0 = pima(find(pima(:,9)==0),:);
x1 = pima(find(pima(:,9)),:);

for i=1:8
figure(i);
histogram_analysis(x0(:,i));
hold on;
histogram_analysis(x1(:,i));
hold off;
end

