function [ result ] = inrect( pt, rect )
% if point in rect
% rect 4x2 matrix, lu,ru,ld,rd
result = 1;
tmp = cross([rect(1,:)-rect(3,:) 0],[rect(1,:)-pt 0]);
if(tmp(3)<0)
    result = 0;
    return
end
tmp = cross([rect(3,:)-rect(4,:) 0],[rect(3,:)-pt 0]);
if(tmp(3)<0)
    result = 0;
    return
end
tmp = cross([rect(4,:)-rect(2,:) 0],[rect(4,:)-pt 0]);
if(tmp(3)<0)
    result = 0;
    return
end
tmp = cross([rect(2,:)-rect(1,:) 0],[rect(2,:)-pt 0]);
if(tmp(3)<0)
    result = 0;
    return
end

end

