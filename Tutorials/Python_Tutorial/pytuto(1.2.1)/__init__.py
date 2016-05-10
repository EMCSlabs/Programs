__author__ = 'hyungwonyang'

"""
This 'pytuto' module has been made in order to introduce some of the useful functions & modules 

and provide the way to use them efficiently for those who just started learning Python.

The pytuto module are running well on python 2.7 but not on python3

Please import the module and use the functions in it or tweak the functions or variables inside the module

so that you will get used to the python itself more quickly.

Directory Diagram.

pytuto(module)

    funfun.py : related to interesting functions.
        - Secret : encrypt and decrypt the sentences that you type.
            - encrypt
            - decrypt
        - Drawing : based on the turtle module, you can draw something.
            - swirl
            - color_swirl
            - zigzag
            - square
            - gohome
            
        
    sound.py : related to sound analysis.
        - viewsound : It plots the spectrogram of the sound.
        - playsound : It plays the sound.
        - 


"""



print (
       '\n\n   Python Language for your better research.\n'
       '   Thanks for importing pytuto(Python Tutorial) module.\n'
       '   I wish this module will help you to learn Python.\n\n'
       '\t\t2015.09.10 Written by Hyungwon Yang\n'
       '\t\t  Visit http://emcslabs.blogspot.kr\n'
       '\t\t         ver.1.1(15.09.13) EMCSlabs\n\n'
       )

from .funfun import *
from . import prosodylab
from .sound import *





"""

Version History

ver1.0(15.09.10)
    - created 'seanyang' module.
ver1.1(15.09.13)
    - changed module name 'seanyang' -> 'pytuto' means Python Tutorial.
    - add more functions.
    - edit __init__ information.
ver1.2.1(15.12.20)
    - 1st assignment.
    
"""
