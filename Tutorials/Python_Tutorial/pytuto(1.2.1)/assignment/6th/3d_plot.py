# -*- coding: utf-8 -*-
'''
                                                                    Written by Hyungwon Yang
                                                                                2016. 02. 07
                                                                                    EMCS Lab
'''
# Import modules : You may need to install pylab and mpl_toolkits
import pylab as pl
import numpy as np
from mpl_toolkits.mplot3d import axes3d

# Open 3d display.
fig = pl.figure()
fig.gca(projection='3d')

# plot 3 circles.
circle1 = 0.9 * np.random.standard_normal((200,3))
pl.plot(circle1[:,0],circle1[:,1],circle1[:,2],'o')
circle2 = 1.5 * np.random.standard_normal((200,3)) + np.array([5,4,0])
pl.plot(circle2[:,0],circle2[:,1],circle2[:,2],'*')
circle3 = 0.4 * np.random.standard_normal((200,3)) + np.array([0,3,2])
pl.plot(circle3[:,0],circle3[:,1],circle3[:,2],'>')


