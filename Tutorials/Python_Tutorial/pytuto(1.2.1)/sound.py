#! -*- coding: utf-8 -*-
"""
"""
import matplotlib.pyplot as plt
import numpy as np
import wave
import sys
import pyglet as pg

def viewsound(sound_name): # plotting sound spectrogram
    im_sound = wave.open(sound_name,'r')
    
    # Extracting raw audio.
    signal = im_sound.readframes(-1)
    signal = np.fromstring(signal, 'Int16')
    
    # If it is stereo
    if im_sound.getnchannels() == 2:
        print 'Just mono files'
        sys.exit(0)

    plt.figure(1)
    plt.xlabel('Amplitude')
    plt.ylabel('Time')
    plt.title('Sound Wave')
    plt.plot(signal)
    plt.show()


def playsound(sound_name):
    sound= pg.media.load(sound_name)
    sound.play()
    




