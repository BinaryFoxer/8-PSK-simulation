% 将格雷码反变换为二进制序列
% return: judge_gray -- 判决格雷码序列
%         receive_bin -- 最终输出二进制序列
function receive_bin = greyTobinary(judge_gray)
    % judge_gray是一个 N x 3 的矩阵，每行表示一个 3 位的格雷码
    % 初始化二进制矩阵
    receive_bin = zeros(size(judge_gray));
    
    % 反变换的第一个位，二进制的第一个位等于格雷码的第一个位
    receive_bin(:, 1) = judge_gray(:, 1);
    
    % 反变换后面的其他位，基于异或操作
%     从 2 开始，一直到 judge_gray 矩阵的列数（size(judge_gray, 2)）
    for i = 2:size(judge_gray, 2)
        receive_bin(:, i) = xor(judge_gray(:, i), receive_bin(:, i - 1));  % 对应位置的按位异或操作
    end

end