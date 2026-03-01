function y = processSignal(x, fs, filters, gains)
    numSamples = length(x);
    numChannels = size(x, 2);
    
    t = (0:numSamples-1)' / fs;
    y = zeros(numSamples, numChannels);
    
    for i = 1:length(filters)
        for ch = 1:numChannels
            y(:, ch) = y(:, ch) + gains(i) * lsim(filters{i}, x(:, ch), t);
        end
    end
end