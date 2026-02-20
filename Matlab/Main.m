%% Case Study #1
% * Class:                    ESE 351
% * Date:                     Created 2/19/2026

close all;
clearvars('-except','xs','xsfs','xg','xgfs','xb','xbfs');

[xs, xsfs] = audioread('Space Station - Treble Cut.wav');
[xg, xgfs] = audioread('Giant Steps Bass Cut.wav');
[xb, xbfs] = audioread('SNR Recording 2026-02-15 08_58.wav');

% cutoff freq is 1/(2*pi*R*C)

RLP = 100;
CLP = 6e-5; % -3dB around 160 Hz
tfLP = tf([1], [RLP*CLP 1]);

RHP = 100;
CHP = 6e-7; % -3dB around 14.5k Hz
tfHP = tf([RHP*CHP 0], [RHP*CHP 1]);

R1 = 10;    L1 = 1e-9;      C1 = 1e-5;
R2 = 10;    L2 = 1e-9;      C2 = 1e-5;
R3 = 10;    L3 = 1e-9;      C3 = 1e-5;
tf1 = tf([R1/L1 0],[1 R1/L1 1/(L1*C1)]);
tf2 = tf([R2/L2 0],[1 R2/L2 1/(L2*C2)]);
tf3 = tf([R3/L3 0],[1 R3/L3 1/(L3*C3)]);

% idk if we are allowed to use bode() I think we manually did it, but we 
% can use it to view the response easily for now.
plotTFs(tfLP,tf1,tf2,tf3,tfHP);

plotSpectrograms(xs,xsfs,xg,xgfs,xb,xbfs);