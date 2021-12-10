%利用kmeans对图像的背景和前景再次进行分类
%背景有多种形式，将不同类型的背景划分成不同的标签，方便后期训练
function [ReDefineRegion,numComponents] = KMeans(mark,numidx,Region)
%numidx记录上一个部分划分的最后一个数字（如背景划分完，最大的分类数为3，那么前景就要从4开始记录）
%mark == 1为背景部分划分；mark==2则为前景部分划分
lentrain = 0;
for i = 1:length(Region)
    if Region(i).markerType == mark        
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
    if Region(i).markerType ==mark
        train(j,:) = [Region(i).rgbHistogram,Region(i).HistHog];
        j = j + 1;
    end
end

maxSilh = 0;
numComponents = 1;
for k = 2:6
    if j - 1 > k
        [idx,cmeans,sumd,D3] = kmeans(train,k,'dist','sqEuclidean');
        silh3 = mean(silhouette(train,idx,'sqeuclidean'));
    %     silh3 = mean(silh3);
        if silh3 > maxSilh
            numComponents = k;
            maxSilh = silh3;
        end
    end
end
[idx,cmeans,sumd,D3] = kmeans(train,numComponents,'dist','sqEuclidean');
save 'numComponents.mat' numComponents;

ReDefineRegion = Region;
idxlen= 1;
for i = 1:length(Region)
    if Region(i).markerType ==mark
        ReDefineRegion(i).markerType = numidx + idx(idxlen);       
        idxlen = idxlen+1;       
    end
end
save 'ReDefineRegion.mat' ReDefineRegion;
end