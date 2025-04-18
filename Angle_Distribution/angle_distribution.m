clear all;clc;%close all;
%% 获取功率角度谱100*2*700
data = load('ang_gain_7G8_LoS.mat');
ang_gain = data.ang_gain_7G8_LoS;
[n_angle,~,sample] = size(ang_gain);

codebook = 0 : 1 : 179;

PAP_tot = func_PAP(ang_gain,codebook);
APAP = mean(PAP_tot,3);
APAP_nor = (APAP(:,2))/(sum(APAP(:,2))); % normalization
APAP_dB = 10*log10(APAP_nor);

figure()
plot(APAP(:,1),APAP_nor);

%% gauss distribution fitting
GaussModel = fit(APAP(:,1),APAP_nor,'gauss1');
GaussModel
mu_guass = (APAP(:,1))'*APAP_nor; % 拟合得到的均值
sigma_guass = sqrt(sum(((APAP(:,1)-mu_guass).^2).*APAP_nor)); % 拟合得到的标准差
a1=GaussModel.a1; b1=GaussModel.b1;c1=GaussModel.c1;
APAP_guass =  a1*exp(-((APAP(:,1)-b1)/c1).^2);

figure(1)% Gauss拟合
plot(APAP(:,1),APAP_nor,'r-');
hold on
plot(APAP(:,1),APAP_guass,'b--');
% plot(APAP_guass,APAP(:,1),APAP_nor)
title('Gauss fitting');xlabel('AoA(°)');ylabel('Power,P(dB)');
legend('Measurement power', 'Guass distribution');

%% laplace distribution fitting
fitEquation = fittype('c/((sqrt(2*pi))*a)*exp(-sqrt(2)*abs(x-b)/a)', 'coefficients', {'a', 'b','c'});  % Laplace 分布
lowerGuess = [1.067, 89.96];
upperGuess = [3.538, 92.04];
initialGuess = [12, 91, 1];% 确定初值
LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'StartPoint', initialGuess);% 进行曲线拟合
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'Lower',lowerGuess,'Upper',upperGuess,'StartPoint', initialGuess);
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation);
LaplaceModel
a=LaplaceModel.a; b=LaplaceModel.b; c=LaplaceModel.c;
APSD_lap = c/((sqrt(2*pi))*a)*exp(-sqrt(2)*abs(APAP(:,1)-b)/a);

figure(2)% Laplace拟合
plot(APAP(:,1),APAP_nor,'r-');
hold on
plot(APAP(:,1),APSD_lap,'b--');
% plot(LaplaceModel,APAP(:,1),APAP_nor)
title('Laplace fitting');xlabel('AoA(°)');ylabel('Power,P(dB)');
legend('Measurement power', 'Laplace distribution');

%% Von Mises distribution fitting
fitEquation = fittype('exp(a*cos(pi*(x-b)/180))/(2*pi*besseli(0, a))', 'coefficients', {'a', 'b'});  % Laplace 分布
lowerGuess = [1.067, 89.96];
upperGuess = [3.538, 92.04];
initialGuess = [21, 91];% 确定初值
VonModel = fit(APAP(:,1), APAP_nor, fitEquation, 'StartPoint', initialGuess);% 进行曲线拟合
% VonModel = fit(APAP(:,1), APAP_nor, fitEquation, 'Lower',lowerGuess,'Upper',upperGuess,'StartPoint', initialGuess);
% VonModel = fit(APAP(:,1), APAP_nor, fitEquation);
VonModel
a=VonModel.a; b=VonModel.b;
APSD_von=exp(a*cos(pi*(APAP(:,1)-b)/180))/(2*pi*besseli(0, a));  % Laplace 分布


% figure()
% plot(APAP(:,1),APSD_von);

figure(3)% VonMises拟合
plot(APAP(:,1),APAP_nor,'r-');
hold on
plot(APAP(:,1),APSD_von,'b--');
% plot(VonModel,APAP(:,1),APAP_nor)
title('VonMises fitting');xlabel('AoA(°)');ylabel('Power,P(dB)');
legend('Measurement power', 'VonMises distribution');

%% 累计分布
n=ones(sample,1);% 有效角度数量
angle_temp = zeros(100,700);
APSD_temp = zeros(100,700);
mu = zeros(700,1);
sigma = zeros(700,1);
for j=1:sample
    angle_temp(1,j) = data.ang_gain_7G8_LoS(1,1,j);
    APSD_temp(1,j) = data.ang_gain_7G8_LoS(1,2,j);
    for i=1:n_angle-1
        if(data.ang_gain_7G8_LoS(i,1,j)==data.ang_gain_7G8_LoS(i+1,1,j))
            APSD_temp(n(j),j) = APSD_temp(n(j),j)+data.ang_gain_7G8_LoS(i+1,2,j);
        else 
            n(j) = n(j)+1;
            angle_temp(n(j),j) = data.ang_gain_7G8_LoS(i+1,1,j);
            APSD_temp(n(j),j) = data.ang_gain_7G8_LoS(i+1,2,j);
        end
    end
    angle = abs(angle_temp(1:n(j),j));
    APSD = (abs(APSD_temp(1:n(j),j))).^2;
    nor = APSD/(sum(APSD)); % normalization
    mu(j) = sum(angle.*nor); % 拟合得到的均值
    sigma(j) = sqrt(sum(((angle-mu(j)).^2).*nor)); % 拟合得到的标准差
end
% 均值累计分布
one_mu = unique(mu); %unique返回不重复的元素，产生的结果按升序排序 
mu_elements = histc(mu,one_mu);%统计在给定区间内的值的个数，左闭右开 
mu_cdf = cumsum(mu_elements)/sample;%计算元素累加的函数 
% 方差累积分布
one_sigma = unique(sigma); %unique返回不重复的元素，产生的结果按升序排序 
sigma_elements = histc(sigma,one_sigma);%统计在给定区间内的值的个数，左闭右开 
sigma_cdf = cumsum(sigma_elements)/sample;%计算元素累加的函数

%% 绘制图像
figure(1)% Gauss拟合
plot(APAP(:,1),APAP_nor,'r-');
hold on
plot(APAP(:,1),APAP_guass,'b--');
% plot(APAP_guass,APAP(:,1),APAP_nor)
title('Gauss fitting');xlabel('AoA(°)');ylabel('Power,P(dB)');
legend('Measurement power', 'Guass distribution');

figure(2)% Laplace拟合
plot(APAP(:,1),APAP_nor,'r-');
hold on
plot(APAP(:,1),APSD_lap,'b--');
% plot(LaplaceModel,APAP(:,1),APAP_nor)
title('Laplace fitting');xlabel('AoA(°)');ylabel('Power,P(dB)');
legend('Measurement power', 'Laplace distribution');

figure(3)% VonMises拟合
plot(APAP(:,1),APAP_nor,'r-');
hold on
plot(APAP(:,1),APSD_von,'b--');
% plot(VonModel,APAP(:,1),APAP_nor)
title('VonMises fitting');xlabel('AoA(°)');ylabel('Power,P(dB)');
legend('Measurement power', 'VonMises distribution');

figure(4)% 均值累积分布
plot(one_mu,mu_cdf);
title('mu cdf');xlabel('AoA(°)/mu');ylabel('cdf');

figure(5)% 方差累积分布
plot(one_sigma,sigma_cdf);
title('sigma cdf');xlabel('AoA(°)/sigma');ylabel('cdf');