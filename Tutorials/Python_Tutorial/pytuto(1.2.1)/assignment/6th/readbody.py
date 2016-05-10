# -*- coding: utf-8 -*-
'''
This script is only for importing bodyfatdata from matlab.
                                                                    Written by Hyungwon Yang
                                                                                2016. 02. 07
                                                                                    EMCS Lab
'''

import scipy.io as sio

def readbody(fileName):

    data = sio.loadmat(fileName)
    bodyfatInputs = data['bodyfatInputs']
    bodyfatTargets = data['bodyfatTargets']

    return bodyfatInputs, bodyfatTargets

