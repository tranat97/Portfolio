function [y_predict] = DT_base_full(tr_x, tr_y, test_x, params)
%Uses decision tree algorithm with contraints
tree=fitctree(tr_x,tr_y,'MaxNumSplits',25, 'MinParentSize',10,'MinLeafSize',2,'splitcriterion','gdi');
y_predict = predict(tree, test_x);
end

