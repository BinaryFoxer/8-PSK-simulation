%在信道中加入方差可变的高斯白噪声
% parameter: un -- 信道输入信号
%            var -- 噪声方差
%   return: rn --  接收信号    
function rn = awgn1(un,var)
L = length(un(1,:));%求输入信号的长度

% randn(1,L) 生成一个长度为 L 的随机向量，元素来自标准正态分布（均值为 0，方差为 1）
% sqrt(var) 是噪声的标准差，将这个标准正态分布的噪声按给定的方差缩放，生成具有期望为 0、方差为 var 的噪声
% nc 和 ns 分别是为两个维度生成的噪声。
nc = randn(1,L)*sqrt(var);
ns = randn(1,L)*sqrt(var);
rn = un;
rn(1,:) = rn(1,:)+nc;
rn(2,:) = rn(2,:)+ns;

end