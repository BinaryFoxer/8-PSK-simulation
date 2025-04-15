% 根据最小欧式距离准则对接收信号进行判决
% param: M -- M进制PSK
%        rn -- 接收信号坐标
% return: judge -- 判决结果
function judge = minDistance(rn, M)
%   先产生8个映射点的位置坐标
    standard = zeros(2, M);%standard数组存储星座图的横纵坐标，这里不用编码
    m = 0:M-1;
    standard(1, :) = cos(2*pi*m/M);%横坐标
    standard(2, :) = sin(2*pi*m/M);%纵坐标
    
%   判决信号的长度
    len = length(rn(1, :));
    judge = zeros(1, len);%judge是判决出的码元在星座图上的索引，根据索引可以求出对应的格雷码
%   计算出到每个坐标点的最小欧式距离
%   遍历rn数组
    for i = 1 : len
         distance = zeros(1, M);
%       计算每个接收信号点到每个标准点的距离
        for j = 1 : M
            dx(j) = abs(rn(1, i) - standard(1, j));%横坐标距离
            dy(j) = abs(rn(2, i) - standard(2, j));%纵坐标距离
            distance(j) = dx(j)^2 + dy(j)^2;%求出距离的平方
        end
        min_distance = min(distance);%找到最近的距离
        judge(i) = find(distance == min_distance) - 1;%找到这个最小距离在distance数组中的索引j，这个j就是它判决的信号点的索引+1
    end
    
end