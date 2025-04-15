% parameter: greyCodeSequence -- 发送格雷码序列
% return: Sm -- 发送正交信号
%         symbol -- 发送符号
function [Sm,symbol] = greyCodeflect(greyCodeSequence)
    % 初始化Sm：2行，列数为格雷码序列长度的1/3
    Sm = zeros(2, length(greyCodeSequence)/3);
%   初始化符号数组
    symbol = zeros(1, length(greyCodeSequence)/3);
    
    % 将每三位bit组合成一个码元
    for i = 1 : 3 : length(greyCodeSequence)
        % 获取当前3位格雷码
        greyGroup = greyCodeSequence(i:i+2);
        
        % 将格雷码转换为数值（0~7）
        symbolIndex = greyToSymbol(greyGroup);
        symbol((i+2)/3) = symbolIndex;
        
        % 对应相位
        phase = 2*pi*symbolIndex / 8;
        
        % 使用公式将格雷码映射到正交基函数上
        Sm(1, (i+2)/3) = cos(phase); % 将余弦值填入
        Sm(2, (i+2)/3) = sin(phase); % 将正弦值填入
    end
end

function symbolIndex = greyToSymbol(greyGroup)
    % 将格雷码转为对应的符号索引，格雷码的转换需要根据格雷码的规则
    % 格雷码与对应的二进制值的映射关系如下（用二进制表示）：
    % 000 -> 0, 001 -> 1, 011 -> 2, 010 -> 3, 110 -> 4, 111 -> 5, 101 -> 6, 100 -> 7
    
    % 这里使用直接的映射关系
    greyMap = [0, 1, 3, 2, 7, 6, 4, 5]; % 格雷码到符号的映射
    % 将格雷码转换为数值，然后获取其对应的符号索引
    symbolIndex = greyMap(bi2de(greyGroup, 'left-msb') + 1);
    
end


