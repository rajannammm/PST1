function bBlob=seqmem(inp)
T = graythresh(inp);
   km = im2bw(inp,T);
   lImage = bwlabel(km);
   measurements = regionprops(lImage, 'Area');
   allAreas = [measurements.Area];
   [bArea, indexOfBiggest] = sort(allAreas, 'descend');
   bBlob = ismember(lImage, indexOfBiggest(1));
   bBlob = bBlob > 0;
   