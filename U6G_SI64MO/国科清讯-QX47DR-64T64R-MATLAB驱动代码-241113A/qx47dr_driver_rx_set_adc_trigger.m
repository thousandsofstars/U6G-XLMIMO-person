function [] = qx47dr_driver_rx_set_adc_trigger(tcp_client)
	tcp_frame_head = uint8([18 52]);
	tcp_pkg_type = uint8(3);
	tcp_zero_pad_8 = uint8([0 0 0 0 0 0 0 0]);
	tcp_data = [tcp_frame_head tcp_pkg_type tcp_zero_pad_8];
	fwrite(tcp_client, tcp_data);
    fread(tcp_client, 4);
end
