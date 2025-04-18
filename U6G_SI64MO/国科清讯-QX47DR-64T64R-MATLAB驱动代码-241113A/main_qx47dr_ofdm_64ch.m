clc;
clear;
close all;

%% 参数
Fs = 122.88e6;
Ftarget = Fs/100;
RxPointN = 500000;
BoardNum = 8;

%% 校准参数
load("Calibration_Data_QX47DR_64T64R_ADC_Phase_RF_241112A.mat");

%% 连接板卡
tcp47dr_tx_tcp = [];
tcp47dr_rx_tcp = [];
for i = 1:BoardNum
    tcp47dr_tx_tcp = [tcp47dr_tx_tcp tcpip(sprintf('192.168.200.%d', i), 2333)];
    %set(tcp47dr_tx_tcp(i),'InputBufferSize', 64*RxPointN);
    %set(tcp47dr_tx_tcp(i),'OutputBufferSize', 64*TxPointN);
    tcp47dr_rx_tcp = [tcp47dr_rx_tcp tcpip(sprintf('192.168.200.%d', i), 2334)];
    set(tcp47dr_rx_tcp(i),'InputBufferSize', 32*RxPointN);
    %set(tcp47dr_rx_tcp(i),'OutputBufferSize', 32*RxPointN);
end

for i = 1:BoardNum
    fopen(tcp47dr_rx_tcp(i));
    fprintf("Connect Board %d rx rcp.\n", i);
end

for i = 1:BoardNum
    fopen(tcp47dr_tx_tcp(i));
    fprintf("Connect Board %d tx rcp.\n", i);
end

fprintf("All TCP Connected.\n");
pause(0.5);

%% 接收数据
% 设置调试打印
for i = 1:BoardNum
    qx47dr_driver_set_debug_print(tcp47dr_tx_tcp(i), 0);
end

% 设置ADC接收点数
for i = 1:BoardNum
    qx47dr_driver_rx_set_adc_length(tcp47dr_tx_tcp(i), RxPointN);
end

% % 设置相位校准值
for i = 1:BoardNum
    for j = 1:8
        qx47dr_driver_rx_set_adc_nco_phase(tcp47dr_tx_tcp(i), j, ADC_Calibration_Phase(i,j));
    end
end

% 设置发射DDS频点
for i = 1:BoardNum
    qx47dr_driver_tx_set_dds_freq(tcp47dr_tx_tcp(i), round(2^32*50/250));
end

% 触发ADC采集
for i = 1:BoardNum
    qx47dr_driver_rx_set_adc_trigger(tcp47dr_tx_tcp(i));
end

% 上传ADC数据
adc_data = qx47dr_driver_rx_read_adc_data_47dr(tcp47dr_rx_tcp, 8, RxPointN);

figure('position',[0 32 800 1000]);
for i = 1:BoardNum*8
    subplot(8,8,i); plot_time_domain(real(adc_data(:,i)), Fs, strcat('Rx-CH',num2str(i),'-时域I'));
end
figure('position',[0 32 800 1000]);
for i = 1:BoardNum*8
    subplot(8,8,i); plot_freq_domain(adc_data(:,i), Fs, strcat('Rx-CH',num2str(i),'-频域'));
end

%% 断开连接
for i = 1:BoardNum
    fclose(tcp47dr_tx_tcp(i));
end

for i = 1:BoardNum
    fclose(tcp47dr_rx_tcp(i));
end

%% 相位差分析
phase_error_1810MHz = func_phase_error_ch1toch64(adc_data.');
ADC_Calibration_Phase_Save = phase_error_1810MHz;
phase_error_1810MHz_32CH = phase_error_1810MHz(1:32);
delay_ps_error_1810MHz = phase_error_1810MHz_32CH./360./1810e6.*1e12;

save("ADC_Calibration_Phase_6p4GHz_CH64_Test2.mat", "ADC_Calibration_Phase_Save");
save("adc_data_phase_test2_30_45.mat", "adc_data");
