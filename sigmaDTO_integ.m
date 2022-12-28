%% sigmaDTO_integ
% Taken from Algorithms for Ambiguity Function Processing, Seymour Stein (1981)
% Computes TDOA sigma after obtaining TDOA from xcorr
% Integration of the signal rather than using a rectangular spectrum
% Input units: signalBW (Hz), noiseBW (Hz), integTime (s)
% Output units: tdoa_sigma (Hz)

%% Begin function
function tdoa_sigma = sigmaDTO_integ(signal, signalBW, noiseBW, integTime, effSNR)

    signal_fft = fftshift(fft(signal));
    fvec = -signalBW/2:signalBW/(length(signal)-1):signalBW/2;
    beta = 2*pi*sqrt(sum((fvec.^2).*(abs(signal_fft).^2))/sum((abs(signal_fft).^2)));
    tdoa_sigma = 1/(beta*sqrt(noiseBW*integTime*effSNR));

end

