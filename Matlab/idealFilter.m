% Pass in the cutoff frequencies in Hz
function h = idealFilter(low_cf, high_cf, N)
    if nargin < 3
        N = 1000;
    end
    % Sampling frequency
    Fs = 44100;
    
    % Calculate index bounds for cuttoff frequencies
    K_l = floor(low_cf / Fs * N);
    K_h = floor(high_cf / Fs * N);
    
    % Create Fourier series for filter
    Fourier_series = zeros(1, N);
    % Set the passband between cutoff frequencies
    Fourier_series(K_l+1:K_h+1) = 1; 
    % Handle symmetry for other band
    Fourier_series(N-K_h+1:N-K_l+1) = 1;

    h = ifft(Fourier_series);
end
