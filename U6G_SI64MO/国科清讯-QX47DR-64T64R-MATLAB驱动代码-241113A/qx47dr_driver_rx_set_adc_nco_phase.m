function [] = qx47dr_driver_rx_set_adc_nco_phase(tcp_client, channel, nco_phase)
	tcp_frame_head = uint8([18 52]);
	tcp_pkg_type = uint8(9);
	channel_uint32 = uint32(channel);
	nco_phase_float = single(nco_phase);
	channel_uint8 = typecast(channel_uint32, 'uint8');
	nco_phase_uint8 = typecast(nco_phase_float, 'uint8');
	tcp_data = [tcp_frame_head tcp_pkg_type channel_uint8 nco_phase_uint8];
	fwrite(tcp_client, tcp_data);
    fread(tcp_client, 4);
end
