function edmundskarp(inp,biggestBlob)
inp = uint8(inp);
inp=imresize(inp,[256,256]);
if size(inp,3)>1
    inp=rgb2gray(inp);
end   
sout=imresize(inp,[256,256]);
t0=60;
th=t0+((max(inp(:))+min(inp(:)))./2);
for i=1:1:size(inp,1)
    for j=1:1:size(inp,2)
        if inp(i,j)>th
            sout(i,j)=1;
        else
            sout(i,j)=0;
        end
    end
end

sout=imresize(inp,[256,256]);
t0=60;
th=t0+((max(inp(:))+min(inp(:)))./2);
for i=1:1:size(inp,1)
    for j=1:1:size(inp,2)
        if inp(i,j)>th
            sout(i,j)=1;
        else
            sout(i,j)=0;
        end
    end
end

  ntot = numel(biggestBlob);
  nblack = length( biggestBlob(biggestBlob~=0) );
  nwhite=ntot-nblack;

if nwhite>200
    h = msgbox('Pest detected','error');
else 
    h = msgbox('No Pest detected');   
end

