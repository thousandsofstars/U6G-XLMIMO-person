function UART_CallBack(obj,event)
[UART_Rx,a]=fread(obj,8,'uint8')
end