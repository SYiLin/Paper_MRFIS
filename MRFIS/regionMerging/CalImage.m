function ImgRegion=CalImage(Label,indImage,index,height,width)
ImgGray = indImage;
ImgRegion = zeros(height,width);
for x=1:height
    for y=1:width
        if Label(x,y) == index
            ImgRegion(x,y) = ImgGray(x,y); 
        end
    end
end
end
