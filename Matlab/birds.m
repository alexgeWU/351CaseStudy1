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

% f_center = 1 / 2*pi*sqrt(LC)
% bandwidth = R / 2*pi*L
% 
% R0 = 140;  L0 = 500e-3; C0 = 50e-6;
% R1 = 220;  L1 = 112e-3; C1 = 10e-6;
% R2 = 200;  L2 = 39e-3;  C2 = 1e-6;
% R3 = 800;  L3 = 30e-3;  C3 = .1e-6;
% R4 = 1300; L4 = 20e-3;  C4 = .01e-6;

R0 = 33.3;  L0 = 500e-3; C0 = 50e-6;     % Q ~ 3.0
R1 = 26.5;  L1 = 112e-3; C1 = 10e-6;     % Q ~ 4.0
R2 = 39.5;  L2 = 39e-3;  C2 = 1e-6;      % Q ~ 5.0
R3 = 50;   L3 = 30e-3;  C3 = .1e-6;     % Q ~ 5.0
R4 = 50;   L4 = 20e-3;  C4 = .01e-6;    % Q ~ 5.0

tf0 = tf([R0/L0 0],[1 R0/L0 1/(L0*C0)]);
tf1 = tf([R1/L1 0],[1 R1/L1 1/(L1*C1)]);
tf2 = tf([R2/L2 0],[1 R2/L2 1/(L2*C2)]);
tf3 = tf([R3/L3 0],[1 R3/L3 1/(L3*C3)]);
tf4 = tf([R4/L4 0],[1 R4/L4 1/(L4*C4)]);

filters = {tf0, tf1, tf2, tf3, tf4};

%% Modify gain and Analyze Response with Plots

% gain = [.8 1 .75 .95 .82]; % normal(ish)
% gain = [10 1 1 1 1]; % Bass boost
% gain = [.7 .8 .5 3.5 3.5]; % Treble boost
gain = [.001 .001 1 60 100]; % Bird

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

figure;
subplot(1,2,1); spectrogram(xb, 1024, 200, 1024, xbfs, 'yaxis');
title('Original Bird Noises'); clim([-120 -80]);
subplot(1,2,2); spectrogram(yb, 1024, 200, 1024, xbfs, 'yaxis');
title('Filtered Bird Noises'); clim([-110 -80]);
disp('Done ploting');

%% Play Audio

M = 1000000;
playerxb = audioplayer(xb, xbfs);
playeryb = audioplayer(yb, xbfs);

disp('Original Bird Sounds...');
playblocking(playerxb);
disp('Equalized Bird Sounds..');
playblocking(playeryb);



