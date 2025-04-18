clear all;clc;close all;
%% 获取功率角度谱100*2*700
data = load('D:\OneDrive\桌面\U6G__SI64MO\angle_data\N_ang_gain_C64_L32_D100_328_1_1.mat');
ang_gain = cell2mat(struct2cell(data));
[n_angle,~,sample] = size(ang_gain);

codebook = 0 : 1 : 179;
PAP_tot = func_PAP(ang_gain,codebook);

APAP = mean(PAP_tot,3);
APAP = APAP(20:159,:);
APAP_nor = (APAP(:,2))/(sum(APAP(:,2))); % normalization
APAP_dB = 20*log10(APAP_nor);

figure()
h1 = plot(APAP(:,1),APAP_nor,'r');grid on
% title('功率角度谱（PAS)')
xlabel('AoA(°)','Interpreter','latex','FontSize',12)
ylabel('Power')
xlim([20 160]);

%% gauss distribution fitting
% fit函数拟合
GaussModel = fit(APAP(:,1),APAP_nor,'gauss1');
GaussModel
mu_guass = (APAP(:,1))'*APAP_nor; % 拟合得到的均值
sigma_guass = sqrt(sum(((APAP(:,1)-mu_guass).^2).*APAP_nor)); % 拟合得到的标准差
a1=GaussModel.a1; b1=GaussModel.b1;c1=GaussModel.c1;
APAP_guass =  a1*exp(-((APAP(:,1)-b1)/c1).^2);
figure()% Gauss拟合
plot(APAP(:,1),APAP_nor,'r-');grid on
hold on
plot(APAP(:,1),APAP_guass,'b--');
% plot(APAP_guass,APAP(:,1),APAP_nor)
title('Gauss fitting/fit函数');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
legend('Measurement power', 'Guass distribution');

%% laplace distribution fitting
% fit函数拟合
fitEquation = fittype('c/((sqrt(2*pi))*a)*exp(-sqrt(2)*abs(x-b)/a)', 'coefficients', {'a', 'b','c'});  % Laplace 分布
lowerGuess = [1.067, 89.96];
upperGuess = [3.538, 92.04];
initialGuess = [1.5, 88, 8];% 确定初值
LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'StartPoint', initialGuess);% 进行曲线拟合
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation, 'Lower',lowerGuess,'Upper',upperGuess,'StartPoint', initialGuess);
% LaplaceModel = fit(APAP(:,1), APAP_nor, fitEquation);
LaplaceModel
a=LaplaceModel.a; b=LaplaceModel.b; c=LaplaceModel.c;
APSD_lap = c/((sqrt(2*pi))*a)*exp(-sqrt(2)*abs(APAP(:,1)-b)/a);
figure()% Laplace拟合
subplot(231);plot(APAP(:,1),APAP_nor,'r-');grid on
hold on
plot(APAP(:,1),APSD_lap,'b--');
title('Laplace fitting/(fit()函数)');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% nlinfit函数拟合
y = @(b,x) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(x-b(2))/b(1));
b0=[1.5, 88, 0.9];%初始参数
[beta1,R,J,CovB, MSE,ErrorModelInfo]=nlinfit(APAP(:,1),APAP_nor,y,b0);%所求出的回归系数
beta1
yp=y(beta1,APAP(:,1));

subplot(232);plot(APAP(:,1),APAP_nor,'r-',APAP(:,1),yp,'b--');grid on
title('Laplace fitting/(nlinfit()函数)');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% lsqcurvefit函数拟合
y = @(b,x) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(x-b(2))/b(1));
b0 = [1.5, 88, 0.9];%初始参数
%Optimset函数：‘Gradobj’指用户自定义的目标函数梯度；‘MaxITer’指最大迭代次数，‘100’也就是最大迭代次数，这一项只能为整数。
options = optimset('MaxFunEvals',800,'MaxIter',500);
lb = [];
ub = [];
[beta2,resnorm,residual,exitflag,output] = lsqcurvefit(y,b0,APAP(:,1),APAP_nor,lb,ub,options);%返回在解 x 处的残差 fun(x,xdata)-ydata 的值、描述退出条件的值 exitflag，以及包含优化过程信息的结构体 output。
beta2
yp=y(beta2,APAP(:,1));

subplot(233);plot(APAP(:,1),APAP_nor,'r-',APAP(:,1),yp,'b--');grid on
title('Laplace fitting/(lsqcurvefit()函数)');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% lsqnonlin函数
y = @(b) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(APAP(:,1)-b(2))/b(1))-APAP_nor;% 残差函数
b0 = [1.5, 88, 0.9];% 初始参数
beta3 = lsqnonlin(y,b0);
beta3
yp = beta3(3)/((sqrt(2*pi))*beta3(1))*exp(-sqrt(2)*abs(APAP(:,1)-beta3(2))/beta3(1));

subplot(234);plot(APAP(:,1),APAP_nor,'r-',APAP(:,1),yp,'b--');grid on
title('Laplace fitting/(lsqnonlin()函数)');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
legend('Measurement power', 'Laplace distribution');

% % fsolve函数
% y = @(b) b(3)/((sqrt(2*pi))*b(1))*exp(-sqrt(2)*abs(APAP(:,1)-b(2))/b(1))-APAP_nor;% 残差函数
% b0 = [1.5, 88, 0.9];% 初始参数
% options = optimoptions('fsolve','Algorithm','levenberg-marquardt');
% beta4 = fsolve(y,b0,options);
% beta4
% yp = beta4(3)/((sqrt(2*pi))*beta4(1))*exp(-sqrt(2)*abs(APAP(:,1)-beta4(2))/beta4(1));
% 
% subplot(235);plot(APAP(:,1),APAP_nor,'r-',APAP(:,1),yp,'b--');grid on
% title('Laplace fitting/(fsolve()函数)');xlabel('AoA(°)');ylabel('Power');xlim([20 160]);
% legend('Measurement power', 'Laplace distribution');

%% 累计分布
n=ones(sample,1);% 有效角度数量
angle_temp = zeros(n_angle,sample);
APSD_temp = zeros(n_angle,sample);
mu = zeros(sample,1);
sigma = zeros(sample,1);
for j=1:sample
    angle_temp(1,j) = ang_gain(1,1,j);
    APSD_temp(1,j) = ang_gain(1,2,j);
    for i=1:n_angle-1
        if(ang_gain(i,1,j)==ang_gain(i+1,1,j))
            APSD_temp(n(j),j) = APSD_temp(n(j),j)+ang_gain(i+1,2,j);
        else 
            n(j) = n(j)+1;
            angle_temp(n(j),j) = ang_gain(i+1,1,j);
            APSD_temp(n(j),j) = ang_gain(i+1,2,j);
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

figure()% 均值累积分布
plot(one_mu,mu_cdf);
title('mu cdf');xlabel('AoA(°)/mu');ylabel('cdf');

figure()% 方差累积分布
plot(one_sigma,sigma_cdf);
title('sigma cdf');xlabel('AoA(°)/sigma');ylabel('cdf');