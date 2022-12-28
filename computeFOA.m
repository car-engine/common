%% computeFOA
% 17 Nov 2022
% Perry Hong
%
% Computes frequency-of-arrival (doppler) of a given signal 
%
% === INPUT ===
% rx_x: ECEF coordinates of receiving sensor (N x 3)
% rx_xdot: Velocity vector of receiving sensor (N x 3)
% tx_x: ECEF coordinates of transmitting sensor (N x 3)
% tx_xdot: Velocity vector of transmitting sensor (N x 3)
% fc: Center frequency of transmission (Hz)
% c: Speed of light in your medium, default uses speed of light in vacuum

%% Begin function
function foa = computeFOA(rx_x, rx_xdot, tx_x, tx_xdot, fc, options)

    arguments
    
        rx_x (:,3) double
        rx_xdot (:,3) double 
        tx_x (:,3) double
        tx_xdot (:,3) double
        fc double
        options.c double = 299792458
    
    end

    % Direction vector from transmitter to receiver
    vec = rx_x - tx_x;
    vec_hat = normalize(vec, 2, 'norm');

    % Velocity component parallel to direction vector
    xdot_rel = rx_xdot - tx_xdot; % relative velocity 
    xdot_rel_parallel = diag(xdot_rel*vec_hat.');

    foa = -fc/options.c*xdot_rel_parallel;

end

