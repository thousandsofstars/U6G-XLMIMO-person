clear all;clc;close all;
%% 获取功率角度谱100*2*700
num_data = 5; % 每个测量点测量次数
PAS = zeros(180,num_data);
angle_samp = (0 : 179)';
% angle_samp = (20 : 159)';

% Tx1
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_1.mat");
% PAS(:,1) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_2.mat");
% PAS(:,2) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_3.mat");
% PAS(:,3) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_4.mat");
% PAS(:,4) = cell2mat(struct2cell(data));
% data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L32_D100_328_1_5.mat");
% PAS(:,5) = cell2mat(struct2cell(data));
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
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L72_D100_328_2_1.mat");
PAS(:,1) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L72_D100_328_2_2.mat");
PAS(:,2) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L72_D100_328_2_3.mat");
PAS(:,3) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L72_D100_328_2_4.mat");
PAS(:,4) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L72_D100_328_2_5.mat");
PAS(:,5) = cell2mat(struct2cell(data));
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


% PAS_mean = sum(PAS(:,2:5),2)/4; % 首先对PAS求平均
% PAS_mean = mean(PAS,2);
PAS_mean = PAS(:,1);
% PAS_mean = sum(PAS(:,2:5),2)/4; % 首先对PAS求平均
APAP_nor = PAS_mean/sum(PAS_mean); % 归一化处理
% APAP_nor = PAS_mean(20:159)/sum(PAS_mean(20:159)); % 归一化处理

%% Gauss distribution fitting
% fit函数拟合
fitEquation = fittype('a1*exp(-((x-b1)/c1).^2)+a2*exp(-((x-b2)/c2).^2)', 'coefficients', {'a1', 'b1', 'c1', 'a2', 'b2', 'c2'});  % Laplace 分布
lowerGuess = [1.067, 89.96];
upperGuess = [3.538, 92.04];
initialGuess = [2, 34, 0.4, 100, 94, 4];% 确定初值
GaussModel = fit(angle_samp, APAP_nor, fitEquation, 'StartPoint', initialGuess);% 进行曲线拟合
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'Lower',lowerGuess,'Upper',upperGuess,'StartPoint', initialGuess);
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation);
GaussModel
a1=GaussModel.a1; b1=GaussModel.b1; c1=GaussModel.c1; a2=GaussModel.a2; b2=GaussModel.b2; c2=GaussModel.c2;
% a1=2; b1=38.7; c1=0.4; a2=0.7937; b2=116.5; c2=0.5961;
APSD_gauss = a1*exp(-((angle_samp-b1)/c1).^2)+a2*exp(-((angle_samp-b2)/c2).^2);

figure()% Gauss拟合
plot(angle_samp,APAP_nor,'r-');
hold on
plot(angle_samp,APSD_gauss,'b--');
% plot(LaplaceModel,APAP(:,1),APAP_nor)
title('Gauss fitting/(fit()函数)');xlabel('AoA(°)');ylabel('Power,P(dB)');xlim([20 160]);
legend('Measurement power', 'Gauss distribution');

%% laplace distribution fitting
% fit函数拟合
fitEquation = fittype('c1/((sqrt(2*pi))*a1)*exp(-sqrt(2)*abs(x-b1)/a1)+c2/((sqrt(2*pi))*a2)*exp(-sqrt(2)*abs(x-b2)/a2)', 'coefficients', {'a1', 'b1', 'c1', 'a2', 'b2', 'c2'});  % Laplace 分布
lowerGuess = [1.067, 89.96];
upperGuess = [3.538, 92.04];
initialGuess = [2, 31, 0.4, 4, 112, 8];% 确定初值
LaplaceModel = fit(angle_samp, APAP_nor, fitEquation, 'StartPoint', initialGuess);% 进行曲线拟合
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'Lower',lowerGuess,'Upper',upperGuess,'StartPoint', initialGuess);
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation);
LaplaceModel
a1=LaplaceModel.a1; b1=LaplaceModel.b1; c1=LaplaceModel.c1; a2=LaplaceModel.a2; b2=LaplaceModel.b2; c2=LaplaceModel.c2;
% a1=2; b1=38.7; c1=0.4; a2=0.7937; b2=116.5; c2=0.5961;
APSD_lap = c1/((sqrt(2*pi))*a1)*exp(-sqrt(2)*abs(angle_samp-b1)/a1)+c2/((sqrt(2*pi))*a2)*exp(-sqrt(2)*abs(angle_samp-b2)/a2);

figure()% Laplace拟合
plot(angle_samp,APAP_nor,'r-');
hold on
plot(angle_samp,APSD_lap,'b--');
% plot(LaplaceModel,APAP(:,1),APAP_nor)
title('Laplace fitting/(fit()函数)');xlabel('AoA(°)');ylabel('Power,P(dB)');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

%% laplace distribution fitting
% fit函数拟合
fitEquation = fittype('c1/((sqrt(2*pi))*a1)*exp(-sqrt(2)*abs(x-b1)/a1)+c2/((sqrt(2*pi))*a2)*exp(-sqrt(2)*abs(x-b2)/a2)+c3/((sqrt(2*pi))*a3)*exp(-sqrt(2)*abs(x-b3)/a3)', 'coefficients', {'a1', 'b1', 'c1', 'a2', 'b2', 'c2', 'a3', 'b3', 'c3'});  % Laplace 分布
lowerGuess = [1.067, 89.96];
upperGuess = [3.538, 92.04];
initialGuess = [2, 42, 0.4, 4, 93, 8, 2, 140, 0.2];% 确定初值
LaplaceModel = fit(angle_samp, APAP_nor, fitEquation, 'StartPoint', initialGuess);% 进行曲线拟合
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'Lower',lowerGuess,'Upper',upperGuess,'StartPoint', initialGuess);
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation);
LaplaceModel
a1=LaplaceModel.a1; b1=LaplaceModel.b1; c1=LaplaceModel.c1; a2=LaplaceModel.a2; b2=LaplaceModel.b2; c2=LaplaceModel.c2; a3=LaplaceModel.a3; b3=LaplaceModel.b3; c3=LaplaceModel.c3;
% a1=2; b1=38.7; c1=0.4; a2=0.7937; b2=116.5; c2=0.5961;
APSD_lap = c1/((sqrt(2*pi))*a1)*exp(-sqrt(2)*abs(angle_samp-b1)/a1)+c2/((sqrt(2*pi))*a2)*exp(-sqrt(2)*abs(angle_samp-b2)/a2)+c3/((sqrt(2*pi))*a3)*exp(-sqrt(2)*abs(angle_samp-b3)/a3);

figure()% Laplace拟合
plot(angle_samp,APAP_nor,'r-');
hold on
plot(angle_samp,APSD_lap,'b--');
% plot(LaplaceModel,APAP(:,1),APAP_nor)
title('Laplace fitting/(fit()函数)');xlabel('AoA(°)');ylabel('Power,P(dB)');
legend('Measurement power', 'Laplace distribution');