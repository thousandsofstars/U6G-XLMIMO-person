tic
REG1=PSA.OpMode;
if(PSA.OpMode==1)
   REG0=PSA.RXATT;
elseif(PSA.OpMode==2)
   REG0=PSA.TXATT;
elseif(PSA.OpMode==3)
    TX_EN_Reg=PSA.TX_ON*[128 64 32 16 8 4 2 1].';
    RX_EN_Reg=PSA.RX_ON*[128 64 32 16 8 4 2 1].';
    if(RX_EN_Reg~=0)
        TX_EN_Reg=0;
    end
    REG0=[0 0 0 0 0 0 TX_EN_Reg RX_EN_Reg];
elseif(PSA.OpMode==4)
    REG0=[0 0 0 0 0 0 floor(PSA.Band/256)  rem(PSA.Band,256)];
else 
    REG0=[0 0 0 0 0 0 0 0];
end

CtrlPacket=[REG0 REG1];
UART.CheckSum=rem(sum([UART.Head CtrlPacket]),256);
UART_Frame=[UART.Head CtrlPacket UART.CheckSum]
fwrite(COM,UART_Frame,'uint8');
UART_Back=(fread(COM,8,'uint8')).'

%PSA.Temp_code=UART_Back(6)*256+UART_Back(7);
%PSA.Temp_deg=(PSA.Temp_code/1024*3.3*1000-776)/2.86;
%disp(sprintf('Temperature is %.2f °„C\n', PSA.Temp_deg));
toc