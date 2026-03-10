%% Case Study #1 - Audio Equalizer
% * Class:                    ESE 351
% * Date:                     Created 2/19/2026

close all;
clearvars('-except','xs','xsfs','xg','xgfs','xb','xbfs');

% Read Audio Files
disp('Loading audio files...');
[xs, xsfs] = audioread('Space Station - Treble Cut.wav');
[xg, xgfs] = audioread('Giant Steps Bass Cut.wav');

%% Song Equalizer
disp('Defining filters...');
R0 = 140;  L0 = 500e-3; C0 = 50e-6;
R1 = 220;  L1 = 112e-3; C1 = 10e-6;
R2 = 200;  L2 = 50e-3;  C2 = 1e-6;
R3 = 800;  L3 = 30e-3;  C3 = .1e-6;
R4 = 1300; L4 = 20e-3;  C4 = .01e-6;

b0 = [R0/L0 0]; a0 = [1 R0/L0 1/(L0*C0)];
b1 = [R1/L1 0]; a1 = [1 R1/L1 1/(L1*C1)];
b2 = [R2/L2 0]; a2 = [1 R2/L2 1/(L2*C2)];
b3 = [R3/L3 0]; a3 = [1 R3/L3 1/(L3*C3)];
b4 = [R4/L4 0]; a4 = [1 R4/L4 1/(L4*C4)];

tf0 = tf(b0, a0);
tf1 = tf(b1, a1);
tf2 = tf(b2, a2);
tf3 = tf(b3, a3);
tf4 = tf(b4, a4);

filters = {tf0, tf1, tf2, tf3, tf4};

%% Modify Gain and Process Signals
gain_normal = [.8 1 .9 .95 .9]; % normal(ish)
gain_bass = [10 1 1 .95 .82]; % Bass boost
gain_treble = [.8 1 .5 3.5 3.5]; % Treble boost

% Process Signals
disp('Processing Space Station...');
ys_normal = process_signal(xs, xsfs, filters, gain_normal);
ys_bass = process_signal(xs, xsfs, filters, gain_bass);
ys_treble = process_signal(xs, xsfs, filters, gain_treble);

disp('Processing Giant Steps...');
yg_normal = process_signal(xg, xgfs, filters, gain_normal);
yg_bass = process_signal(xg, xgfs, filters, gain_bass);
yg_treble = process_signal(xg, xgfs, filters, gain_treble);

%% Plot Spectrograms Original vs Equalized
disp('Generating plots...');

figure;
subplot(2,2,1); spectrogram(xs(:, 1), 1024, 200, 1024, xsfs, 'yaxis');
title('Original Space Station', 'FontSize', 14); clim([-120 -70]); xlim([0, 8]);
subplot(2,2,2); spectrogram(ys_normal(:, 1), 1024, 200, 1024, xsfs, 'yaxis');
title('Normal Space Station', 'FontSize', 14); clim([-120 -70]); xlim([0, 8]);
subplot(2,2,3); spectrogram(ys_bass(:, 1), 1024, 200, 1024, xsfs, 'yaxis');
title('Bass Boosted Space Station', 'FontSize', 14); clim([-120 -70]); xlim([0, 8]);
subplot(2,2,4); spectrogram(ys_treble(:, 1), 1024, 200, 1024, xsfs, 'yaxis');
title('Treble Boosted Space Station', 'FontSize', 14); clim([-120 -70]); xlim([0, 8]);

figure;
subplot(2,2,1); spectrogram(xg(:, 1), 1024, 200, 1024, xsfs, 'yaxis');
title('Original Giant Steps', 'FontSize', 14); clim([-120 -70]); xlim([0, 8]);
subplot(2,2,2); spectrogram(yg_normal(:, 1), 1024, 200, 1024, xsfs, 'yaxis');
title('Normal Giant Steps', 'FontSize', 14); clim([-120 -70]); xlim([0, 8]);
subplot(2,2,3); spectrogram(yg_bass(:, 1), 1024, 200, 1024, xsfs, 'yaxis');
title('Bass Boosted Giant Steps', 'FontSize', 14); clim([-120 -70]); xlim([0, 8]);
subplot(2,2,4); spectrogram(yg_treble(:, 1), 1024, 200, 1024, xsfs, 'yaxis');
title('Treble Boosted Giant Steps', 'FontSize', 14); clim([-120 -70]); xlim([0, 8]);


disp('Done ploting');

%% Analyze Frequency and Impulse Responses with Plots

% Analyze Frequency Responses
f = logspace(0,5,1000);
w = 2*pi*f;

H0 = freqs(b0,a0,w);
H1 = freqs(b1,a1,w);
H2 = freqs(b2,a2,w);
H3 = freqs(b3,a3,w);
H4 = freqs(b4,a4,w);

H_indv = [H0; H1; H2; H3; H4];

figure;
t = tiledlayout(5,2);  
for i = 1:5
    H_current = H_indv(i,:);
    
    mag_dB = 20*log10(abs(H_current));
    phase_norm = angle(H_current)/pi;

    % Magnitude
    nexttile(2*i-1)
    semilogx(f, mag_dB)
    title(sprintf('Filter %d Magnitude', i-1))
    grid on
    if i==5; xlabel('Frequency (Hz)'); end

    % Phase
    nexttile(2*i)
    semilogx(f, phase_norm)
    title(sprintf('Filter %d Phase', i-1))
    grid on
    if i==5; xlabel('Frequency (Hz)'); end
end
ylabel(t,'Magnitude (dB) / Phase (\pi rad)')
exportgraphics(gcf, 'figures/freqresponse.jpg')

% Analyze Impulse Responses
disp('Calculating Impulse Responses...');
N = 1000;

% Values to loop easily
b_vals = {b0, b1, b2, b3, b4};
a_vals = {a0, a1, a2, a3, a4};
t_ends = [0.05, 0.01, 0.01, 0.001, 0.001];

figure;
for i = 1:5
    % Approximate impulse response using lsim
    t_imp = linspace(0, t_ends(i), N);
    x_imp = [1, zeros(1, N-1)];
    h_approx = lsim(b_vals{i}, a_vals{i}, x_imp, t_imp);
    
    subplot(5, 1, i);
    plot(t_imp * 1000, h_approx);
    title(sprintf('Filter %d Impulse Response', i-1));
    ylabel('Amplitude');
    grid on;
    xlabel('Time (ms)');
end

%% Plot Total System Responses
figure;

H_total = gain_normal * H_indv;
H_total_bass   = gain_bass * H_indv;
H_total_treble = gain_treble * H_indv;

mag_normal = 20*log10(abs(H_total));
mag_bass   = 20*log10(abs(H_total_bass));
mag_treble = 20*log10(abs(H_total_treble));

phase_normal = angle(H_total)/pi;
phase_bass   = angle(H_total_bass)/pi;
phase_treble = angle(H_total_treble)/pi;

% Plot Magnitude
subplot(2, 1, 1);
semilogx(f, mag_normal,color="#228B22"); hold on;
semilogx(f, mag_bass,color="red");
semilogx(f, mag_treble,color="blue");
grid on;
hold off;

title('Magnitude Response');
ylabel('Magnitude (dB)');
legend('Normal', 'Bass Boost', 'Treble Boost', 'Location', 'southwest');

% Plot Phase
subplot(2, 1, 2);
semilogx(f, phase_normal,color="#228B22"); hold on;
semilogx(f, phase_bass,color="red");
semilogx(f, phase_treble,color="blue");
grid on;
hold off;

title('Phase Response');
ylabel('Phase / \pi (rad)');
xlabel('Frequency (Hz)');
legend('Normal', 'Bass Boost', 'Treble Boost', 'Location', 'southwest');

%% Play Audio

playerxs = audioplayer(xs, xsfs);
playerys_normal = audioplayer(ys_normal, xsfs);
playerys_bass = audioplayer(ys_bass, xsfs);
playerys_treble = audioplayer(ys_treble, xsfs);

audiowrite('audios/unity_ss.wav', ys_normal, xbfs);
audiowrite('audios/bass_ss.wav', ys_bass, xbfs);
audiowrite('audios/treble_ss.wav', ys_treble, xbfs);

% disp('Original Space Station...');
% playblocking(playerxs);
% disp('Norm Space Station...');
% playblocking(playerys_normal);
% disp('Bass Space Station...');
% playblocking(playerys_bass);
% disp('Treble Space Station...');
% playblocking(playerys_treble);

playerxg = audioplayer(xg, xgfs);
playeryg_normal = audioplayer(yg_normal, xgfs);
playeryg_bass = audioplayer(yg_bass, xgfs);
playeryg_treble = audioplayer(yg_treble, xgfs);

audiowrite('audios/unity_gs.wav', yg_normal, xbfs);
audiowrite('audios/bass_gs.wav', yg_bass, xbfs);
audiowrite('audios/treble_gs.wav', yg_treble, xbfs);
 
% disp('Original Giant Steps...');
% playblocking(playerxg);
% disp('Equalized Giant Steps...');
% playblocking(playeryg_normal);
% disp('Bass Giant Steps...');
% playblocking(playeryg_bass);
% disp('Treble Giant Steps...');
% playblocking(playeryg_treble);

%% Bird Equalizer

% Read Audio File
disp('Loading Bird file...');
[xb, xbfs] = audioread('SNR Recording 2026-02-15 08_58.wav');

%% Creating Filters
disp('Defining filters...');

R0 = 1e3;   L0 = 3.9e-3; C0 = 10e-6;   
R1 = 10;   L1 = 7e-3;   C1 = 1e-6;     
R2 = 10;   L2 = 4.7e-3; C2 = 1e-6;    
R3 = 100;  L3 = 3e-3;   C3 = 1e-6;     
R4 = 26.5; L4 = 2.2e-3; C4 = 1e-6;     

b0 = [R0/L0 0]; a0 = [1 R0/L0 1/(L0*C0)];
b1 = [R1/L1 0]; a1 = [1 R1/L1 1/(L1*C1)];
b2 = [R2/L2 0]; a2 = [1 R2/L2 1/(L2*C2)];
b3 = [R3/L3 0]; a3 = [1 R3/L3 1/(L3*C3)];
b4 = [R4/L4 0]; a4 = [1 R4/L4 1/(L4*C4)];

tf0 = tf(b0, a0);
tf1 = tf(b1, a1);
tf2 = tf(b2, a2);
tf3 = tf(b3, a3);
tf4 = tf(b4, a4);

filters = {tf0, tf1, tf2, tf3, tf4};

% Modify gain

gain_bird = [0 1 6 5 10]; % Bird

%% Process Signal
disp('Processing Bird Noises...');
yb = process_signal(xb, xbfs, filters, gain_bird);

%% Plot Spectrograms Original vs Equalized
disp('Generating plots...');

figure(5);
subplot(1,2,1); spectrogram(xb, 1024, 200, 1024, xbfs, 'yaxis');
title('Original Bird Noises'); clim([-120 -80]);
subplot(1,2,2); spectrogram(yb, 1024, 200, 1024, xbfs, 'yaxis');
title('Filtered Bird Noises'); clim([-110 -80]);
exportgraphics(gcf, 'figures/birdspectograms.jpg')
disp('Done ploting');

%% Analyze Frequency and Impulse Responses with Plots

% Analyze Frequency Responses
f = logspace(0,5,1000);
w = 2*pi*f;

H0 = freqs(b0,a0,w);
H1 = freqs(b1,a1,w);
H2 = freqs(b2,a2,w);
H3 = freqs(b3,a3,w);
H4 = freqs(b4,a4,w);

H_indv = [H0; H1; H2; H3; H4];

figure;
for i = 1:5
    H_current = H_indv(i, :); 
    
    mag_dB = 20*log10(abs(H_current));
    phase_norm = angle(H_current)/pi;
    
    % Plot Magnitude
    subplot(5, 2, 2*i - 1);
    semilogx(f, mag_dB);
    ylabel('Mag (dB)');
    title(sprintf('Filter %d Frequency Response', i-1));
    grid on;
    if i == 5; xlabel('Frequency (Hz)'); end
    
    % Plot Phase
    subplot(5, 2, 2*i);
    semilogx(f, phase_norm);
    ylabel('Phase / \pi (rad)');
    title(sprintf('Filter %d Frequency Response', i-1));
    grid on;
    if i == 5; xlabel('Frequency (Hz)'); end
end

% Analyze Impulse Responses
disp('Calculating Impulse Responses...');
N = 1000;

% Values to loop easily
b_vals = {b0, b1, b2, b3, b4};
a_vals = {a0, a1, a2, a3, a4};
t_ends = [0.05, 0.01, 0.01, 0.001, 0.001];

figure;
for i = 1:5
    % Approximate impulse response using lsim
    t_imp = linspace(0, t_ends(i), N);
    x_imp = [1, zeros(1, N-1)];
    h_approx = lsim(b_vals{i}, a_vals{i}, x_imp, t_imp);
    
    subplot(5, 1, i);
    plot(t_imp * 1000, h_approx);
    title(sprintf('Filter %d Impulse Response', i-1));
    ylabel('Amplitude');
    grid on;
    xlabel('Time (ms)');
end

%% Plot Total System Responses
figure;

H_total = gain_bird * H_indv;

mag_total = 20*log10(abs(H_total));

phase_total = angle(H_total)/pi;


% Plot Magnitude
subplot(2, 1, 1);
semilogx(f, mag_total);
grid on;

title('Magnitude Response');
ylabel('Magnitude (dB)');

% Plot Phase
subplot(2, 1, 2);
semilogx(f, phase_total); 
grid on;

title('Phase Response');
ylabel('Phase / \pi (rad)');
xlabel('Frequency (Hz)');

%% Play Audio

playerxb = audioplayer(xb, xbfs);
playeryb = audioplayer(yb, xbfs);

% disp('Original Bird Sounds...');
% playblocking(playerxb);
% disp('Equalized Bird Sounds..');
% playblocking(playeryb);

audiowrite('audios/filteredbirds.wav', yb, xbfs);


