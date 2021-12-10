function D=regionprocessing()
% tic;
global figHandle;                 % the handle of the interface
global orgImage;                  % the original image
global markerImage;               % the binary image with object and background marker
global Label;                     % 
global imgname;

Label2=Label;
hdl=get(figHandle,'userData');    % 
set(figHandle,'currentAxes',hdl.figHandle_Axes2);               % set hdl.figHandle_Axes2 as the current axes
mergeLabel=Label;                                               % the label of region merging
mergingTimes=1;                                                 % the number of the region merging

regionNum=max(Label(:));                                        % the number of the region
redbins=16;greenbins=16;bluebins=16;                            % the quantization of image
indImage=quanimage(orgImage,redbins,greenbins,bluebins);       

[height,width]=size(Label);                                  
Region=InitRegion(Label,indImage,markerImage,height,width);     % initilize the region. Region is a struct variable
SimTable=CompSim(Label,height,width,Region);                    % SimTable is a table which saves the similarity between the regions
BhaHogHist=CompHogHist(Label,indImage,height,width,Region);
MergeTable=-1*ones(1,regionNum);                                % initilize the MergeTable

k=0;                       % k is the times of region merging. the initial value is 0.
while 1
    k=k+1;              
    flag=0;                % 0��no region merging  1:region merging
    k1=0;                  % k1 is the times of region merging in the first stage
    while 1                % region merging in the first stage        
        k1=k1+1;           % 
        flag1=0;           % 0��no region merging  1:region merging
        for i=1:regionNum  %         
            % markerType   0 non-marker region  1 background  2 foreground
            % background marker regions merge with non-marker regions as
            % possible in the first stage
            if Region(i).markerType==1                         % region i is background
                % 
                for j=1:regionNum                              % 
                    if i~=j & SimTable(i,j)>0 & Region(j).markerType~=2     % region i and region j is adjacent and region i belongs to non-marker region
                        index=MaxSimIndex(j,SimTable,regionNum);               % ���������j����ڵ������
                        maxhog = MaxSimIndex(j,BhaHogHist,regionNum); 
                        if i==index 
                           %if i == maxhog || (i ~= maxhog && abs(BhaHogHist(j,i)-BhaHogHist(j,maxhog)) == 0) 
                                if i<j                          
                                    MergeTable=MergeRecord(MergeTable,i,j,regionNum);                                
                                    flag1=1;                                       % 
                                    flag=1;                                        % 
                                elseif i>j
                                    MergeTable=MergeRecord(MergeTable,j,i,regionNum);
                                    flag=1;                                        % 
                                    flag1=1;                                       % 
                                end
                           % end
                        end
                    end
                end
            end   
            if Region(i).markerType==2                         % region i is background
                for j=1:regionNum                              % 
                    if i~=j & SimTable(i,j)>0 & Region(j).markerType~=1    % region i and region j is adjacent and region i belongs to non-marker region
                        index=MaxSimIndex(j,SimTable,regionNum);               % ���������j����ڵ������
                        maxhog = MaxSimIndex(j,BhaHogHist,regionNum); 
                        if i==index 
                            %if i == maxhog || (i ~= maxhog && abs(BhaHogHist(j,i)-BhaHogHist(j,maxhog)) == 0) 
                                if i<j                          
                                    MergeTable=MergeRecord(MergeTable,i,j,regionNum);                                
                                    flag1=1;                                       % 
                                    flag=1;                                        % 
                                elseif i>j
                                    MergeTable=MergeRecord(MergeTable,j,i,regionNum);
                                    flag=1;                                        % 
                                    flag1=1;                                       % 
                                end
                           % end
                        end
                    end
                end
            end   
            
        end

        if flag1==0
            break;
        end
        [Label2,regionNum,Region]=MergePostProc2(Label2,MergeTable,regionNum,Region);
        SimTable=CompSim(Label2,height,width,Region);
        BhaHogHist=CompHogHist(Label2,indImage,height,width,Region);
        
        %��̬��ʾ�µķָ�����
        MergeTable=-1*ones(1,regionNum);
        ImageE=drawEdge(orgImage,Label2);
   
        set(hdl.segImage, 'XData',[1 width],'YData',[1 height],'Cdata',ImageE);drawnow;
        if k1==1
            str1='st ';
        elseif k1==2
            str1='nd ';
        elseif k1==3
            str1='rd ';
        else
            str1='th ';
        end
        
        if k==1
            str2='st round';
        elseif k==2
            str2='nd round';        
        end
        title(['the ',num2str(k1),str1,'merging in the first stage ','(the ',num2str(k),str2,')']);drawnow;
        pause(0.5);
    end
    % -------------------------- region merging of the first stage merges ends  --------------------------

    if flag==0  
        break;
    end
    
    % -------------------------- region merging of the second stage merge starts --------------------------
    flag2=1;
    k1=0;
    while 1   %   non-marker regions are merged each other in the second stage
        k1=k1+1; 
        flag2=0;

        for i=1:regionNum
            if Region(i).markerType==0      % for non-marker regions
                for j=1:regionNum
                    if i~=j & Region(j).markerType==0 & SimTable(i,j)>0
                        index=MaxSimIndex(j,SimTable,regionNum);
                        maxhog = MaxSimIndex(j,BhaHogHist,regionNum);
                        if i==index 
                            if i == maxhog 
                            if i<j
                                MergeTable=MergeRecord(MergeTable,i,j,regionNum);
                                flag=1;          
                                flag2=1;         
                            else
                                MergeTable=MergeRecord(MergeTable,j,i,regionNum);
                                flag=1;
                                flag2=1;
                            end
                            end
                        end
                    end
                end
            end
        end
        
        if flag2==0
            break;
        end
        
        %
        [Label2,regionNum,Region]=MergePostProc2(Label2,MergeTable,regionNum,Region);
        SimTable=CompSim(Label2,height,width,Region);
        BhaHogHist=CompHogHist(Label2,indImage,height,width,Region);
        MergeTable=-1*ones(1,regionNum);

        ImageE=drawEdge(orgImage,Label2);
        set(hdl.segImage, 'XData',[1 width],'YData',[1 height],'Cdata',ImageE);drawnow;
        if k1==1
            str1='st ';
        elseif k1==2
            str1='nd ';
        elseif k1==3
            str1='rd ';
        else
            str1='th ';
        end
        
        if k==1
            str2='st round';
        elseif k1==2
            str2='nd round';        
        end        
        title(['the ',num2str(k1),str1,'merging in the second stage ','(the ',num2str(k),str2,')']);drawnow;
        pause(0.5);
    end
    if flag==0
        break;
    end
end
title(['the result of histogram merge']);
save 'Region' Region;
save 'Label2' Label2;
% D=Label2;
% toc;
% disp(['his������ʱ��: ',num2str(toc)]);
tic;
%���໮�ֱ�����ǰ��������µ�Region
[Region,numComponents] = KMeans(1,2,Region);  %��������Ϊ[3,3+numComponents)��1��������2�����1+2=3��ʼ���
indexBack = numComponents;
[Region,numComponents] = KMeans(2,2+numComponents,Region); %ǰ������Ϊ3+numComponents~...
indexFront = numComponents;
%һ�����ɭ��
lentrain = 0;
for i = 1:length(Region)
    if Region(i).markerType ~= 0        
        lentrain = lentrain + 1;
    end
end
col = length(Region(1).rgbHistogram);
orient = 8;
lencol= col+orient;
train = zeros(lentrain,lencol);
group = zeros(lentrain,1);
j = 1;
for i = 1:length(Region)
    if Region(i).markerType ~= 0
        train(j,:) = [Region(i).rgbHistogram,Region(i).HistHog];
        group(j,:) = Region(i).markerType;
        j = j + 1;
    end
end

%ѵ������ģ��
ntree = 100;
Model = TreeBagger(ntree,train,group,'Method','classification');

%�������
len = length(Region);
lentest = len - lentrain;
test = zeros(lentest,lencol);
j = 1;
for i = 1:length(Region)
    if Region(i).markerType == 0
        test(j,:) = [Region(i).rgbHistogram,Region(i).HistHog];
        j = j + 1;
    end
end
[classification,scores] = predict(Model, test);
%�߼��ع�
save 'classification.mat' classification;
save 'scores.mat' scores;
%����ΪKMEANS�޸ĵı�ǩ�Ŵ�س�1��2
for i = 1:length(Region)
     treeNodePer = Region(i).markerType;
     if treeNodePer >= 3 && treeNodePer < 3+indexBack       %�����[3,3+indexBack)�ھ��Ǳ���         
        Region(i).markerType = 1;
    elseif treeNodePer >= 3+indexBack && treeNodePer < 3+indexBack+indexFront   %������ǰ��
        Region(i).markerType = 2;
     end
end
%��δ��ǵ��������±��
j =1;
for i = 1:length(Region)
    if Region(i).markerType == 0
%         SVM�������ɭ��
        charnum = classification(j);
        treeNodePer = str2num(charnum{1,1})-2;
        if scores(j,treeNodePer) > 0.7 
            if treeNodePer >= 1 && treeNodePer < 1+indexBack       %�����[3,3+indexBack)�ھ��Ǳ���         
                Region(i).markerType = 1;
            elseif treeNodePer >= 1+indexBack && treeNodePer < 1+indexBack+indexFront   %������ǰ��
                Region(i).markerType = 2;
            end
        end        
        j = j + 1;
    end
end
toc;
disp(['onerf������ʱ��: ',num2str(toc)]);
% 
%�ϲ����������������ɭ��Ԥ��

load Label2.mat Label2;
regionNum=max(Label2(:));
[height,width]=size(Label2);  
SimTable=zeros(regionNum,regionNum);  %�����ڽ��������
for i=1:height
    for j=1:width
        index=Label2(i,j);                 % 
        SimTable(index,index)=1;      % 
        for k=-1:1                    % 
            for l=-1:1                % 
                row=i+k;              % 
                col=j+l;
                if (row>0 & row<=height & col>0 & col<=width)
                    if index~=Label2(row,col)
                        SimTable(index,Label2(row,col))=1;
                    end
                end
            end
        end
    end
end
Region2 = Region;
[Label2,regionNum,Region]=Merge(Label2,regionNum,Region,SimTable);
ImageE=drawEdge(orgImage,Label2);
set(hdl.segImage, 'XData',[1 width],'YData',[1 height],'Cdata',ImageE);drawnow;
title(['the result of One RandomTree']);
save 'Region.mat' Region;

% ����δ��ǵ��������
lentrain = 0;
for i = 1:length(Region)
    if Region(i).markerType ~= 0        
        lentrain = lentrain + 1;
    end
end

tic;
%�ڽ�����ϲ�
col = length(Region(1).rgbHistogram);
orient = 8;
lencol= (col+orient) * 2;
train = zeros(1,lencol);
group = zeros(1,1);
% combRegion = zeros(1,2); 
j = 1;
for i = 1:length(Region)
    if Region(i).markerType ~= 0
        mark1 = Region(i).markerType;
        for k = 1:length(Region)
            if Region(k).markerType ~= 0 && i ~= k && SimTable(i,k) > 0
                train(j,:) = [Region(i).rgbHistogram,Region(i).HistHog,Region(k).rgbHistogram,Region(k).HistHog];
                mark2 = Region(k).markerType;
                mark1 = num2str(mark1);
                mark2 = num2str(mark2);
                mark = strcat(mark1,mark2);
                mark = str2num(mark);
                group(j,1) = mark;
%                 combRegion(j,1) = i;
%                 combRegion(j,2) = k;
                j = j + 1;
            elseif SimTable(i,k) == 0
                continue;
            end
        end
    end
end

% 
%���ɭ��
ntree = 100;
Model = TreeBagger(ntree,train,group,'Method','classification');
% svmStruct =svmtrain(train,group,'kernel_function','linear');
%�������
len = length(Region);
lentest = len - lentrain;
test = zeros(lentest,lencol);
combRegion = zeros(lentest,2);
j = 1;
for i = 1:length(Region)
    mark1 = Region(i).markerType;
    for k = 1:length(Region)
        if Region(k).markerType == 0 && i ~= k && SimTable(i,k) > 0
            combRegion(j,1) = i;
            combRegion(j,2) = k;
            test(j,:) = [Region(i).rgbHistogram,Region(i).HistHog,Region(k).rgbHistogram,Region(k).HistHog];
            j = j+1;
        end
    end
end

%���ɭ��Ԥ����
[classification,scores] = predict(Model, test);
% classification =svmclassify(svmStruct,test,'showplot',true);
testcomb = zeros(j-1,2);
%����Ԥ����11,12,21,22
for m = 1 : j-1
    charnum = classification(m);
    treeNodePer = str2num(charnum{1,1});
%     treeNodePer = charnum{1,1};
    testcomb(m,1) = fix(treeNodePer/10);  %�����ڿ�ֱ�����������11,12,21,22�ֿ�
    testcomb(m,2) = mod(treeNodePer ,10);
%     testcomb(m,1) = fix(treeNodePer/10) - 2;  %�����ڿ�ֱ�����������11,12,21,22�ֿ�
%     testcomb(m,2) = mod(treeNodePer ,10) - 2;
end

maxNum=max(combRegion(:));
regionAnalyse = zeros(maxNum,maxNum);
for m = 1:j-1
    regionUnknown = combRegion(m,2);
    %��Ԥ��ͬһ��Ľ���ŵ�һ��
    for n = 1:maxNum
        if regionAnalyse(regionUnknown,n) == 0     %�ҵ����һ���ڵ�
            break;
        end
    end
    treeNodePer = testcomb(m,2);
    regionAnalyse(regionUnknown,n) = treeNodePer;  
end

%����ͶƱ�����δ�������Ľ��
markUnknown = zeros(regionNum,1);
for i = 1:maxNum
    line = regionAnalyse(i,:);
    mark1 = 0;
    mark2 = 0;
    for j = 1:length(line)
        if line(1,j) == 1
            mark1= mark1+1;
        elseif line(1,j) == 2
            mark2 = mark2+1;
        else
            break;
        end
    end
    if mark1 >= mark2 && j ~= 1
        markUnknown(i,1) = 1;
    elseif j == 1
        markUnknown(i,1) = 0;   
    else
        markUnknown(i,1) = 2;
    end
end

%��ȡ���ս��
for i = 1:length(markUnknown)
    if markUnknown(i) ~= 0
        Region(i).markerType = markUnknown(i);
    end
end
toc;
disp(['tworf������ʱ��: ',num2str(toc)]);
save 'Region.mat' Region;

regionNum = length(Region);
D=0.*Label;
for i=1:regionNum
    if Region(i).markerType==2
        D(find(Label2==i))=1;
%     elseif Region(i).markerType==1
%         D(find(Label2==i))=1;      
    end
end
for i = 1:height
    for j = 1:width
        if D(i,j) ~= 1
           orgImage(i,j,:)=255;
    end
end
imwrite(orgImage,[imgname(1:end-4) '.tif']);
ImageE=drawEdge(orgImage,D);
set(hdl.segImage, 'XData',[1 width],'YData',[1 height],'Cdata',ImageE);drawnow;
title(['the result of region merging']);
% toc;
end