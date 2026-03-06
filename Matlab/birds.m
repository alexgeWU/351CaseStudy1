%% Case Study #1 - Audio Equalizer
% * Class:                    ESE 351
% * Date:                     Created 2/19/2026

close all;
clearvars('-except','xs','xsfs','xg','xgfs','xb','xbfs');

% Read Audio Files
disp('Loading audio files...');
[xb, xbfs] = audioread('SNR Recording 2026-02-15 08_58.wav');

%% Creating Filters
disp('Defining filters...');


R0 = 1;   L0 = 3.9e-3;  C0 = 10e-6;  % 200 Hz
R1 = 10;   L1 = 7e-3;   C1 = 1e-6;     % 1.9 kHz
R2 = 10;   L2 = 4.7e-3; C2 = 1e-6;     % 2.3 kHz
R3 = 10;  L3 = 3e-3;   C3 = 1e-6;     % 2.9 kHz
R4 = 10; L4 = 2.2e-3; C4 = 1e-6;     % 3.4 kHz


tf0 = tf([R0/L0 0],[1 R0/L0 1/(L0*C0)]);
tf1 = tf([R1/L1 0],[1 R1/L1 1/(L1*C1)]);
tf2 = tf([R2/L2 0],[1 R2/L2 1/(L2*C2)]);
tf3 = tf([R3/L3 0],[1 R3/L3 1/(L3*C3)]);
tf4 = tf([R4/L4 0],[1 R4/L4 1/(L4*C4)]);

filters = {tf0, tf1, tf2, tf3, tf4};

%% Modify gain and Analyze Response with Plots

gain = [0 1 6 5 10]; % Bird

tf_total = gain(1)*tf0 + ...
           gain(2)*tf1 + ...
           gain(3)*tf2 + ...
           gain(4)*tf3 + ... 
           gain(5)*tf4;

options = bodeoptions;
options.FreqUnits = 'Hz';
bode(tf_total, options);

plotTFs(tf0,tf1,tf2,tf3,tf4);

%% Process Signal
disp('Processing Bird Noises...');
yb = processSignal(xb, xbfs, filters, gain);

%% Plot Spectrograms Original vs Equalized
disp('Generating plots...');

figure(5);
subplot(1,2,1); spectrogram(xb, 1024, 200, 1024, xbfs, 'yaxis');
title('Original Bird Noises'); clim([-120 -80]);
subplot(1,2,2); spectrogram(yb, 1024, 200, 1024, xbfs, 'yaxis');
title('Filtered Bird Noises'); clim([-110 -80]);
exportgraphics(gcf, 'figures/birdspectograms.jpg')
disp('Done ploting');

%% Play Audio

M = 1000000;
playerxb = audioplayer(xb, xbfs);
playeryb = audioplayer(yb(M:end), xbfs);
audiowrite('filteredbirds.wav', yb, xbfs);


disp('Original Bird Sounds...');
% playblocking(playerxb);
disp('Equalized Bird Sounds..');
playblocking(playeryb);



