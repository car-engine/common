%% sigmaDFO_integ
% Taken from Algorithms for Ambiguity Function Processing, Seymour Stein (1981)
% Computes FDOA sigma after obtaining FDOA from xcorr
% Integration of the signal rather than using a rectangular spectrum
% Input units: noiseBW (Hz), integTime (s)
% Output units: fdoa_sigma (Hz)

%% Begin function

function fdoa_sigma = sigmaDFO_integ(signal, noiseBW, integTime, effSNR)

    tvec = -integTime/2:(integTime/(length(signal)-1)):integTime/2;
    Te = 2*pi*sqrt(sum((tvec.^2).*(abs(signal).^2))/sum((abs(signal).^2)));
    fdoa_sigma = 1/(Te*sqrt(noiseBW*integTime*effSNR));

end