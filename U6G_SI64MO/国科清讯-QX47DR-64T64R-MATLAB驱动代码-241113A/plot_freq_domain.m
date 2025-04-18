function [] = plot_freq_domain(x, fs, txt, min_power)
    if nargin < 4
        min_power = -Inf;
    end
    len = size(x,1);
    fft_abs_log = 10*log(abs(fftshift(fft(x))));
    fft_abs_log(fft_abs_log <= min_power) = 0;
    plot((0:len-1)/len*fs/1e6,fft_abs_log); grid on; xlabel('freq/MHz'); ylabel('amp/dB'); title(txt);
end
