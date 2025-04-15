clear;
% 输入参数
n = input('请输入发送信号点数:');
Eb_No_dB = -5:1:15;  % 设置Eb/N0的范围，从-5到15 dB，步长为1
num_trials = 100;  % 每个信噪比Eb/N0值下的仿真次数
SER_values = zeros(1, length(Eb_No_dB));  % 用来存储每个Eb/N0对应的误符号率
M = 8;
SER_theoretical_8 = zeros(1, length(Eb_No_dB));%存储8进制理论误符号率

parfor i = 1:length(Eb_No_dB)
%   计算理论误码率
    Eb_No = 10^(Eb_No_dB(i)/10);  % 将dB转为线性值
%   使用Q函数计算理论误符号率（8进制）
    SER_theoretical_8(i) = 2 * qfunc(sin(pi/M)*sqrt(2 * Eb_No * log2(M)));  % 使用Q函数计算理论误符号率
    
end

 % 计算对应Eb/N0的噪声方差
Eb_No = 10.^(Eb_No_dB/10);  % 将dB转为线性值
noise_variance = 1 ./ (6*10.^(Eb_No_dB./10));  % 信噪比Eb/N0与噪声方差的关系

% 在每个Eb/N0下计算误码率
parfor i = 1:length(Eb_No_dB)    
    % Monte Carlo仿真
    SER_trial = 0;  % 记录当前Eb/N0下的误符号率
    for trial = 1:num_trials
        % 生成随机二进制序列 
         binary_sequence = generatingSendingSequence(n);
         greyCodeSequence = encodingToGrey(binary_sequence);
        [Sm, symbol] = greyCodeflect(greyCodeSequence);
%         SmComplex = Sm(1,:) + 1i * Sm(2,:);

        % 发送信号通过信道并加噪声
        rn = awgn1(Sm, noise_variance(i));
%         rnComplex = rn(1,:) + 1i * rn(2,:);

         % 判决接收符号
        judge = minDistance(rn, 8);
        judge_grey = dToGrey(judge);
        receive_bin = greyTobinary(judge_grey);
        receive_bin = reshape(receive_bin', 1, []);  % 转化为行向量

        % 计算误符号率
        [SER_trial_temp, ~] = errorRate(binary_sequence, symbol, receive_bin, judge);
        SER_trial = SER_trial + SER_trial_temp;
    end
    
    % 计算平均误符号率
    SER_values(i) = SER_trial / num_trials;
end

figure;
% 绘制误符号率（SER）与Eb/N0的关系曲线
semilogy(Eb_No_dB, SER_theoretical_8, 'x-', 'LineWidth', 2, 'MarkerSize', 6); % 理论误符号率
ylim([1e-6, 1]);  % 限制y轴在 1e-6 到 1 之间
hold on
semilogy(Eb_No_dB, SER_values, 'o-', 'LineWidth', 2, 'MarkerSize', 6);%仿真误符号率
ylim([1e-6, 1]);  % 限制y轴在 1e-6 到 1 之间

xlabel('Eb/N0 (dB)');
ylabel('误符号率 (SER)');
title(sprintf('8PSK调制系统的Monte Carlo理论和仿真误符号率 (发送信号点数: %d)', n));
legend('理论误符号率','仿真误符号率', 'Location', 'NorthEast');
grid on;
