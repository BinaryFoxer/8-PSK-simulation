% 输入参数
n = input('请输入发送信号点数:');
noise_variance = 0.1;
% 生成随机二进制序列
binary_sequence = generatingSendingSequence(n);
disp('发送信号点数');
disp(length(binary_sequence));
disp('发送信号');
disp(binary_sequence);

%计算Q-PSK
greyCodeSequence = encodingToGrey_4(binary_sequence);
[Sm, symbol] = greyCodeflect_4(greyCodeSequence);
disp('格雷码');
disp(greyCodeSequence);
disp('发送符号');
disp(symbol);
SmComplex = Sm(1,:) + 1i*Sm(2,:);
disp(Sm);

% 根据发送信号的角度为每个点指定颜色
angles_send = angle(SmComplex);  % 计算发送信号点的相位
regions_send = mod(angles_send + pi - pi/8, 2*pi) / (pi/4);  % 按照每45°划分区域

% 为每个区域指定不同的颜色
colors = [
    1, 0, 0;  % 红色
    0, 0.5, 0;  % 绿色
    0, 0, 0.5;  % 蓝色
    0, 0.5, 1;  % 青色
    1, 0, 1;  % 品红
    1, 1, 0;  % 黄色
    0, 0, 0.1;  % 黑色
    0.5, 0.5, 0;  % 橄榄色
];

% 为每个发送点分配一个颜色
color_map_send = colors(mod(floor(regions_send), 8) + 1, :);

% 绘制发送信号的星座图并保存颜色信息
figure;
scatter(real(SmComplex), imag(SmComplex), [], color_map_send, 'filled');
title('发送信号的星座图');
xlabel('同相分量 (I)');
ylabel('正交分量 (Q)');
grid on;


rn = awgn1(Sm, noise_variance);
disp(rn);

judge = minDistance(rn, 4);

disp('判决接收符号');
disp(judge);
judge_grey = dToGrey_4(judge);
disp('判决格雷码');
disp(judge_grey);

receive_bin = greyTobinary(judge_grey);
disp('判决二进制');
disp(receive_bin);
receive_bin = reshape(receive_bin', 1, []);  % 转化为行向量

[SER, BER] = errorRate(binary_sequence, symbol, receive_bin, judge);

disp('误比特率：');
disp(BER);
disp('误码率：');
disp(SER);
