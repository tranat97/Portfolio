function [prob] = main7_2inference(cond)
%Estimates P(Pneumonia=T|Conditions)
[Pnm,F,P,C,H]=main7_2learning();
params={F,P,C,H};
trueTerm=1;
falseTerm=1;

for i=1:4
    x=params{i};
    if(cond(i)==1)
        trueTerm=trueTerm*x(1,1);
        falseTerm= falseTerm*x(2,1);
    elseif (cond(i)==0)
        trueTerm=trueTerm*x(1,2);
        falseTerm= falseTerm*x(2,2);
    end
end
trueTerm = trueTerm*Pnm(1);
falseTerm = falseTerm*Pnm(2);

prob=trueTerm/(trueTerm+falseTerm);
