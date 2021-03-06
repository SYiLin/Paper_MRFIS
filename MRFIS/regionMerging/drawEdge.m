function ImageE=drawEdge(RGB_I,L)

[H,W]=size(L);

DirX=[1,1,0,-1,-1,-1, 0, 1];
DirY=[0,1,1, 1, 0,-1,-1,-1];

ImageE=RGB_I;

for i=1:H
    for j=1:W
        for k=1:8
            y=i+DirY(k);
            x=j+DirX(k);
            if x>=1 & x<=W & y>1 & y<=H
                if L(i,j)<L(y,x)        
                    ImageE(i,j,1)=255;
                    ImageE(i,j,2)=255;
                    ImageE(i,j,3)=255;
                end
            end
        end
    end
end