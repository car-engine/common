%% sigmaDTO
% Taken from Algorithms for Ambiguity Function Processing, Seymour Stein (1981)
% Computes TDOA sigma after obtaining TDOA from xcorr
% Input units: signalBW (Hz), noiseBW (Hz), integTime (s)
% Output units: tdoa_sigma (Hz)

%% Begin function

function tdoa_sigma = sigmaDTO(signalBW, noiseBW, integTime, effSNR)

    beta = pi / sqrt(3) * signalBW;
    tdoa_sigma = (1/beta) / sqrt(noiseBW * integTime * effSNR);

end