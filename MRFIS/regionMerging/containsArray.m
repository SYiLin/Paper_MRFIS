%�ж�1*2����b�Ƿ����������a��
function isContain =containsArray(b,a)
isContain = 0;
m = size(a,1);
if m == 0
    isContain = 1;
else
    for i = 1:m
        if b(1,1) == a(i,1) && b(1,2) == a(i,2)
            isContain = 1;
        end
    end
end
end