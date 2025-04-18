% by jinzhengtao
% time:2025.03.16
% 内容：近场球面波信道仿真

clc;clear
% close all

% 参数设置
c = 3e8;
fc = 6.5e9; % 中心载波
delta_f = 3e3; % 子载波间隔
d = c/fc*0.5; % 天线间隔
NumSubcarriers = 273*12; % 有效带宽100MHz,对应273个RB 
NumPath = 1; % 多径数量
NumAntenna = 64; % 阵列天线通道数量
% 多径参数设置
% % d = 3.2
theta = [96, 34, 140];
r = [3.2, 5, 5.4];
g = [0.4 0.24 0.25];
% d = 5.2
% theta = [94, 34, 140];
% r = [5.2, 4.58, 5.4];
% g = [1 0.24 0.25];
% d = 7.2
% theta = [93, 42, 140];
% r = [7.2, 5.1, 6.8];
% g = [1 0.48 0.26];
% Tx4
% theta = [74, 42, 140];
% r = [5.4, 5.1, 6.8];
% g = [1 0.48 0.26];
% Tx4
% theta = [112, 31, 140];
% r = [5.4, 4.4, 6.8];
% g = [1 0.22 0.26];


% 近场导向矢量生成
b = zeros(NumAntenna,NumPath); % 导向矢量
n = (0:NumAntenna-1)';
delta_n = (2*n-NumAntenna+1)/2; 
k_c = 2*pi*fc/c;
for iPath = 1:NumPath
    r_n = sqrt(r(iPath)^2+(delta_n.^2)*d^2-2*r(iPath)*sin((theta(iPath)-90)*pi/180)*d*delta_n);
    b(:,iPath) = exp(-1i*k_c*(r_n-r(iPath)));
end
% 近场信道模型
m = (0:NumSubcarriers-1)-NumSubcarriers/2+1;
% k_m = 2*pi*(fc+m*delta_f)/c;
k_m = 2*pi*fc/c;
H = zeros(NumSubcarriers, NumAntenna);% 信道矩阵
for iSub = 1:NumSubcarriers
    H_temp = zeros(NumAntenna, NumPath);
    for jPath = 1:NumPath
        H_temp(:,jPath) = g(jPath)*exp(-1i*k_m*r(jPath))*b(:,jPath);
    end
    H(iSub,:) = sum(H_temp,2);
end

save H_nearChannel_Simulation_3.mat H
%% 计算功率角度谱
% by jinzhengtao
% time:2024.11.29
% 内容：bartlett滤波算法提取信道功率角度谱

SetAntenna_v2  %% 载入参数
phase_table = set_triangular_2D.phase_table;

[Nf,Nant,NSym] = size(H);
PAS_1 = zeros(180,2);
PAS_2 = zeros(180,Nf,NSym);

% 计算PAS
for nsym = 1:NSym
    for nf = 1: Nf
        h = H(nf,:,nsym);
        R = h'*h;
        for ncodebook = 1 : 180
            c = phase_table(ncodebook,:);
            PAS_2(ncodebook,nf,nsym) = abs(c * R * c') / (c * c');
        end
    end
end

angle_samp = 0 : 179;

PAS = mean(PAS_2,2);
APAP_nor = (PAS(:))/(max(PAS(:))); % normalization
APAP_dB = 10*log10(PAS);

% 导入实测数据
% Tx1
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_1.mat");
PAS(:,1) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_2.mat");
PAS(:,2) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_3.mat");
PAS(:,3) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_4.mat");
PAS(:,4) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_5.mat");
PAS(:,5) = cell2mat(struct2cell(data));

% Tx2
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_D100_328_1_1.mat");
% PAS(:,1) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_D100_328_1_2.mat");
% PAS(:,2) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_D100_328_1_3.mat");
% PAS(:,3) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_D100_328_1_4.mat");
% PAS(:,4) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_D100_328_1_5.mat");
% PAS(:,5) = cell2mat(struct2cell(data));

% Tx3
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L72_D100_328_2_1.mat");
% PAS(:,1) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L72_D100_328_2_2.mat");
% PAS(:,2) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L72_D100_328_2_3.mat");
% PAS(:,3) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L72_D100_328_2_4.mat");
% PAS(:,4) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L72_D100_328_2_5.mat");
% PAS(:,5) = cell2mat(struct2cell(data));
% 
% % Tx4
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DL100_328_1_1.mat");
% PAS(:,1) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DL100_328_1_2.mat");
% PAS(:,2) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DL100_328_1_3.mat");
% PAS(:,3) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DL100_328_1_4.mat");
% PAS(:,4) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DL100_328_1_5.mat");
% PAS(:,5) = cell2mat(struct2cell(data));
% 
% % Tx5
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DR100_328_1_1.mat");
% PAS(:,1) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DR100_328_1_2.mat");
% PAS(:,2) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DR100_328_1_3.mat");
% PAS(:,3) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DR100_328_1_4.mat");
% PAS(:,4) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DR100_328_1_5.mat");
% PAS(:,5) = cell2mat(struct2cell(data));

PAS_mean = mean(PAS,2); % 首先对PAS求平均
% PAS_mean = sum(PAS(:,2:5),2)/4; % Tx2
% PAS_mean = (PAS(:,1)+sum(PAS(:,3:5),2))/4; % Tx2
PAS_nor = PAS_mean/(max(PAS_mean));

figure()
plot(angle_samp,APAP_nor,'r');grid on
hold on
plot(angle_samp,PAS_nor,'b')
xlabel('Degree ($^{\circ}$)',Interpreter='latex');ylabel('Normalized power')
legend('仿真结果','实测结果')
% figure()
% scatter(angle_samp,APAP_nor,15,"filled");



