function [S] = soundDelay(sig1,sig2,nSamp,amp)
%% soundOverlap: generate a concatenatenation of signals with increasing time lag
% This function concatenates signals of a time lag continuum. When played as audio signal,
% the output creates a percept of a moving sound.

% INPUTS
%       sig1  : (N x 1) sound signal
%       sig2  : (M x 1) sound signal
%       nSamp : number of sample delay of sig2 in the consecutive play of sig1 & sig2
%       amp   : [a1 a2] numbers to be multipied to the signal for amplitude modification
%
% OUTPUT
%       S     : a  matrix (M+N-nSamp X 1) of the combined signal of sig1 & sig with nSamp delay 
%
% Written by YG

%% add zeros to the beginning of sig2 to induce a delay in sounding onset 
sig2_pad = [zeros(nSamp,1); sig2]; % number of zeros added = length(sig1) - nSamp

%% add zeros to the end of sig1 to match sig2_pad length
sig1_pad = [sig1; zeros(nSamp,1)]; % number of zeros added = length(sig2) - nSamp


%% modify amplitude

sig1_pad = sig1_pad*amp(1);
sig2_pad = sig2_pad*amp(2);

%% combine sig1_pad & sig2_pad
S = sig1_pad+sig2_pad;
end