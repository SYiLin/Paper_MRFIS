function Region=InitRegion(I,indImage,Mask,height,width)
%Label,indImage,markerImage,height,width
RegionNum=max(I(:));  
orient=8;               %����ֱ��ͼ�ķ������
for i=1:RegionNum                
    Region(i).area=0;
    Region(i).markerType=0;      
    Region(i).rgbHistogram=zeros(1,max(indImage(:)));
    Region(i).HistHog = zeros(1,orient);
end

for i=1:height
    for j=1:width
        index=I(i,j); 
        %ͳ��ÿ�������ж��ٸ����ص�
        Region(index).area=Region(index).area+1;  
        %ͳ�Ƹ�����ÿ��λ�õ�����ֵ������ɫֱ��ͼ
        Region(index).rgbHistogram(1,indImage(i,j))=Region(index).rgbHistogram(1,indImage(i,j))+1;        
        %ͳ�Ƹ�������û�б����Ϊ��������ǰ��
        Region(index).markerType=max(Region(index).markerType,Mask(i,j));   
    end
end

for r = 1:RegionNum
    ImgCloseRegion=CalImage(I,indImage,r,height,width);
    theta = zeros(height,width);
    hy = fspecial('sobel'); %��ʾ����Sobel���� Ĭ���Ǵ�ֱ������
    hx = hy'; %�����ӽ���ת��
    Iy = imfilter(double(ImgCloseRegion), hy, 'replicate');%ʹ��Sobel�ֱ��ڴ�ֱ��ˮƽ�����Ͻ��о��
    Ix = imfilter(double(ImgCloseRegion), hx, 'replicate');
    gradmag = sqrt(Ix.^2 + Iy.^2);%�Ծ������ϳ� Ix.^2 ��ʾ��ƽ����÷�ֵ
    for i = 1:height
        for j = 1:width
            theta(i,j) = mod(atan(Iy(i,j)/Ix(i,j))*180/pi,360); %ȫ��������atan���������[-90,90]֮��
        end
    end
    jiao=360/orient;        %ÿ����������ĽǶ���
    Hist=zeros(1,orient);               %ͳ�ƽǶ�ֱ��ͼ,����cell
    for i = 1:orient
        curMin=(i-1)*jiao;
        curMax=i*jiao;
        theta(theta>=curMin & theta<curMax) = i; %�Ƕ�ֵ����������[1,8]
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


