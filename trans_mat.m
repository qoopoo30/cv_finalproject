function [ H ] = trans_mat( p1, p2 )
%PROJECTION_ 此处显示有关此函数的摘要
%   此处显示详细说明

A = zeros(3, 3);
for i = 0:3
    A(2*i+1,1:2) = p1(i+1,:);
    A(2*i+1,3) = 1;
    A(2*i+1,7:8) = -p2(i+1,1).*p1(i+1,:);
    A(2*i+1,9) = -p2(i+1,1);
    
    A(2*i+2,4:5) = p1(i+1,:);
    A(2*i+2,6) = 1;
    A(2*i+2,7:8) = -p2(i+1,2).*p1(i+1,:);
    A(2*i+2,9) = -p2(i+1,2);
end

%question 1
[eigvector, ~] = eig(A'*A);
H = [eigvector(1:3,1)'; eigvector(4:6,1)'; eigvector(7:9,1)'];

end

