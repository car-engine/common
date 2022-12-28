%% estimate_SNR_M2M4
% Perry Hong
% 18 March 2021
%
% Estimates M2M4 SNR from constellation for QPSK signals
% https://arxiv.org/pdf/1810.09937.pdf
%
% === INPUT ===
% constellation_IQ: IQ constellation of input signal
%
% === OUTPUT ===
% est_SNR_M2M4: estimated SNR based on M2M4 statistic (might be NaN if SNR is too low)

%% Begin function

function est_SNR_M2M4 = estimate_SNR_M2M4(constellation_IQ)

    % M2M4 SNR estimation
    M2 = 1/length(constellation_IQ)*(norm(constellation_IQ,2)^2);
    M4 = 1/length(constellation_IQ)*(norm(constellation_IQ,4)^4);

    if 2*M2^2-M4 > 0
        est_SNR_M2M4 = 10*log10(sqrt(2*M2^2-M4)/(M2 - sqrt(2*M2^2-M4)));
    else
        est_SNR_M2M4 = NaN;
    end

end
