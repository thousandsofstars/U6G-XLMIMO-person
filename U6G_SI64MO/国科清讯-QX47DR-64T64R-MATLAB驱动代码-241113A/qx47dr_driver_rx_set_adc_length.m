function [] = qx47dr_driver_rx_set_adc_length(tcp_client, adc_length)
	tcp_frame_head = uint8([18 52]);
	tcp_pkg_type = uint8(1);
	dac_wave_length = uint32(adc_length);
	dac_wave_length_uint8 = typecast(dac_wave_length, 'uint8');
	tcp_zero_pad_4 = uint8([0 0 0 0]);
	tcp_data = [tcp_frame_head tcp_pkg_type dac_wave_length_uint8 tcp_zero_pad_4];
	fwrite(tcp_client, tcp_data);
    fread(tcp_client, 4);
end
