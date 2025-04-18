%X0708 CTRL Host
%by YBQ
addpath('.\UART');
%% Init
%Ctrl interface
COM_Port_Name='com3';
UART_Init;
UART.Head=[81 170 90];%[0x5A,0xAA,0x5A]
PSA.RXATT=[63 63 63 63 63 63 63 63];     %0-63
PSA.TXATT=[63 63 63 63 63 63 63 63];     %0-63

%% En Set  //RF Test
PSA.OpMode=1;
PSA.RXATT=[63 63 63 63 63 63 63 63];   %0-63
UART_SetPSA;
%%        //RF Test
PSA.OpMode=2;
PSA.TXATT=[63 63 63 63 63 63 63 63];   %0-63
UART_SetPSA;

%%        //RF 
PSA.OpMode=3;
PSA.TX_ON=[1 1 1 1 1 1 1 1];     %0-1
PSA.RX_ON=[0 0 0 0 0 0 0 0];     %0-1
UART_SetPSA;
%%       //Set LO
PSA.OpMode=4; %Conv
PSA.Band=5000; %0    
UART_SetPSA;

%%
fclose(COM);



