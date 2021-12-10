function [PointSetNeighbor,lengthset]=AdjSet(I,height,width)
% 获取每个区域的邻近区域
RegionNum=max(I(:));                  % 
for i=1:RegionNum                
    PointSet(i).index1=0;
    PointSet(i).index2=0;      
    PointSet(i).adjacent=[];
end

setCount = 1;
for i=1:height
    for j=1:width
        index=I(i,j);                 %取出区域标签
        for k=-1:1                    %遍历3×3领域内，查找边缘区域
            for l=-1:1                % 
                row=i+k;              % 
                col=j+l;
                if (row>0 & row<=height & col>0 & col<=width)
                    if index~=I(row,col)   %若领域内有区域标签与当前标签不一致，代表边缘区域                   
                        if setCount ~= 1 
                            PointSet(setCount).index1 = index;
                            PointSet(setCount).index2 = I(row,col);
                            PointSet(setCount).adjacent(1,1) = i;
                            PointSet(setCount).adjacent(1,2) = j;      
                            setCount = setCount + 1;
                        elseif setCount == 1
                            PointSet(setCount).index1 = index;
                            PointSet(setCount).index2 = I(row,col);
                            PointSet(setCount).adjacent(1,1) = i;
                            PointSet(setCount).adjacent(1,2) = j;      
                            setCount = setCount + 1;
                        end
                    end
                end
            end
        end
    end
end

%整理遍历出来的边缘区域
PointSetNeighbor= struct('index1',0,'index2',0,'adjacent',[]);
lengthset = 0;
for i = 1:setCount-1
    a = PointSet(i).index1;
    b = PointSet(i).index2;
    flag = 0;
    for j = 1:lengthset
        if a==PointSetNeighbor(j).index1&& b==PointSetNeighbor(j).index2  %归纳属于同一个相邻区域区域的边界点
            flag = 1;
            l = size(PointSetNeighbor(j).adjacent,1)+1;               
            PointSetNeighbor(j).adjacent(l,1) = PointSet(i).adjacent(1,1);
            PointSetNeighbor(j).adjacent(l,2) = PointSet(i).adjacent(1,2);           
        end
    end
    if flag == 0    
       lengthset = lengthset+1;
	   PointSetNeighbor(lengthset).index1 = PointSet(i).index1;
	   PointSetNeighbor(lengthset).index2 = PointSet(i).index2;
       PointSetNeighbor(lengthset).adjacent(1,1) = PointSet(i).adjacent(1,1);
       PointSetNeighbor(lengthset).adjacent(1,2) = PointSet(i).adjacent(1,2);      
    end
end