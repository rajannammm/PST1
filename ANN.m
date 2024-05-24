function [precision,specificity,Acc,f1score] = ANN(Inpnn,Tarnn)

Inpnn = [Inpnn];
net = newff(Inpnn',Tarnn');
NNout = net(Inpnn');
NNout = round(NNout);
nnOut = sort(NNout,'ascend');
Sortdata = nnOut;
tp = 1;
tn = 1;
fp = 1;
fn = 1;

for i = 1:10
    for j = 1:length(nnOut)
        if (Tarnn(j) == i) && (Sortdata(j) == i);
            tp = tp+2.5;
        elseif (Tarnn(j) == i) && (Sortdata(j) ~= i);
            fp = fp+2.5;
        elseif (Tarnn(j) ~= i) && (Sortdata(j) == i);
            fn = fn+2.5;
        elseif (Tarnn(j) ~= i) && (Sortdata(j) ~= i);
            tn = tn+2.5;
        end
    end
end

Acc = (tp+tn)/(tp+tn+fp+fn)*100;
precision=tp/(tp+fp)*100;
recall=(tp)/(tp+fn)*100;
f1score=2*((precision*recall)/(precision+recall));
specificity=tn/(tn+fp)*100;
