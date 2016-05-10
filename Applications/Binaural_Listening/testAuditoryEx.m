%% testAuditoryEx: test the auditoryEx functions
% This script demonstrates the following 4 functions in the auditoryEx toolbox

% 1) soundDelay     : combine two signals with custom degree of timing delay 
% 2) soundBi          : generate one binaural signal from two separate signals, with custom binaural amplitudes
% 3) soundLoc         : generate a signal with a location percept

%% soundDelay
clear;close all;clc

[sig1,sr1] = audioread('a1.wav');
[sig2,sr2] = audioread('a2.wav');

% match signal length
[sig1 sig2] = matchLen(sig1,sig2);

% assign parameters
delay_p = 0; % assign delay in percent
delay = floor(length(sig1)*delay_p/100); % calculate delay in samples
amp = [1 1]; 
% run soundDelay
[S] = soundDelay(sig1,sig2,delay,amp); % get the consecutively combined signal of the two input signals, with delay

% play the sound
soundsc(S,sr1)

%% soundBi

clear;close all;clc
[sig1,sr1] = audioread('a1.wav');
[sig2,sr2] = audioread('a2.wav');

% assign parameters
amp = [3 0.2]; 

% run soundBi
[S] = soundBi(sig1,sig2,amp);

% play the sound
soundsc(S,sr1)

%% soundLoc

clear;close all;clc
[sig,sr] = audioread('a1.wav');

% assign parameters
% lag = 0   % location percept: center
lag = 50 % location percept: right to the center
% lag = 20  % location percept: left to the center
% lag = -50 % location percept: (more) right to the center
% lag = 50  % location percept: (more) left to the center
amp = [.5 1];

% run soundLoc
[S] = soundLoc(sig,lag,amp);

% play the sound
soundsc(S,sr)

%% soundLoc for 2 words

clear;close all;clc
[sig1,sr1] = audioread('a1.wav');
[sig2,sr2] = audioread('a2.wav');

% match signal length
[sig1 sig2] = matchLen(sig1,sig2);

% assign parameters
lag1 = 0; % location percept: left to the center
lag2 = 0; % location percept: right to the center
amp1 = [.1 1];
amp2 = [1 .1];

% lag1 = 50; % location percept: left to the center
% lag2 = -50; % location percept: right to the center
% amp1 = [1 .1];
% amp2 = [.1 1];

% run soundLoc
[S1] = soundLoc(sig1,lag1,amp1);
[S2] = soundLoc(sig2,lag2,amp2);

% play the sound
soundsc(S1+S2,sr1)
