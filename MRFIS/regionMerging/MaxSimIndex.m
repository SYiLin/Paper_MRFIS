function maxIndex=MaxSimIndex(index,SimTable,regionNum)
%找出最大的巴氏距离的区域，并记录区域号
maxSim=-1;
for i=1:regionNum
    if i~=index                 % 
        sim=SimTable(i,index);  % 
        if maxSim<sim           % 
            maxSim=sim;         % 
            maxIndex=i;
        end
    end
end