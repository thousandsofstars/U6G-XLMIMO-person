clc;
clear;
close all;

ADC_Calibration_Phase = zeros(8,8);

load("ADC_Calibration_Phase_6p4GHz_CH1_CH32_Test3.mat");
ADC_Calibration_Phase_Save_CH1_CH32 = reshape(ADC_Calibration_Phase_Save, 8, 8);
ADC_Calibration_Phase_Save_CH1_CH32 = ADC_Calibration_Phase_Save_CH1_CH32.';
ADC_Calibration_Phase_Save_CH1_CH32 = -ADC_Calibration_Phase_Save_CH1_CH32;
ADC_Calibration_Phase(1:4,:) = ADC_Calibration_Phase_Save_CH1_CH32(1:4,:);

load("ADC_Calibration_Phase_6p4GHz_CH33_CH63_Test3.mat");
ADC_Calibration_Phase_Save_CH33_CH63 = reshape(ADC_Calibration_Phase_Save, 8, 8);
ADC_Calibration_Phase_Save_CH33_CH63 = ADC_Calibration_Phase_Save_CH33_CH63.';
ADC_Calibration_Phase_Save_CH33_CH63 = -ADC_Calibration_Phase_Save_CH33_CH63;
ADC_Calibration_Phase(5:8,:) = ADC_Calibration_Phase_Save_CH33_CH63(5:8,:);

load("ADC_Calibration_Phase_6p4GHz_CH64_Test1.mat");
ADC_Calibration_Phase_Save_CH64 = reshape(ADC_Calibration_Phase_Save, 8, 8);
ADC_Calibration_Phase_Save_CH64 = ADC_Calibration_Phase_Save_CH64.';
ADC_Calibration_Phase_Save_CH64 = -ADC_Calibration_Phase_Save_CH64;
ADC_Calibration_Phase(8,8) = ADC_Calibration_Phase_Save_CH64(8,8);

save("Calibration_Data_QX47DR_64T64R_ADC_Phase_RF_241112A.mat", "ADC_Calibration_Phase");
