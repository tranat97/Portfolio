function [pneumonia, fever, paleness, cough, highWBC] = main7_2learning()
%Finds ML estimate of parameters in BBN
pnm=importdata('pneumonia.tex');
feats = size(pnm,2);
t=find(pnm(:,feats));
pnmTrue=mean(pnm(t,:));
f=find(pnm(:,feats)==0);
pnmFalse=mean(pnm(f,:));

pneumonia=[size(t,1)/size(pnm,1), size(f,1)/size(pnm,1)];
fever=[pnmTrue(1), 1-pnmTrue(1);pnmFalse(1), 1-pnmFalse(1)];
paleness=[pnmTrue(2), 1-pnmTrue(2);pnmFalse(2), 1-pnmFalse(2)];
cough=[pnmTrue(3), 1-pnmTrue(3);pnmFalse(3), 1-pnmFalse(3)];
highWBC=[pnmTrue(4), 1-pnmTrue(4);pnmFalse(4), 1-pnmFalse(4)];
end

