%����kmeans��ͼ��ı�����ǰ���ٴν��з���
%�����ж�����ʽ������ͬ���͵ı������ֳɲ�ͬ�ı�ǩ���������ѵ��
function [ReDefineRegion,numComponents] = KMeans(mark,numidx,Region)
%numidx��¼��һ�����ֻ��ֵ����һ�����֣��米�������꣬���ķ�����Ϊ3����ôǰ����Ҫ��4��ʼ��¼��
%mark == 1Ϊ�������ֻ��֣�mark==2��Ϊǰ�����ֻ���
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