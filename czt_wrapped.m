%% czt_wrapped
% 23 Feb 2023
% Perry Hong
% Wrapped function to compute the chirp z-transform of a signal (y) between f1 and f2 using n samples

%% Begin function
function [fvec, z] = czt_wrapped(y, fs, f1, f2, n)

    w = exp(-1i*2*pi*(f2-f1)/(n*fs));
    a = exp(1i*2*pi*f1/fs);
    z = czt(y, n, w, a);
    
    fn = (0:n-1)/n;
    fvec = (f2-f1)*fn + f1;

end

