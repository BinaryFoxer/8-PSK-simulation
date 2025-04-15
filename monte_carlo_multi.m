% 输入参数
n_values = [1000, 10000, 100000];  % 不同的发送信号点数
Eb_No_dB = 0:1:20;  % 设置Eb/N0的范围，从0到20 dB，步长为1
num_trials = 1000;  % 每个Eb/N0值下的仿真次数
SER_theoretical = zeros(1, length(Eb_No_dB));  % 用来存储理论误符号率

% 计算理论误符号率 (8PSK调制的理论公式)
for idx = 1:length(Eb_No_dB)
    Eb_No = 10^(Eb_No_dB(idx)/10);  % 将dB转为线性值
    SER_theoretical(idx) = (2 / 3) * qfunc(sqrt(2 * Eb_No));  % 使用Q函数计算理论误符号率
end

% 绘制图形
figure;
hold on;

% 对于不同的发送信号点数进行Monte Carlo仿真
for n_idx = 1:length(n_values)
    n = n_values(n_idx);  % 当前的发送信号点数
    SER_values = zeros(1, length(Eb_No_dB));  % 用来存储每个Eb/N0对应的误符号率

    % 在每个Eb/N0下计算误符号率
    for idx = 1:length(Eb_No_dB)
        Eb_No = 10^(Eb_No_dB(idx)/10);  % 将dB转为线性值
        noise_variance = 1 / (2 * Eb_No);  % 信噪比Eb/N0与噪声方差的关系

        % Monte Carlo仿真
        SER_trial = 0;  % 记录当前Eb/N0下的误符号率
        for trial = 1:num_trials
            % 生成随机二进制序列 
            binary_sequence = generatingSendingSequence(n);  % 自定义生成发送序列的函数
            greyCodeSequence = encodingToGrey(binary_sequence);  % 自定义灰码编码函数
            [Sm, symbol] = greyCodeflect(greyCodeSequence);  % 自定义调制函数
            SmComplex = Sm(1,:) + 1i * Sm(2,:);  % 8PSK调制符号

            % 发送信号通过信道并加噪声
            rn = awgn1(Sm, noise_variance);  % 自定义AWGN信道噪声函数
            rnComplex = rn(1,:) + 1i * rn(2,:);

            % 判决接收符号
            judge = minDistance(rn, 8);  % 自定义最小欧式距离判决
            judge_grey = dToGrey(judge);  % 自定义解码灰码
            receive_bin = greyTobinary(judge_grey);  % 自定义灰码转二进制
            receive_bin = reshape(receive_bin', 1, []);  % 转化为行向量

            % 计算误符号率
            [SER_trial_temp, ~] = errorRate(binary_sequence, symbol, receive_bin, judge);  % 自定义误符号率计算函数
            SER_trial = SER_trial + SER_trial_temp;
        end

        % 计算平均误符号率
        SER_values(idx) = SER_trial / num_trials;
    end
    
    % 绘制每个点数下的Monte Carlo仿真结果
    semilogy(Eb_No_dB, SER_values, 'o-', 'LineWidth', 2, 'MarkerSize', 6);
end

% 绘制理论误符号率
semilogy(Eb_No_dB, SER_theoretical, 'x--', 'LineWidth', 2, 'MarkerSize', 6);

% 添加图例和标签
xlabel('Eb/N0 (dB)');
ylabel('误符号率 (SER)');
title('8PSK调制系统的Monte Carlo仿真误符号率与理论误符号率');
legend('n = 1000', 'n = 10000', 'n = 100000', '理论误符号率');
grid on;
