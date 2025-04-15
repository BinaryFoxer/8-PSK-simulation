% 信源产生发送二进制序列
n = input('请输入发送信号点数:');
binary_sequence = generatingSendingSequence(n);
disp('发送信号点数');
disp(length(binary_sequence));

% 将发送的二进制信号映射为8个信号点，进行格雷编码
% 将二进制信号编码为格雷码,映射在正交基函数上
greyCodeSequence = encodingToGrey(binary_sequence);
[Sm,symbol] = greyCodeflect(greyCodeSequence);
SmComplex = Sm(1,:) + 1i*Sm(2,:);

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


% 让信号经过信道，加入高斯白噪声
var = input('输入噪声方差:');
rn = awgn1(Sm,var);
rnComplex = rn(1,:) + 1i*rn(2,:);

% 绘制接收信号的星座图，使用不同颜色，每个信号点还是使用它原来发送时的颜色
figure;
scatter(real(rnComplex), imag(rnComplex), [], color_map_send, 'filled');
title('加噪声后的8-PSK星座图');
xlabel('同相分量 (I)');
ylabel('正交分量 (Q)');
grid on;


% 根据最小欧式距离准则对接收信号进行判决
judge = minDistance(rn, 8);
judge_grey = dToGrey(judge);
% 把格雷码反变换为二进制序列
receive_bin = greyTobinary(judge_grey);
% 将向量维度变为一维
receive_bin = reshape(receive_bin', 1, []);  % 1 表示行向量，[] 自动计算列数

% 计算误比特率和误码率
[SER, BER] = errorRate(binary_sequence, symbol, receive_bin, judge);
disp('误比特率：');
disp(BER);
disp('误码率：');
disp(SER);


