#! -*- coding: utf-8 -*-
"""
This funfun.py introduce many interesting functions that you will like.
Just get used to those functions and try to understand all those structures.


"""

from turtle import Turtle
import colorsys


class Secret():

    def __init__(self):
        """
        Encrypt and decrypt practice
        """
        self.SHIFT = 1
        print("Hello, welcome to the Secret!")


    def encrypt(self,raw):
        self.raw = raw
        ret = ''
        for char in self.raw:
            ret += chr(ord(char)+self.SHIFT)
        return ret

    def decrypt(self,raw):
        self.raw = raw
        ret = ''
        for char in self.raw:
            ret += chr(ord(char)-self.SHIFT)
        return ret


    if __name__ == "__main__":
        print("Welcome to Secret! you run the script by Terminal")
        words = input("input : ")
        encrypted = encrypt(words)
        print(encrypted)

        decrypted = decrypt(encrypted)
        print(decrypted)
        print("Shush! No one should know the code except you.")

###############################################################################

class Drawing():

    def __init__(self):
        """
        This drawing class is for practicing drawing simple or even geometrical 
        pictures with turtle module.
        Let's apply this method with easy examples.
        gb = turtle.Turtle() ; gb.rigth, left, forward, backward, circle, shape, 
        shapesize, penup, pendown, home, clear
        You can get a lot of detail information by googling 'python turtle'.
        """
        self.gb = Turtle()
        self.gb.shape('turtle')
        self.gb.speed(6)
        #self.screen = self.gb.getscreen()
        #w = 150
        #self.screen.setworldcoordinates(-w,-w,w,w)
        print 'A cute turtle is ready to draw!'
    def swirl(self,shape='turtle',speed=0):
        self.gb.shape(shape)
        self.gb.speed(speed)
        self.gb.color('black')
        for i in range(500):
            self.gb.forward(i)
            self.gb.right(98)

    def color_swirl(self,shape='turtle',speed=0):
        self.gb.shape(shape)
        self.gb.speed(speed)
        for i in range(500):
            color = colorsys.hsv_to_rgb(i/1000.0,1.0,1.0)
            self.gb.color(color)
            self.gb.forward(i)
            self.gb.right(98)

    def zigzag(self,shape='turtle',speed=0):
        self.gb.shape(shape)
        self.gb.speed(speed)
        for i in range(180):
            self.gb.forward(100)
            self.gb.right(30)
            self.gb.forward(20)
            self.gb.left(60)
            self.gb.forward(50)
            self.gb.right(30)
            self.gb.penup()
            self.gb.setposition(0,0)
            self.gb.pendown()
            self.gb.right(2)
            
    def square(self,shape='turtle',speed=0):
        self.gb.shape(shape)
        self.gb.speed(speed)
        for i in range(400):
            self.gb.forward(i)
            self.gb.left(90.5)

    def gohome(self):
        wiggle = [30,30,30,30]
        self.gb.shape('turtle')
        self.gb.speed(6)
        self.gb.clear()
        self.gb.penup()
        for tick in wiggle:
            self.gb.right(tick)
            self.gb.left(tick)
        self.gb.home()
        self.gb.clear()
        self.gb.pendown()
        self.gb.color('black')


