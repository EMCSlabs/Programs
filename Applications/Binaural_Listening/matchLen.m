function [sig1 sig2] = matchLen(sig1,sig2)
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

    if length(sig1) < length(sig2)        
        sig1 = [sig1;zeros(length(sig2)-length(sig1),1)];
    else
        sig2 = [sig2;zeros(length(sig1)-length(sig2),1)];
    end
   
end