clear all;clc;close all;
%% 获取功率角度谱100*2*700
data = load('ang_gain_7G8_tilt.mat');
ang_gain = data.ang_gain_7G8_tilt;
[n_angle, ~ ,sample] = size(ang_gain);

codebook = 0 : 1 : 179;

PAP_tot = func_PAP(ang_gain,codebook);

APAP = mean(PAP_tot,3);
% APAP = APAP(20:159,:);
APAP_nor = (APAP(:,2))/(sum(APAP(:,2))); % normalization
APAP_dB = 20*log10(APAP_nor);

figure()
plot(APAP(:,1),APAP_nor);

%% laplace distribution fitting
% fit函数拟合
fitEquation = fittype('c1/((sqrt(2*pi))*a1)*exp(-sqrt(2)*abs(x-b1)/a1)+c2/((sqrt(2*pi))*a2)*exp(-sqrt(2)*abs(x-b2)/a2)', 'coefficients', {'a1', 'b1', 'c1', 'a2', 'b2', 'c2'});  % Laplace 分布
lowerGuess = [1.067, 89.96];
upperGuess = [3.538, 92.04];
initialGuess = [2, 38, 0.4, 0.8, 116, 0.6];% 确定初值
LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'StartPoint', initialGuess);% 进行曲线拟合
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'Lower',lowerGuess,'Upper',upperGuess,'StartPoint', initialGuess);
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation);
LaplaceModel
a1=LaplaceModel.a1; b1=LaplaceModel.b1; c1=LaplaceModel.c1; a2=LaplaceModel.a2; b2=LaplaceModel.b2; c2=LaplaceModel.c2;
% a1=2; b1=38.7; c1=0.4; a2=0.7937; b2=116.5; c2=0.5961;
APSD_lap = c1/((sqrt(2*pi))*a1)*exp(-sqrt(2)*abs(APAP(:,1)-b1)/a1)+c2/((sqrt(2*pi))*a2)*exp(-sqrt(2)*abs(APAP(:,1)-b2)/a2);

figure()% Laplace拟合
plot(APAP(:,1),APAP_nor,'r-');
hold on
plot(APAP(:,1),APSD_lap,'b--');
% plot(LaplaceModel,APAP(:,1),APAP_nor)
title('Laplace fitting/(fit()函数)');xlabel('AoA(°)');ylabel('Power,P(dB)');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');