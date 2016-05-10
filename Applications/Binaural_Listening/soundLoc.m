function [S] = soundLoc(sig,lag,amp)
%% soundLoc: create sound signal with an added percept of direction, using binaural onset difference 

% This function adds to the input sound signal a directional percept
% using binaural onset difference. 
%
% INPUTS
%       sig  : sound signal (N x 1)
%       lag: onset lag (in samples)
%           if lag >0, abs(lag) samples of zero-padding is added to the signal, 
%                       at the beginning in the right ear & end of the left ear
%                       => (sound location LEFT to the center)
%
%           if lag <0, abs(lag) samples of zero-padding is added to the signal, 
%                        at the beginning in the left ear & end of the right ear
%                       => (sound location RIGHT to the center)
%       
%       amp :  [a1 a2] numbers to be multipied to the signal for amplitude modification
%
% OUTPUT
%   S  : binaural sound signal (N+abs(lag) x 2)


% Written by YG
    
pad = zeros(abs(lag),1); % create the zero padding vector to add to the signal
    

if lag >  0
        S = [[sig; pad]*amp(1) [pad; sig]]*amp(2); % add padding to the beg. of the right-ear signal & end of the left-ear signal
else
        S = [[pad; sig]*amp(1) [sig; pad]*amp(2)]; % add padding to the beg. of the left-ear signal & end of the right-ear signal
end
    
   