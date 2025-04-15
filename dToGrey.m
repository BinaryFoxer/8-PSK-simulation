% 将判决好的星座图位置索引转换为对应的格雷码
% parameter: judge -- 判决符号
% return: judge_grey -- 判决格雷码
function judge_grey = dToGrey(judge)
    judge_grey = zeros(length(judge), 3); % 格雷码是三位的，因此每个位置存储3个元素
    % 遍历 judge 数组中的每个值
    for i = 1:length(judge)
        % 依据 judge 数值转换为对应的格雷码
        switch judge(i)
            case 0
                judge_grey(i, :) = [0, 0, 0];
            case 1
                judge_grey(i, :) = [0, 0, 1];
            case 2
                judge_grey(i, :) = [0, 1, 1];
            case 3
                judge_grey(i, :) = [0, 1, 0];
            case 4
                judge_grey(i, :) = [1, 1, 0];
            case 5
                judge_grey(i, :) = [1, 1, 1];
            case 6
                judge_grey(i, :) = [1, 0, 1];
            case 7
                judge_grey(i, :) = [1, 0, 0];
            otherwise
                    disp('error');
        end
    end
end