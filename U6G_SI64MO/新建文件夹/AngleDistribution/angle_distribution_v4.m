% by jinzhengtao
% 2025.04.13
% 角度分布拟合

clear all;clc;close all;
%% 数据预处理
num_data = 5; % 每个测量点测量次数
PAS = zeros(180,num_data);
% angle_samp = (0 : 179)';
angle_samp = (20 : 159)';

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

data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DL100_328_1_1.mat");
PAS(:,1) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DL100_328_1_2.mat");
PAS(:,2) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DL100_328_1_3.mat");
PAS(:,3) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DL100_328_1_4.mat");
PAS(:,4) = cell2mat(struct2cell(data));
data = load("D:\OneDrive\桌面\U6G__SI64MO\angle_data\B_PAS_C64_L52_DL100_328_1_5.mat");
PAS(:,5) = cell2mat(struct2cell(data));

PAS_mean = mean(PAS,2); % 首先对PAS求平均
% APAP_nor = PAS_mean/sum(PAS_mean); % 归一化处理
APAP_nor = PAS_mean(20:159)/sum(PAS_mean(20:159)); % 归一化处理

%% gauss distribution fitting
% fit函数拟合
GaussModel = fit(angle_samp,APAP_nor,'gauss1');
GaussModel
mu_guass = (angle_samp)'*APAP_nor; % 拟合得到的均值
sigma_guass = sqrt(sum(((angle_samp-mu_guass).^2).*APAP_nor)); % 拟合得到的标准差
a1=GaussModel.a1; b1=GaussModel.b1;c1=GaussModel.c1;
APAP_guass =  a1*exp(-((angle_samp-b1)/c1).^2);
figure()% Gauss拟合
plot(angle_samp,APAP_nor,'r-');grid on
hold on
plot(angle_samp,APAP_guass,'b--');
% plot(APAP_guass,APAP(:,1),APAP_nor)
title('Gauss fitting/fit函数');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
legend('Measurement power', 'Guass distribution');

%% laplace distribution fitting
% fit函数拟合
fitEquation = fittype('c/((sqrt(2*pi))*a)*exp(-sqrt(2)*abs(x-b)/a)', 'coefficients', {'a', 'b','c'});  % Laplace 分布
lowerGuess = [1.067, 89.96];
upperGuess = [3.538, 92.04];
initialGuess = [8, 75, 8];% 确定初值
LaplaceModel = fit(angle_samp, APAP_nor, fitEquation, 'StartPoint', initialGuess);% 进行曲线拟合
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'Lower',lowerGuess,'Upper',upperGuess,'StartPoint', initialGuess);
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation);
LaplaceModel
a=LaplaceModel.a; b=LaplaceModel.b; c=LaplaceModel.c;
APSD_lap = c/((sqrt(2*pi))*a)*exp(-sqrt(2)*abs(angle_samp-b)/a);
figure()% Laplace拟合
% subplot(231);
plot(angle_samp,APAP_nor,'r-');grid on
hold on
plot(angle_samp,APSD_lap,'b--');
title('Laplace fitting/(fit()函数)');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% nlinfit函数拟合
y = @(b,x) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(x-b(2))/b(1));
b0=[4, 97, 1.6];%初始参数
[beta1,R,J,CovB, MSE,ErrorModelInfo]=nlinfit(angle_samp,APAP_nor,y,b0);%所求出的回归系数
beta1
yp=y(beta1,angle_samp);

figure()
subplot(232);plot(angle_samp,APAP_nor,'r-',angle_samp,yp,'b--');grid on
title('Laplace fitting/(nlinfit()函数)');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% lsqcurvefit函数拟合
y = @(b,x) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(x-b(2))/b(1));
b0 = [4, 97, 1.6];%初始参数
%Optimset函数：‘Gradobj’指用户自定义的目标函数梯度；‘MaxITer’指最大迭代次数，‘100’也就是最大迭代次数，这一项只能为整数。
options = optimset('MaxFunEvals',800,'MaxIter',500);
lb = [];
ub = [];
[beta2,resnorm,residual,exitflag,output] = lsqcurvefit(y,b0,angle_samp,APAP_nor,lb,ub,options);%返回在解 x 处的残差 fun(x,xdata)-ydata 的值、描述退出条件的值 exitflag，以及包含优化过程信息的结构体 output。
beta2
yp=y(beta2,angle_samp);

subplot(233);plot(angle_samp,APAP_nor,'r-',angle_samp,yp,'b--');grid on
title('Laplace fitting/(lsqcurvefit()函数)');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% lsqnonlin函数
y = @(b) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(angle_samp-b(2))/b(1))-APAP_nor;% 残差函数
b0 = [4, 97, 1.6];% 初始参数
beta3 = lsqnonlin(y,b0);
beta3
yp = beta3(3)/((sqrt(2*pi))*beta3(1))*exp(-sqrt(2)*abs(angle_samp-beta3(2))/beta3(1));

subplot(234);plot(angle_samp,APAP_nor,'r-',angle_samp,yp,'b--');grid on
title('Laplace fitting/(lsqnonlin()函数)');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% % fsolve函数
% y = @(b) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(angle_samp-b(2))/b(1))-APAP_nor;% 残差函数
% b0 = [1.5, 88, 0.9];% 初始参数
% options = optimoptions('fsolve','Algorithm','levenberg-marquardt');
% beta4 = fsolve(y,b0,options);
% beta4
% yp = beta4(3)/((sqrt(2*pi))*beta4(1))*exp(-sqrt(2)*abs(angle_samp-beta4(2))/beta4(1));
% 
% subplot(235);plot(angle_samp,APAP_nor,'r-',angle_samp,yp,'b--');grid on
% title('Laplace fitting/(fsolve()函数)');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
% legend('Measurement power', 'Laplace distribution');