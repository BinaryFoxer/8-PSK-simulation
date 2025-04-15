% param: M -- M进制PSK
%        rn -- 接收信号坐标
% return: judge -- 判决结果
function judge = minDistance_4(rn, M)
    % 如果是Q-PSK，M的值应该为4
    if M ~= 4
        error('此函数仅支持Q-PSK（M=4）');
    end
    
    % Q-PSK星座图的标准点 (单位圆上的四个点)
    standard = zeros(2, M); % standard数组存储星座图的横纵坐标
    standard(1, :) = [1, 0, -1, 0]; % Q-PSK横坐标
    standard(2, :) = [0, 1, 0, -1]; % Q-PSK纵坐标
    
    % 判决信号的长度
    len = size(rn, 2); % 计算接收信号的个数
    judge = zeros(1, len); % judge数组存储判决出的星座图索引
    
    % 计算接收信号到每个标准点的最小欧氏距离
    for i = 1 : len
        distance = zeros(1, M); % 存储到各个标准点的距离
        for j = 1 : M
            dx = rn(1, i) - standard(1, j); % 横坐标差值
            dy = rn(2, i) - standard(2, j); % 纵坐标差值
            distance(j) = dx^2 + dy^2; % 计算欧氏距离的平方
        end
        
        % 找到最小距离对应的索引
        min_distance = min(distance);%找到最近的距离
        judge(i) = find(distance == min_distance);%找到这个最小距离在distance数组中的索引j，这个j就是它判决的信号点的索引+1
        if judge(i) == 4
            judge(i) = 0;
        end
        
    end
    
end
