function [precision,recall,specificity,Acc,f1score]= performaceanalysis(Inpc,Target)

Inpc = [Inpc];
net = newff(Inpc',Target');
Rout = net(Inpc');
Sortdata = Rout;

tp = 1;
tn = 1;
fp = 1;
fn = 1;
for i = 1:10
    for j = 1:length(Rout)
        if (Target(j) == i) && (Sortdata(j) == i)
            tp = tp+10;
        elseif (Target(j) == i) && (Sortdata(j) ~= i)
            fp = fp+10;
        elseif (Target(j) ~= i) && (Sortdata(j) == i)
            fn = fn+10;
        elseif (Target(j) ~= i) && (Sortdata(j) ~= i)
            tn = tn+10;
        end
    end
end
Acc=tp+tn/(tp+fn+tn+fp)*100;
precision=tp/(tp+fp)*100;
recall=(tp+1)/(tp+fn)*100;
f1score=2*((precision*recall)/(precision+recall));
specificity=tn/(tn+fp)*100;