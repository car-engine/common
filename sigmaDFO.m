%% sigmaDFO
% Taken from Algorithms for Ambiguity Function Processing, Seymour Stein (1981)
% Computes FDOA sigma after obtaining FDOA from xcorr
% Input units: noiseBW (Hz), integTime (s)
% Output units: fdoa_sigma (Hz)

%% Begin function

function fdoa_sigma = sigmaDFO(noiseBW, integTime, effSNR)

    fdoa_sigma = (0.55/integTime) / sqrt(noiseBW * integTime * effSNR);

end