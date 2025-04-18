clear all;clc;close all;
%% 获取功率角度谱100*2*700
codebook = 0 : 1 : 179;
%
data1 = load('ang_gain_Vert14_Hori0.mat');
ang_gain1 = data1.ang_gain_Vert14_Hori0;

PAP_tot1 = func_PAP(ang_gain1,codebook);

APAP1 = mean(PAP_tot1,3);
APAP1 = APAP1(20:159,:);
APAP_nor1 = (APAP1(:,2))/(sum(APAP1(:,2))); % normalization
APAP_dB1 = 20*log10(APAP_nor1);
%
data2 = load('ang_gain_Vert10_HoriR.mat');
ang_gain2 = data2.ang_gain_Vert10_HoriR;

PAP_tot2 = func_PAP(ang_gain2,codebook);

APAP2 = mean(PAP_tot2,3);
APAP2 = APAP2(20:159,:);
APAP_nor2 = (APAP2(:,2))/(sum(APAP2(:,2))); % normalization
APAP_dB2 = 20*log10(APAP_nor2);
%
data3 = load('ang_gain_Vert6_HoriR.mat');
ang_gain3 = data3.ang_gain_Vert6_HoriR;

PAP_tot3 = func_PAP(ang_gain3,codebook);

APAP3 = mean(PAP_tot3,3);
APAP3 = APAP3(20:159,:);
APAP_nor3 = (APAP3(:,2))/(sum(APAP3(:,2))); % normalization
APAP_dB3 = 20*log10(APAP_nor3);
%
data4 = load('ang_gain_Vert9_HoriL.mat');
ang_gain4 = data4.ang_gain_Vert9_HoriL;

PAP_tot4 = func_PAP(ang_gain4,codebook);

APAP4 = mean(PAP_tot4,3);
APAP4 = APAP4(20:159,:);
APAP_nor4 = (APAP4(:,2))/(sum(APAP4(:,2))); % normalization
APAP_dB4 = 20*log10(APAP_nor4);

figure()
h1 = plot(APAP1(:,1),APAP_nor1,'r');grid on;hold on
h2 = plot(APAP2(:,1),APAP_nor2,'b');grid on;hold on
h3 = plot(APAP3(:,1),APAP_nor3,'g');grid on;hold on
h4 = plot(APAP4(:,1),APAP_nor4,'black');grid on
%title('Power Augular Spectrum（PAS)')
xlabel('AoA(°)','Interpreter','latex','FontSize',12)
ylabel('Power')
xlim([20 160]);
legend("Tx1","Tx2","Tx3","Tx4");