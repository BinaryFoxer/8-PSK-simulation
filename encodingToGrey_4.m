% 将输入的二进制bit按2位分类，转换为二位Grey码
function greyCodeSequence = encodingToGrey_4(binary_sequence)
    n = length(binary_sequence);
    
    % 确保输入的二进制序列的长度是偶数，如果不是，补充一个零
    if mod(n, 2) ~= 0
        binary_sequence = [binary_sequence, 0];
        n = n + 1;
    end
    
    greyCodeSequence = zeros(1, n);  % 存储最终的二位格雷码序列，大小与输入二进制序列一致

    % 将输入二进制序列按2位分组
    for i = 1:2:n
        % 取当前的2位或剩余的位
        binary_group = binary_sequence(i:i+1);
        
        % 将每个二位二进制组转为格雷码
        greyCodeSequence(i:i+1) = binaryToGrey(binary_group);
    end
end

% 将一个二进制数转为二位格雷码的函数
function grey_code = binaryToGrey(binary_group)
    % 格雷码的第一位与二进制数相同
    grey_code = binary_group(1);
    
    % 计算后续位的格雷码
    grey_code(2) = xor(binary_group(1), binary_group(2));
end
