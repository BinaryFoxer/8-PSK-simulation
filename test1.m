% 输入参数
n = input('请输入发送信号点数:');
Eb_No_dB = -5:1:20;  % 设置Eb/N0的范围，从0到20 dB，步长为1
num_trials = 100;  % 每个信噪比Eb/N0值下的仿真次数
SER_values = zeros(1, length(Eb_No_dB));  % 用来存储每个Eb/N0对应的误符号率
SER_theoretical = zeros(1, length(Eb_No_dB));%存储理论误符号率
M = 8;

% 在每个Eb/N0下计算误码率
for i = 1:length(Eb_No_dB)
%   计算理论误码率
    Eb_No = 10^(Eb_No_dB(i)/10);  % 将dB转为线性值
%   使用Q函数计算理论误符号率
    SER_theoretical(i) = 2 * qfunc(sin(pi/M)*sqrt(2 * Eb_No * log2(M)));  % 使用Q函数计算理论误符号率
end

figure;
semilogy(Eb_No_dB, SER_theoretical, 'x-', 'LineWidth', 2, 'MarkerSize', 6); % 理论误符号率
% 设置y轴的范围
ylim([1e-6, 1]);  % 限制y轴在 1e-6 到 1 之间
xlabel('Eb/N0 (dB)');
ylabel('误符号率 (SER)');
title('8PSK调制系统的Monte Carlo理论和仿真误符号率');
legend('仿真误符号率', '理论误符号率', 'Location', 'SouthWest');
grid on;