# -*- coding: utf-8 -*-
'''
                                                                    Written by Hyungwon Yang
                                                                                2016. 02. 07
                                                                                    EMCS Lab
'''

import numpy as np
import matplotlib.pyplot as plt

Age = [15, 16, 17, 18, 19, 20]
Tim = [150, 157, 164, 170, 178, 182]
Ninna = [145, 150, 152, 155, 165, 171]

xtotal = np.arange(len(Age))
width = 0.3

bar1 = plt.bar(xtotal, Tim, width, color='b')
bar2 = plt.bar(xtotal+width, Ninna, width, color='r')

plt.ylabel('Height')
plt.xlabel('Age')
plt.title('Height of Time and Ninna by their age')
plt.xticks(xtotal + width, Age)