% parameter: N -- 二进制序列的点数
% return: binary_sequence -- 发送二进制序列
function binary_sequence = generatingSendingSequence(N)
% 使用randi函数生成二进制序列，服从均匀分布，0,1出现概率相等
binary_sequence = randi([0, 1], 1 ,N);

end