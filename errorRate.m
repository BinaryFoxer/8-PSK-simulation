% 计算误比特率和误码率
% param: binary_sequence -- 输入二进制序列
%        symbolIndex  -- 发送码元
%        receive_bin  -- 接收二进制序列
%        judge  -- 接收码元
% return: SER -- 误码率
%         BER -- 误比特率
function [SER, BER] = errorRate(binary_sequence, symbol, receive_bin, judge)
    % 将矩阵 receive_bin 转换为一维行向量
%     receive_bin = reshape(receive_bin', 1, []);  % 1 表示行向量，[] 自动计算列数
    len_b = length(binary_sequence);
    bitErrors = 0;% 计数错误比特
    for i = 1 : len_b
        if receive_bin(i) ~= binary_sequence(i)
            bitErrors = bitErrors + 1;
        end
    end
%   计算误比特率
    BER = bitErrors / len_b;
    
%   计算误码率直接比较格雷码对应的符号即可
    len_s = length(symbol);
    symbolErrors = 0;
    for j = 1 : len_s
        if judge(j) ~= symbol(j)
            symbolErrors = symbolErrors + 1;
        end
    end
%   计算误码率
    SER = symbolErrors / len_s;
    
end