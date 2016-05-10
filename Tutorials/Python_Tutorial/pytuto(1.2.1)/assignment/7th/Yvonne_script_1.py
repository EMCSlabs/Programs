"""
Written by Yvonne.
There are 3 text files and I want to combine them after erase three marks: comma, period, and double dash.
I found the result that combined 3 text files well but the marks that I wanted to remove were still there.
Please what have I done wrong?
"""
import numpy as np

num_book = 3
newbook = []
for reading in range(1,num_book):
    name = 'return.{0:0>2}.txt'.format(reading)
    with open(name) as book:
        booklines = book.readlines()

        for i in range(len(booklines)):
            changed = booklines[i].replace(',','')
            changed = booklines[i].replace('.','')
            changed = booklines[i].replace('--','')
            newbook.append(changed)


combined = open("newbook.txt", "w")
for writing in range(len(newbook)):
    combined.write(newbook[writing])
combined.close()

# Comments: check the script carefully!! this writer might have not mentioned some other problems
#           because she didn't realize it yet.