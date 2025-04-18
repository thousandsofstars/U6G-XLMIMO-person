function [] = plot_time_domain(x, fs, txt)
    len = size(x,1);
    plot((0:len-1)/fs*1e6,real(x)); grid on; xlabel('t/us'); ylabel('amp'); title(txt);
end
