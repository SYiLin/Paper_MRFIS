function Label=setLabel(segImage)
imBW=im2bw(segImage);                          %
Label=bwlabel(imBW);                           %返回一个和BW大小相同的L矩阵，包含了标记了BW中每个连通区域的类别标签         
[H,W]=size(Label);                             % 
while 1                                        % 
    Label=fillAllZero(Label,H,W); %填充bwLabel函数获得的连通图中的0区域
    if isempty(find(Label==0))==1;
        break;
    end
end