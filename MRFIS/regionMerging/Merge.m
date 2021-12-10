function [L,newRegionNum,Region2]=Merge(Label,regionNum,Region,SimTable)
MergeTable=-1*ones(1,regionNum);                                % initilize the MergeTable
L=zeros(size(Label,1),size(Label,2));    % 
k=0;
for i = 1:regionNum
    mark1 = Region(i).markerType;
    for j = 1:regionNum
        mark2 = Region(j).markerType;
        if SimTable(i,j)>0 && i~= j && mark1~=0 && mark2~=0 && mark1==mark2
            if i<j                          
            MergeTable=MergeRecord(MergeTable,i,j,regionNum);                                
            elseif i>j
            MergeTable=MergeRecord(MergeTable,j,i,regionNum);
            end   
        end
    end
end
[L,newRegionNum,Region2]=MergePostProc2(Label,MergeTable,regionNum,Region);
end


