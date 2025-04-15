% 将判决好的星座图位置索引转换为对应的格雷码
function judge_grey = dToGrey_4(judge)
    judge_grey = zeros(length(judge), 2); % 格雷码是两位的，因此每个位置存储2个元素
    % 遍历 judge 数组中的每个值
    for i = 1:length(judge)
        % 依据 judge 数值转换为对应的格雷码
        switch judge(i)
            case 0
                judge_grey(i, :) = [0, 0]; % 格雷码为 00
            case 1
                judge_grey(i, :) = [0, 1]; % 格雷码为 01
            case 2
                judge_grey(i, :) = [1, 1]; % 格雷码为 11
            case 3
                judge_grey(i, :) = [1, 0]; % 格雷码为 10
            otherwise
                disp('error'); % 出错处理
        end
    end
end
