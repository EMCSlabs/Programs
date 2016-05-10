"""
Written by Sean.
I want to plot various circles in size on polar coordinates.
I think I write it well but I don't why so many errors occurred...
    1.I want to generate 150 random numbers for variables: 'r', 'theta', 'area', 'colors' but for loop does not work.
    2.I also want to give a little transparency in circles. but not sure my circles are visible...
Thank you.
"""

import numpy as np
import random
import matplotlib.pyplot as plt


N = 150
for num in N:
    r = 2 * random.random(N)
    theta = 2 * np.pi * random.random(N)
    area = 200 * r**2 * random.random(N)
    colors = theta

ax = plt.subplot(112, projection='polar')
scatterPlot = plt.scatter(theta, r, colors, area)
scatterPlot.set_alpha(0)

plt.show()