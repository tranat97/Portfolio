function [C, SENS, SPEC, err] = confusion_matrix(predict,target)
%Generates confusion matrix
predict = normalize_class(predict);
C = [sum(target&predict) sum(~target&predict);sum(target&~predict) sum(~target&~predict)]
SENS = C(1,1)/(C(1,1)+C(2,1))
SPEC = C(2,2)/(C(2,2)+C(1,2))
err = (C(1,2)+C(2,1))/sum(sum(C))
end

