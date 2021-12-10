function I2=fillAllZero(I,height,width)
%

dirX=[1,1,0,-1,-1,-1, 0, 1];
dirY=[0,1,1, 1, 0,-1,-1,-1];


I2=I;
for i=1:width                % 
    for j=1:height
%         Flag=0;
        if I(j,i)==0         % 
            for k=1:8
                curX=i+dirX(k);
                curY=j+dirY(k);
                if curX>=1 & curX<=width & curY>=1 & curY<=height
                    if I(curY,curX)~=0     % 
                        I2(j,i)=I(curY,curX);  %按照8领域查找到不为0的数字填充到0的数字中
%                         flag=1;
                        break;
                    end
                end
            end
        end
    end
end