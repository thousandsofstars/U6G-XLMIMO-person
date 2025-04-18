function [adc_data] = qx47dr_driver_rx_read_adc_data_47dr(tcp_client, board_num, adc_length)
	
    adc_data = zeros(adc_length, board_num*8);
    adc_bytes = [];
    for i = 1:board_num
        adc_bytes = [adc_bytes fread(tcp_client(i), adc_length * 32)];
        fprintf("Load ADC data from board %d.\n", i);
    end
    
    for i = 1:board_num
        adc_bytes_tmp1 = reshape(adc_bytes(:,i), [4, adc_length * 8]);
        adc_bytes_tmpi = reshape(adc_bytes_tmp1(1:2,:), [1, adc_length * 16]);
        adc_bytes_tmpq = reshape(adc_bytes_tmp1(3:4,:), [1, adc_length * 16]);
        real_int16 = typecast(uint8(adc_bytes_tmpi), 'int16');
        imag_int16 = typecast(uint8(adc_bytes_tmpq), 'int16');
        adc_data_tmp = double(real_int16) + double(imag_int16) .* 1j;
        adc_data(:,(i-1)*8+1:i*8) = reshape(adc_data_tmp, 8, adc_length).';
    end
    
end
