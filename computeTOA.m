%% computeTOA
% 17 Nov 2022
% Perry Hong
%
% Computes time-of-arrival of a given signal 
%
% === INPUT ===
% rx_x: ECEF coordinates of receiving sensor (N x 3)
% tx_x: ECEF coordinates of transmitting sensor (N x 3)
% c: Speed of light in your medium, default uses speed of light in vacuum

%% Begin function
function toa = computeTOA(rx_x, tx_x, options)

    arguments

        rx_x (:,3) double 
        tx_x (:,3) double
        options.c double = 299792458
    
    end

    toa = vecnorm(rx_x - tx_x, 2, 2)/options.c; 

end

