function Label=setLabel(segImage)
imBW=im2bw(segImage);                          %
Label=bwlabel(imBW);                           %����һ����BW��С��ͬ��L���󣬰����˱����BW��ÿ����ͨ���������ǩ         
[H,W]=size(Label);                             % 
while 1                                        % 
    Label=fillAllZero(Label,H,W); %���bwLabel������õ���ͨͼ�е�0����
    if isempty(find(Label==0))==1;
        break;
    end
end