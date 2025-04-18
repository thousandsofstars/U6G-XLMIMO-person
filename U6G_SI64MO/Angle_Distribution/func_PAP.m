function PAP_tot = func_PAP(ang_gain,codebook)

[N_ang,~,N_measure] = size(ang_gain);
N_sample = numel(codebook);

PAP_tot = zeros(N_sample,2,N_measure);

for n = 1 : N_measure

    PAP_tot(:,1,n) = codebook.';

    ang_gain_tmp = ang_gain(:,:,n);
    for nang = 1 : N_ang
        ang_tmp = round(ang_gain_tmp(nang,1));

        ang_index = find(codebook == ang_tmp);
        q = abs(ang_gain_tmp(nang,2));
        if numel(q) ~= 1
            error('!')
        end
%         PAP_tot(ang_index,2,n) = PAP_tot(ang_index,2,n) + abs(ang_gain_tmp(nang,2))^2;
%         PAP_tot(ang_index,2,n) = PAP_tot(ang_index,2,n) + abs(ang_gain_tmp(nang,2));
        PAP_tot(ang_index,2,n) = PAP_tot(ang_index,2,n) + (ang_gain_tmp(nang,2));

    end
%     PAP_tot(:,2,n) = PAP_tot(:,2,n).^2;
    PAP_tot(:,2,n) = abs(PAP_tot(:,2,n)).^2;
end

end