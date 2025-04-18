clc;clear all
% 构造数据, 生成 10000 个服从 N(0,5) 正态分布的数据
Data=normrnd(0,5,10000,1);
% 通过 pts 来控制点的个数
pts = linspace(-20,20,1000);
% 根据 pts 获取数据的频率分布
[yy,xx]=ksdensity(Data,pts);
% 定义拟合的公式
fitEquation = fittype('1/(2*a)*exp(-abs(x-b)/a)', 'coefficients', {'a', 'b'});  % Laplace 分布
%fitEquation = fittype('1/sqrt(2*pi)/b*exp(-(x-a)*(x-a)/(2*b*b))', 'coefficients', {'a', 'b'});
% 确定初值
initialGuess = [1, 6];
% 进行曲线拟合
fittedModel = fit(xx', yy', fitEquation, 'StartPoint', initialGuess);
% 展示拟合结果
disp(fittedModel);
% 绘图
plot(xx,yy)
hold on
a=fittedModel.a; b=fittedModel.b;
yy1=1/(2*a)*exp(-abs(xx-b)/a);  % Laplace 分布
% yy1=1/sqrt(2*pi)/b*exp(-(xx-a).*(xx-a)/(2*b*b));
plot(xx,yy1)
legend(['raw';'fit']);