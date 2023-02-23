%% General subsample TD/FD code
% Perry Hong
% 11 November 2022
%
% Generic subsample signal alignment code
% Types: 1D TD-only scan, 2D TD/FD scan
%
% === INPUT ===
% sig: IQ of signals to align (N x k)
% ref_sig: IQ of reference signal to be aligned to (1 x k)
% chnBW: channel bandwidth
% type: type of TDFD alignment to be done
% td_max: maximum TDOA scan range
% td_res: TDOA scan resolution
% fd_max: maximum FDOA scan range
% fd_res: FDOA scan resolution
%
% === OUTPUT ===
% sig_aligned: IQ of input signals, now aligned to ref_sig (N x k)
% burst_qf: QF of each sensor after alignment (1 x N)
% burst_tdoa: TDOA of each sensor (1 x N)
% burst_fdoa: FDOA of each sensor (1 x N)

%% Begin function

function [sig_aligned, qf, tdoa, fdoa] = xcorr_subsample_tdfd(sig, ref_sig, chnBW, type, td_max, td_res, fd_max, fd_res)

    numSensors = size(sig, 1);
    ref_sig_length = length(ref_sig);
    
    % TD/FD alignment scan range
    fd_scan_range = (-fd_max:fd_res:fd_max);
    freq_mat = exp(1i*2*pi*fd_scan_range'/chnBW*(0:ref_sig_length-1));
    
    td_scan_range = (-td_max/2:td_res:td_max/2);
    fft_freqs = (-ref_sig_length/2:ref_sig_length/2-1)/ref_sig_length*(chnBW);
    steeringvec = exp(-1i*2*pi*fft_freqs.'*td_scan_range);

    qf_all = zeros(length(fd_scan_range),1);
    idx_td_all = zeros(length(fd_scan_range),1);  
%     cost_vec_all = zeros(length(fd_scan_range), length(td_scan_range)); 

    % Outputs
    sig_aligned = sig;
    qf = zeros(1,numSensors);
    tdoa = zeros(1,numSensors);
    fdoa = zeros(1,numSensors);

    switch type

        case 'TD only'

            % Pre-compute for reference signal
            a = ref_sig;
            a_fft = fftshift(fft(a));
            a_fft_norm = a_fft/norm(a_fft);
    
            for n = 1:numSensors
    
                b = sig(n,:);
                b_fft = fftshift(fft(b));
                
                rx_vec = a_fft_norm.*conj(b_fft);
                cost_vec = (rx_vec*steeringvec)/norm(b_fft); % normalisation for a_fft already pre-computed
                
                [qf,idx_td] = max(abs(cost_vec)); 
                tdoa = td_scan_range(idx_td);
        
                qf(n) = qf;
                tdoa(n) = tdoa;
        
                % TD shift to align with ref_sig
                timeshift = exp(-1i*2*pi*fft_freqs*-tdoa); % negative tdoa because we are shifting sig (b) towards ref_sig (a)
                sig_aligned(n,:) = ifft(ifftshift(fftshift(fft(b)).*timeshift));
                
            end % end loop over sensors

        case 'TD/FD'

            % Pre-compute for reference signal
            a_freqshift = ref_sig.*freq_mat;
            a_freqshift_fft = fftshift(fft(a_freqshift, [], 2), 2);
            a_freqshift_fft_norm = a_freqshift_fft./vecnorm(a_freqshift_fft, 2, 2);

            for n = 1:numSensors
            
                b = sig(n,:);
                b_fft = fftshift(fft(b));

                % Loop over frequency scan range
                for k = 1:length(fd_scan_range)
                
                    a_fft = a_freqshift_fft_norm(k,:);

                    rx_vec = a_fft.*conj(b_fft); 
                    cost_vec = (rx_vec*steeringvec)/norm(b_fft); % normalisation for a_fft already pre-computed 
                    
                    [qf_all(k), idx_td_all(k)] = max(abs(cost_vec));
%                     cost_vec_all(k,:) = cost_vec;
                
                end
            
                [qf,max_qf_idx] = max(qf_all);
                selected_td_idx = idx_td_all(max_qf_idx);
                tdoa = td_scan_range(selected_td_idx);
                fdoa = fd_scan_range(max_qf_idx);
    
%                 disp(['TDOA = ' num2str(tdoa) ' s, FDOA = ' num2str(fdoa) ' Hz, QF = ' num2str(qf)]);
%                 figure; plot(td_scan_range, abs(cost_vec_all(max_qf_idx,:))); title(['Cost vector for FDOA = ' num2str(fdoa) ' Hz']); ylabel('|Cost vector|'); xlabel('TDOA (s)'); grid on;
%                 figure; plot(fd_scan_range, qf_all); title('QF against FDOA, using corresponding best TDOA value'); ylabel('QF'); xlabel('FDOA (Hz)'); grid on;
                
                qf(n) = qf;
                tdoa(n) = tdoa;
                fdoa(n) = fdoa;
                
                % TD and FD shift to align with a
                timeshift = exp(-1i*2*pi*fft_freqs*-tdoa); % negative tdoa because we are shifting ref_sig (b) towards ref_sig (a)
                freqshift = exp(1i*2*pi*-fdoa/chnBW*(0:ref_sig_length-1)); % negative fdoa because we are shifting sig (a) towards ref_sig (a)
                sig_aligned(n,:) = ifft(ifftshift(fftshift(fft(b.*freqshift)).*timeshift));
            
            end  % end loop over sensors    

    end

end
