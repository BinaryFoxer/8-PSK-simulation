% 输入参数
n = input('请输入发送信号点数:');
Eb_No_dB = -5:1:20;  % 设置Eb/N0的范围，从0到20 dB，步长为1
num_trials = 100;  % 每个信噪比Eb/N0值下的仿真次数
SER_values_8 = zeros(1, length(Eb_No_dB));  % 用来存储每个Eb/N0对应的误符号率
SER_values_4 = zeros(1, length(Eb_No_dB));  % 用来存储每个Eb/N0对应的误符号率
SER_theoretical_8 = zeros(1, length(Eb_No_dB));%存储理论误符号率
M = 8;
SER_theoretical_4 = zeros(1, length(Eb_No_dB));%存储4进制理论误符号率

for i = 1:length(Eb_No_dB)
%   计算理论误码率
    Eb_No = 10^(Eb_No_dB(i)/10);  % 将dB转为线性值
%   使用Q函数计算理论误符号率
    SER_theoretical_8(i) = 2 * qfunc(sin(pi/M)*sqrt(2 * Eb_No * log2(M)));  % 使用Q函数计算理论误符号率
%   计算4进制误符号率
    SER_theoretical_4(i) = 2 * qfunc(sqrt(2 * Eb_No))*(1-1/2*qfunc(sqrt(2 * Eb_No)));
end


 % 计算对应Eb/N0的噪声方差
Eb_No = 10.^(Eb_No_dB/10);  % 将dB转为线性值
noise_variance_8 = 1 ./ (6*10.^(Eb_No_dB./10));  % 信噪比Eb/N0与噪声方差的关系
noise_variance_4 = 1 ./ (4*10.^(Eb_No_dB./10));

% 在每个Eb/N0下计算误码率
parfor i = 1:length(Eb_No_dB)    
    % Monte Carlo仿真
    SER_trial_8 = 0;  % 记录当前Eb/N0下的误符号率
    SER_trial_4 = 0;
    for trial = 1:num_trials
        % 生成随机二进制序列 
         binary_sequence = generatingSendingSequence(n);
         greyCodeSequence = encodingToGrey(binary_sequence);
        [Sm, symbol] = greyCodeflect(greyCodeSequence);

        % 发送信号通过信道并加噪声
        rn = awgn1(Sm, noise_variance_8(i));

         % 判决接收符号
        judge = minDistance(rn, 8);
        judge_grey = dToGrey(judge);
        receive_bin = greyTobinary(judge_grey);
        receive_bin = reshape(receive_bin', 1, []);  % 转化为行向量

        % 计算误符号率
        [SER_trial_temp_8, ~] = errorRate(binary_sequence, symbol, receive_bin, judge);
        SER_trial_8 = SER_trial_8 + SER_trial_temp_8;
        
        %计算Q-PSK
        binary_sequence = generatingSendingSequence(n);
        greyCodeSequence = encodingToGrey_4(binary_sequence);
        [Sm_4, symbol] = greyCodeflect_4(greyCodeSequence);
        rn_4 = awgn1(Sm_4, noise_variance_4(i));
        judge = minDistance(rn_4, 4);
        judge_grey = dToGrey_4(judge);
        receive_bin = greyTobinary_4(judge_grey);
        receive_bin = reshape(receive_bin', 1, []);  % 转化为行向量
        % 计算误符号率
        [SER_trial_temp_4, ~] = errorRate(binary_sequence, symbol, receive_bin, judge);
        SER_trial_4 = SER_trial_4 + SER_trial_temp_4;
        
    end
    
    % 计算平均误符号率
    SER_values_4(i) = SER_trial_4 / num_trials;
    SER_values_8(i) = SER_trial_8 / num_trials;
    
    
    
end



figure;
semilogy(Eb_No_dB, SER_theoretical_8, 'x-', 'LineWidth', 2, 'MarkerSize', 6); % 8进制理论误符号率
hold on
semilogy(Eb_No_dB, SER_theoretical_4, 'o-', 'LineWidth', 2, 'MarkerSize', 6); % 4进制理论误符号率
hold on
semilogy(Eb_No_dB, SER_values_8, '*-', 'LineWidth', 2, 'MarkerSize', 6); % 8-PSK理论误符号率
hold on
semilogy(Eb_No_dB, SER_values_4, '--', 'LineWidth', 2, 'MarkerSize', 6); % 4-PSK理论误符号率

ylim([1e-6, 1]);  % 限制y轴在 1e-6 到 1 之间
xlabel('Eb/N0 (dB)');
ylabel('误符号率 (SER)');
title('QPSK与8PSK调制系统的Monte Carlo理论与仿真误符号率');
legend('8-PSK仿真误符号率','4-PSK仿真误符号率','8PSK理论误符号率','4PSK理论误符号率', 'Location', 'NorthEast');
grid on;



