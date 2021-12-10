function Region=InitRegion(I,indImage,Mask,height,width)
%Label,indImage,markerImage,height,width
RegionNum=max(I(:));  
orient=8;               %方向直方图的方向个数
for i=1:RegionNum                
    Region(i).area=0;
    Region(i).markerType=0;      
    Region(i).rgbHistogram=zeros(1,max(indImage(:)));
    Region(i).HistHog = zeros(1,orient);
end

for i=1:height
    for j=1:width
        index=I(i,j); 
        %统计每块区域共有多少个像素点
        Region(index).area=Region(index).area+1;  
        %统计该区域每个位置的像素值，即颜色直方图
        Region(index).rgbHistogram(1,indImage(i,j))=Region(index).rgbHistogram(1,indImage(i,j))+1;        
        %统计该区域有没有被标记为背景或者前景
        Region(index).markerType=max(Region(index).markerType,Mask(i,j));   
    end
end

for r = 1:RegionNum
    ImgCloseRegion=CalImage(I,indImage,r,height,width);
    theta = zeros(height,width);
    hy = fspecial('sobel'); %表示采用Sobel算子 默认是垂直方向检测
    hx = hy'; %对算子进行转置
    Iy = imfilter(double(ImgCloseRegion), hy, 'replicate');%使用Sobel分别在垂直、水平方向上进行卷积
    Ix = imfilter(double(ImgCloseRegion), hx, 'replicate');
    gradmag = sqrt(Ix.^2 + Iy.^2);%对卷积结果合成 Ix.^2 表示求平方获得幅值
    for i = 1:height
        for j = 1:width
            theta(i,j) = mod(atan(Iy(i,j)/Ix(i,j))*180/pi,360); %全部变正，atan求得区间在[-90,90]之间
        end
    end
    jiao=360/orient;        %每个方向包含的角度数
    Hist=zeros(1,orient);               %统计角度直方图,就是cell
    for i = 1:orient
        curMin=(i-1)*jiao;
        curMax=i*jiao;
        theta(theta>=curMin & theta<curMax) = i; %角度值量化到区间[1,8]
    end
    for p = 1:height
        for q = 1:width
            if isnan(theta(p,q))==1
                theta(p,q) = 0;
            else
                Hist(theta(p,q)) = Hist(theta(p,q)) + gradmag(p,q);
            end
            
        end
    end
    if sum(sum(gradmag)) ~= 0
        Hist = single(Hist) / sum(sum(gradmag));
    end
    Region(r).HistHog = Hist;
end


