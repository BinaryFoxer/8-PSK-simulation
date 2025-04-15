function gray_code = binaryToGray(binary_code)
    % 将3位二进制数转换为格雷码
    gray_code = [binary_code(1), xor(binary_code(1), binary_code(2)), xor(binary_code(2), binary_code(3))];
end