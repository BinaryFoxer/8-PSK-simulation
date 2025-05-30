% 输入参数
n_values = [1000, 10000, 0];  % 不同的发送信号点数
Eb_No_dB = -5:1:20;  % 设置Eb/N0的范围，从0到20 dB，步长为1
num_trials = 100;  % 每个信噪比Eb/N0值下的仿真次数
SER_theoretical = zeros(1, length(Eb_No_dB));%存储理论误符号率
M = 8;

for i = 1:length(Eb_No_dB)
%   计算理论误码率
    Eb_No = 10^(Eb_No_dB(i)/10);  % 将dB转为线性值
%   使用Q函数计算理论误符号率
    SER_theoretical(i) = 2 * qfunc(sin(pi/M)*sqrt(2 * Eb_No * log2(M)));  % 使用Q函数计算理论误符号率
    
end
% 绘制误符号率曲线
figure;
semilogy(Eb_No_dB, SER_theoretical, 'x-', 'LineWidth', 2, 'MarkerSize', 6); % 理论误符号率
hold on;

for n_index = 1:length(n_values) 
    n = n_values(n_index);  % 当前的发送信号点数
    SER_values = zeros(1, length(Eb_No_dB));  % 用来存储每个Eb/N0对应的误符号率
    
    % 在每个Eb/N0下计算误码率
    for i = 1:length(Eb_No_dB)
        % 计算对应Eb/N0的噪声方差
        Eb_No = 10^(Eb_No_dB(i)/10);  % 将dB转为线性值
        noise_variance = 1 / (6*10^(Eb_No_dB(i)/10));  % 信噪比Eb/N0与噪声方差的关系

        % Monte Carlo仿真
        SER_trial = 0;  % 记录当前Eb/N0下的误符号率
        for trial = 1:num_trials
            % 生成随机二进制序列 
             binary_sequence = generatingSendingSequence(n);
             greyCodeSequence = encodingToGrey(binary_sequence);
            [Sm, symbol] = greyCodeflect(greyCodeSequence);
            SmComplex = Sm(1,:) + 1i * Sm(2,:);

            % 发送信号通过信道并加噪声
            rn = awgn1(Sm, noise_variance);
            rnComplex = rn(1,:) + 1i * rn(2,:);

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
     % 绘制每个点数下的Monte Carlo仿真结果
    semilogy(Eb_No_dB, SER_values, 'o-', 'LineWidth', 2, 'MarkerSize', 6);
    
end

% 添加图例和标签
xlabel('Eb/N0 (dB)');
ylabel('误符号率 (SER)');
title('8PSK调制系统的Monte Carlo仿真误符号率与理论误符号率');
legend('理论误符号率','n = 1000', 'n = 10000', 'n = 100000');
grid on;
