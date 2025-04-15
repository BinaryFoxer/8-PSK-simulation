% 生成一个二进制序列，长度为n
n = 100;
binary_sequence = randi([0, 1], 1, n);  % 生成二进制序列
disp('Binary Sequence:');
disp(binary_sequence);

% 将二进制序列按3位分组，转换为格雷码
gray_code_sequence = [];
for i = 1:3:n
    % 提取每3个二进制位
    binary_group = binary_sequence(i:min(i+2, n));  % 取3位
    if length(binary_group) < 3
        binary_group = [binary_group, zeros(1, 3 - length(binary_group))];  % 补齐为3位
    end
    
    % 转换为格雷码
    gray_code = binaryToGray(binary_group);
    gray_code_sequence = [gray_code_sequence, gray_code];
end

disp('Gray Code Sequence:');
disp(gray_code_sequence);

% 映射格雷码到8PSK信号点
phase_map = [0, 45, 90, 135, 180, 225, 270, 315];  % 8PSK相位
psk_signal = [];

for i = 1:3:length(gray_code_sequence)
    % 获取当前的3位格雷码
    gray_code_value = gray_code_sequence(i:i+2);
    % 将格雷码转换为对应的整数索引
    gray_code_decimal = bi2de(gray_code_value, 'left-msb');
    % 获取相应的相位
    phase = phase_map(gray_code_decimal + 1);
    
    % 映射到复平面上的8PSK信号点 (幅度设为1)
    psk_signal = [psk_signal, exp(1i * deg2rad(phase))];
end

% 显示PSK信号点
disp('8PSK Signal Points:');
disp(psk_signal);



% 可视化8PSK信号点
figure;
scatter(real(psk_signal), imag(psk_signal), 'filled');
title('8PSK Signal Points');
xlabel('Real');
ylabel('Imaginary');
grid on;
axis equal;
