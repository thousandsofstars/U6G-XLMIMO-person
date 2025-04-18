clear all;clc;close all;
%% 获取功率角度谱100*2*700
data = load('ang_gain_7G8_LoS.mat');
ang_gain = data.ang_gain_7G8_LoS;
[n_angle,~,sample] = size(ang_gain);

codebook = 0 : 1 : 179;

PAP_tot = func_PAP(ang_gain,codebook);

APAP = mean(PAP_tot,3);
APAP = APAP(20:159,:);
APAP_nor = (APAP(:,2))/(sum(APAP(:,2))); % normalization
APAP_dB = 20*log10(APAP_nor);

figure()
plot(APAP(:,1),APAP_dB);

%% gauss distribution fitting
% fit函数拟合
GaussModel = fit(APAP(:,1),APAP_nor,'gauss1');
GaussModel
mu_guass = (APAP(:,1))'*APAP_nor; % 拟合得到的均值
sigma_guass = sqrt(sum(((APAP(:,1)-mu_guass).^2).*APAP_nor)); % 拟合得到的标准差
a1=GaussModel.a1; b1=GaussModel.b1;c1=GaussModel.c1;
APAP_guass =  a1*exp(-((APAP(:,1)-b1)/c1).^2);

figure()% Gauss拟合
plot(APAP(:,1),APAP_nor,'r-');
hold on
plot(APAP(:,1),APAP_guass,'b--');
% plot(APAP_guass,APAP(:,1),APAP_nor)
title('Gauss fitting');xlabel('AoA(°)');ylabel('Power,P(dB)');
legend('Measurement power', 'Guass distribution');

% nlinfit函数拟合
y1=@(b,x) b(1)*exp(-((x-b(2))/b(3)).^2);
b0=[0.2451 91.2 0.7679];%初始参数
[beta1,R,J,CovB, MSE,ErrorModelInfo]=nlinfit(APAP(:,1),APAP_nor,y1,b0);%所求出的回归系数
yp=y1(beta1,APAP(:,1));

figure()
plot(APAP(:,1),APAP_nor,'k',APAP(:,1),yp,'b--')
title('Gauss fitting');xlabel('AoA(°)');ylabel('Power,P(dB)');
legend('Measurement power', 'Guass distribution');

%% laplace distribution fitting
% fit函数拟合
fitEquation = fittype('c/((sqrt(2*pi))*a)*exp(-sqrt(2)*abs(x-b)/a)', 'coefficients', {'a', 'b','c'});  % Laplace 分布
lowerGuess = [1.067, 89.96];
upperGuess = [3.538, 92.04];
initialGuess = [1.5, 91, 0.9];% 确定初值
LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'StartPoint', initialGuess);% 进行曲线拟合
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'Lower',lowerGuess,'Upper',upperGuess,'StartPoint', initialGuess);
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation);
LaplaceModel
a=LaplaceModel.a; b=LaplaceModel.b; c=LaplaceModel.c;
% a=1.5; b=91; c=0.9;
APSD_lap = c/((sqrt(2*pi))*a)*exp(-sqrt(2)*abs(APAP(:,1)-b)/a);

figure()% Laplace拟合
plot(APAP(:,1),APAP_nor,'r-');
hold on
plot(APAP(:,1),APSD_lap,'b--');
% plot(LaplaceModel,APAP(:,1),APAP_nor)
title('Laplace fitting/(fit()函数)');xlabel('AoA(°)');ylabel('Power,P(dB)');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% nlinfit函数拟合
y = @(b,x) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(x-b(2))/b(1));
b0=[1.5, 91, 0.9];%初始参数
[beta1,R,J,CovB, MSE,ErrorModelInfo]=nlinfit(APAP(:,1),APAP_nor,y,b0);%所求出的回归系数
beta1
yp=y(beta1,APAP(:,1));

figure()
plot(APAP(:,1),APAP_nor,'k',APAP(:,1),yp,'b--');
title('Laplace fitting/(nlinfit()函数)');xlabel('AoA(°)');ylabel('Power,P(dB)');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% lsqcurvefit函数拟合
y = @(b,x) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(x-b(2))/b(1));
b0 = [1.5, 91, 0.9];%初始参数
%Optimset函数：‘Gradobj’指用户自定义的目标函数梯度；‘MaxITer’指最大迭代次数，‘100’也就是最大迭代次数，这一项只能为整数。
options = optimset('MaxFunEvals',800,'MaxIter',500);
lb = [];
ub = [];
[beta2,resnorm,residual,exitflag,output] = lsqcurvefit(y,b0,APAP(:,1),APAP_nor,lb,ub,options);%返回在解 x 处的残差 fun(x,xdata)-ydata 的值、描述退出条件的值 exitflag，以及包含优化过程信息的结构体 output。
beta2
yp = y(beta2,APAP(:,1));

figure()
plot(APAP(:,1),APAP_nor,'k',APAP(:,1),yp,'b--');
title('Laplace fitting/(lsqcurvefit()函数)');xlabel('AoA(°)');ylabel('Power,P(dB)');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% lsqnonlin函数
y = @(b) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(APAP(:,1)-b(2))/b(1))-APAP_nor;% 残差函数
b0 = [1.5, 91, 0.9];% 初始参数
beta3 = lsqnonlin(y,b0);
beta3
yp = beta3(3)/((sqrt(2*pi))*beta3(1))*exp(-sqrt(2)*abs(APAP(:,1)-beta3(2))/beta3(1));

figure()
plot(APAP(:,1),APAP_nor,'k',APAP(:,1),yp,'b--');
title('Laplace fitting/(lsqnonlin()函数)');xlabel('AoA(°)');ylabel('Power,P(dB)');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% fsolve函数
y = @(b) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(APAP(:,1)-b(2))/b(1))-APAP_nor;% 残差函数
b0 = [1.5, 91, 0.9];% 初始参数
beta4 = fsolve(y,b0);
beta4
yp = beta4(3)/((sqrt(2*pi))*beta4(1))*exp(-sqrt(2)*abs(APAP(:,1)-beta4(2))/beta4(1));

figure()
plot(APAP(:,1),APAP_nor,'k',APAP(:,1),yp,'b--');
title('Laplace fitting/(fsolve()函数)');xlabel('AoA(°)');ylabel('Power,P(dB)');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% % fminunc函数
% y = @(b) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(APAP(:,1)-b(2))/b(1))-APAP_nor;% 残差函数
% b0 = [1.5, 91, 0.9];% 初始参数
% [beta5,fval,exitflag,output,grad,hessian] = fminunc(y,b0);
% beta5
% yp = beta5(3)/((sqrt(2*pi))*beta5(1))*exp(-sqrt(2)*abs(APAP(:,1)-beta5(2))/beta5(1));
% 
% figure()
% plot(APAP(:,1),APAP_nor,'k',APAP(:,1),yp,'b--');
% title('Laplace fitting/(fminunc()函数)');xlabel('AoA(°)');ylabel('Power,P(dB)');xlim([20 160]);
% legend('Measurement power', 'Laplace distribution');

%% Von Mises distribution fitting
fitEquation = fittype('exp(a*cos(pi*(x-b)/180))/(2*pi*besseli(0, a))', 'coefficients', {'a', 'b'});  % Von Mises 分布
lowerGuess = [1.067, 89.96];
upperGuess = [3.538, 92.04];
initialGuess = [20, 91];% 确定初值
VonModel = fit(APAP(:,1), APAP_nor, fitEquation, 'StartPoint', initialGuess);% 进行曲线拟合
% VonModel = fit(APAP(:,1), APAP_nor, fitEquation, 'Lower',lowerGuess,'Upper',upperGuess,'StartPoint', initialGuess);
% VonModel = fit(APAP(:,1), APAP_nor, fitEquation);
VonModel
a=VonModel.a; b=VonModel.b;
APSD_von=exp(a*cos(pi*(APAP(:,1)-b)/180))/(2*pi*besseli(0, a));  % Laplace 分布

figure()% VonMises拟合
plot(APAP(:,1),APAP_nor,'r-');
hold on
plot(APAP(:,1),APSD_von,'b--');
% plot(VonModel,APAP(:,1),APAP_nor)
title('VonMises fitting');xlabel('AoA(°)');ylabel('Power,P(dB)');
legend('Measurement power', 'VonMises distribution');
