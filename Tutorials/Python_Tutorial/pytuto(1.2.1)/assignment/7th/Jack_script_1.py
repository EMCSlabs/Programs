'''
Written by Jack
My problems are...
    1. I want to generate 200 length time values for sine wave. but it won't work when I turn it into wave variable
    2. Error occurs in plot line: why... why...
'''

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.collections as collections

sample = 200
step = 0.01
blank = 0
timeRange = []
for i in range(sample):
    timeRange.append(blank)
    blank += step

wave = np.sin(2*np.pi*timeRange)

fig, ax = plt.subplots()
ax.plot(timeRange, wave, 'green','--')
ax.axhline(0, 'black', 2)

first_col = collections.BrokenBarHCollection.span_where(
    timeRange, ymin=0, ymax=1, where=wave > 0, facecolor='yellow', alpha=0.2)
ax.add_collection(first_col)

second_col = collections.BrokenBarHCollection.span_where(
    timeRagne, ymin=-1, ymax=0, where=wave < 0, facecolor='blue', alpha=0.2)
ax.add_collection(second_col)

plt.show()