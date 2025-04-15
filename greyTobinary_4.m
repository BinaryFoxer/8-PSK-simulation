function receive_bin = greyTobinary_4(judge_gray)
    % judge_gray是一个 N x 2 的矩阵，每行表示一个 2 位的格雷码
    % 初始化二进制矩阵
    receive_bin = zeros(size(judge_gray));
    
    % 反变换的第一个位，二进制的第一个位等于格雷码的第一个位
    receive_bin(:, 1) = judge_gray(:, 1);
    
    % 反变换的第二个位，基于异或操作
    receive_bin(:, 2) = xor(judge_gray(:, 2), receive_bin(:, 1));  % 对应位置的按位异或操作
end
