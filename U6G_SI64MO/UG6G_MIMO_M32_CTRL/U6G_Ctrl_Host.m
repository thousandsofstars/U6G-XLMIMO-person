%V0518
addpath('.\UART');
%%
%Ctrl interface
COM_Port_Name='com4';
UART_Init;
UART.Head=[90 170 90];%[0x5A,0xAA,0x5A]

%%
U6G.OpMode=hex2dec('A1');% Mode Code – 0xA1 : TR_Mode
U6G.exTR_EN=0;    % 0-内部使能控制，1-外部使能控制（由外部TX_EN、RX_EN控制）
U6G.T_Att=23;     % 0-63,0.5dB 衰减步进
U6G.TEN=0; 
U6G.R_Att=23;     % 0-63,0.5dB 衰减步进
U6G.REN=1; 
UART_SetU6G;
%%  Channel enable
U6G.OpMode=3; %Mode Code – 0x03(3): ChEN_Mode
U6G.ChEN1=bin2dec('11111111'); % RF8~RF1
U6G.ChEN2=bin2dec('11111111'); % RF16~RF9
U6G.ChEN3=bin2dec('11111111'); % RF24~RF17
U6G.ChEN4=bin2dec('11111111'); % RF32~RF25
UART_SetU6G;
%%  LO set

U6G.OpMode=4;% Mode Code – 0X04: LO_Mode
U6G.LO_Freq=5000;%4600MHz~5400MHz
U6G.LO_Sel=0;%:0 为内置本振，1为外置本振。
UART_SetU6G;
%%
fclose(COM);
