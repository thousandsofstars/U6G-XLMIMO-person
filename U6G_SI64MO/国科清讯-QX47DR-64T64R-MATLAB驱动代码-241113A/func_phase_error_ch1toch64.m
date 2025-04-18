
function phase_error_angle = func_phase_error_ch1toch64(x)
    
    N = 64;

    phase_error = zeros(1,N);
    for i = 1:N
        phase_error(1,i) = func_phdiffmeasure(x(1,:),x(i,:));
    end
    phase_error_angle = phase_error / pi * 180;
    for i = 1:N
        if phase_error_angle(i) < -180
            phase_error_angle(i) = phase_error_angle(i) + 360;
        end
        if phase_error_angle(i) > 180
            phase_error_angle(i) = phase_error_angle(i) - 360;
        end
    end

end
