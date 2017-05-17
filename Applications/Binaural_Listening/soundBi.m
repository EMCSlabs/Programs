function [S] = soundBi(sig1,sig2,amp)          
%% soundBi : generate a binaural signal with two signals, with custom binaural amplitudes
% This function concatenates signals of a time lag continuum. When played as audio signal,
% the output creates a percept of a moving sound.
%
% INPUTS
%       sig  : a (N x 1) sound signal 
%
%       step : length of interval (in samples)
%
%                   if step < 0, sound moves from left to center
%                   & time lags are defined as 0:step:-100
%
%                   if step > 0, sound moves from right to center
%                   &time lags are defined as 0:step:100
%
%       amp  :  a (1 x 2) vector that specifies the numbers to be
%               multiplied to each of the signals for amplitude modification
%                   
%                   (e.g. [1 2] -> 1*sig1 & 2*sig2)
%
% OUTPUT
%       S    : vertical concatenation of lag-varyied binaural sound signals (M x 2)
%
% Written by YG

%% make signal lengths equal

if length(sig2)<length(sig1)
    sig1 = sig1(1:length(sig2));
else
    sig2 = sig2(1:length(sig1));
end

%% combine the signals 

% modify signals with the custom amplitude
sig1 = amp(1)*sig1;
sig2 = amp(2)*sig2;

% horizontally concatenate the signals to create one binaural signal
S = [sig1 sig2];

end