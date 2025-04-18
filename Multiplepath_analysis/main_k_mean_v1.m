% by jinzhengtao
% time:2025.02.11
% 内容：k-mean聚类算法计算多径数量

clear
clc
close all

%% 步骤1：加载数据并预处理
load('D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_5.mat');
angle_samp = 0 : 179;
PAS = [angle_samp',PAS];

% 数据标准化（Z-score标准化）
[PAS_normalized, mu, sigma] = zscore(PAS); 

% 绘制原始特征分布 
figure;
scatter(PAS(:,1), PAS(:,2), 20, 'filled', 'MarkerFaceAlpha',0.8);
xlabel('Angle (degrees)');
ylabel('Power (dB)');
title('原始特征空间分布');
grid on;

% 标准化后特征分布 
figure;
scatter(PAS_normalized(:,1), PAS_normalized(:,2), 20, 'filled', 'MarkerFaceAlpha',0.8);
xlabel('Normalized Angle');
ylabel('Normalized Power');
title('标准化特征空间分布');
grid on;

% 计算特征方差贡献 
original_var = var(PAS);
normalized_var = var(PAS_normalized);
 
fprintf('原始数据方差：角度=%.2f, 功率=%.2f\n', original_var(1), original_var(2));
fprintf('标准化后方差：角度=%.2f, 功率=%.2f\n', normalized_var(1), normalized_var(2));

%% 步骤2：确定最佳簇数K（肘部法）
% 尝试不同的K值计算总误差平方和（SSE）
max_K = 8;  % 测试的最大K值
sse = zeros(max_K, 1);
for k = 1:max_K
    [~, ~, sumd] = kmeans(PAS_normalized, k, 'Replicates', 5, 'MaxIter', 200);
    sse(k) = sum(sumd);
end

% 绘制肘部曲线
figure;
plot(1:max_K, sse, 'bo-');
xlabel('簇数 K');
ylabel('总误差平方和 (SSE)');
title('肘部法确定最佳K值');
grid on;

%% 步骤3：设置最佳K值并执行K-means聚类
K = 3; % 根据肘部法或实际需求调整
opts = statset('UseParallel', 1, 'MaxIter', 1000, 'Display', 'final'); % 启用并行计算 
[cluster_idx, centroids] = kmeans(PAS_normalized, K, ...
    'Options', opts, ...
    'Replicates', 20, ...       % 多次初始化避免局部最优
    'Start', 'plus');          % 使用K-means++初始化

% 反标准化聚类中心 
C_original = bsxfun(@times, centroids, sigma) + mu;

%% 聚类可视化
% 创建颜色映射 
colors = lines(K);
 
figure;
hold on;
for i = 1:K 
    % 绘制各簇数据点 
    scatter(PAS(cluster_idx==i,1), PAS(cluster_idx==i,2), 50, colors(i,:), 'filled', 'MarkerEdgeColor','K');
    
    % 标注聚类中心 
    plot(C_original(i,1), C_original(i,2), 'pentagram', ...
        'MarkerSize', 15, 'MarkerFaceColor', colors(i,:), ...
        'MarkerEdgeColor','K', 'LineWidth', 1.5);
end 
 
% 设置图形属性 
xlabel('Angle (degrees)');
ylabel('Power (dB)');
title(sprintf('K-means聚类结果 (K=%d)', K));
legend('Cluster 1', 'Center 1', 'Cluster 2', 'Center 2');
% legend('Cluster 1', 'Center 1', 'Cluster 2', 'Center 2', 'Cluster 3', 'Center 3');
grid on;
box on;