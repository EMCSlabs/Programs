function [sig1, sig2]  = matchAmp(sig1,sig2)

% match amplitude of the two sound signals

sig1 = sig1/(max(abs(sig1))*1.05);
sig2 = sig2/(max(abs(sig2))*1.05);