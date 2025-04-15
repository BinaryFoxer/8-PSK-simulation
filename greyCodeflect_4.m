function [Sm, symbol] = greyCodeflect_4(greyCodeSequence)
    % 初始化Sm：2行，列数为格雷码序列长度的一半
    Sm = zeros(2, length(greyCodeSequence)/2);  
    % 初始化符号数组
    symbol = zeros(1, length(greyCodeSequence)/2);
    
    % 将每两位bit组合成一个码元
    for i = 1 : 2 : length(greyCodeSequence)
        % 获取当前2位格雷码
        greyGroup = greyCodeSequence(i:i+1);
        
        % 将格雷码转换为符号索引
        symbolIndex = greyToSymbol(greyGroup);
        symbol((i+1)/2) = symbolIndex;
        
        % 对应相位
        phase = 2*pi*symbolIndex / 4;  % Q-PSK的相位为 0, π/2, π, 3π/2
        
        % 使用公式将格雷码映射到正交基函数上
        Sm(1, (i+1)/2) = cos(phase);  % 余弦值
        Sm(2, (i+1)/2) = sin(phase);  % 正弦值
    end
end

function symbolIndex = greyToSymbol(greyGroup)
    % 将2位格雷码转为对应的符号索引
    % 格雷码与对应的二进制值的映射关系如下（用二进制表示）：
    % 00 -> 0, 01 -> 1, 11 -> 2, 10 -> 3
    
    % 这里使用直接的映射关系
    greyMap = [0, 1, 3, 2];  % 格雷码到符号的映射
    % 将格雷码转换为数值，然后获取其对应的符号索引
    symbolIndex = greyMap(bi2de(greyGroup, 'left-msb') + 1);
end
