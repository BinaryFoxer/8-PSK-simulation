% 将输入的二进制bit按3位分类，转换为Grey码
% parameter: binary_sequence -- 发送二进制序列
% return: greyCodeSequence -- 发送格雷码序列
function greyCodeSequence = encodingToGrey(binary_sequence)
    n = length(binary_sequence);
    greyCodeSequence = zeros(1, n);  % 存储最终的格雷码序列，大小与输入二进制序列一致

    % 将输入二进制序列按3位分组
    for i = 1:3:n
        % 确保不会超出原序列的长度，取出当前3位或剩余的位
        binary_group = binary_sequence(i:min(i+2, n));
        
        % 如果当前分组不足3位，补齐0
        if length(binary_group) < 3
            %binary_group只做中间存储
            binary_group = [binary_group, zeros(1, 3-length(binary_group))];
        end
        
        % 将每个三位二进制组转为格雷码
        greyCodeSequence(i:i+2) = binaryToGrey(binary_group);
        
    end
end

% 将一个二进制数转为格雷码的函数
function grey_code = binaryToGrey(binary_group)
    % 格雷码的第一位与二进制数相同
    grey_code = binary_group(1);
    
    % 计算后续位的格雷码
    for i = 2:length(binary_group)
        grey_code(i) = xor(binary_group(i-1), binary_group(i));
    end
end