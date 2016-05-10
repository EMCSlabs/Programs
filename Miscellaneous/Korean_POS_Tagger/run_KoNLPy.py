# -*- coding: utf-8 -*-
"""
Created on Mon Jan 18 10:04:16 2016

@author: jaegukang
"""

import os
import sys


def CheckModule():
    # Check if konlpy is installed
    try:
        import konlpy
        val = True
        return val
    except:
        print '\nYou need to install konlpy to use tagger'
        print 'Visit: http://konlpy.org/ko/latest/install/\n'
        print '1) sudo apt-get install g++ openjdk-7-jdk python-dev'
        print '   (**Install Java 1.7 or up**)'
        print '2) pip install JPype1 '
        print '3) pip install konlpy\n'
        val = False
        return val


def tagPOS(filename):
    try:
        # Read file
        f = open(filename, 'r')
        text = f.read().decode('utf-8') # read file as utf8 decoded
        f.close()
        
        # tagging
        from konlpy.tag import Kkma
        #from konlpy.utils import pprint
        kkma = Kkma()
        print ('now tagging...')
        tagged = kkma.pos(text)
        
        # Write tagged file
        (path,fnameExt) = os.path.split(filename)
        (fname,fext) = os.path.splitext(fnameExt)
        tagged_file = fname+'_'+'tagged'+fext
        fw = open(tagged_file,'w')
        for line in tagged:
            strs="\t".join(x for x in line).encode('utf-8')
            fw.write(strs+"\n")
        fw.close()
        print '%s is created' % (tagged_file)
    except:
        print '\nERROR:'
        print '"%s" is not a valid text\nCheck your text file\nor file path\n' % (filename)
        sys.exit(1)

def tagMORPH(filename):
    # Read file
    f = open(filename, 'r')
    text = f.read().decode('utf-8') # read file as utf8 decoded
    f.close()
        
    # tagging
    from konlpy.tag import Kkma
    #from konlpy.utils import pprint
    kkma = Kkma()
    print ('now tagging morphemes...')
    tagged = kkma.morphs(text)
    
    # Write tagged file
    (path,fnameExt) = os.path.split(filename)
    (fname,fext) = os.path.splitext(fnameExt)
    tagged_file = fname+'_'+'morph'+fext
    fw = open(tagged_file,'w')
    for line in tagged:
        strs = line.encode('utf-8')
        fw.write(strs+"\n")
    fw.close()
    print '%s is created' % (tagged_file)    


def SortSentence(filename):
    # Read file
    f = open(filename, 'r')
    text = f.read().decode('utf-8') # read file as utf8 decoded
    f.close()
        
    # tagging
    from konlpy.tag import Kkma
    #from konlpy.utils import pprint
    kkma = Kkma()
    print ('now dividing sentences...')
    tagged = kkma.sentences(text)
    
    # Write tagged file
    (path,fnameExt) = os.path.split(filename)
    (fname,fext) = os.path.splitext(fnameExt)
    tagged_file = fname+'_'+'sentence'+fext
    fw = open(tagged_file,'w')
    for line in tagged:
        strs = line.encode('utf-8')
        fw.write(strs+"\n")
    fw.close()
    print '%s is created' % (tagged_file)    
    
    
def SortNoun(filename):
    # Read file
    f = open(filename, 'r')
    text = f.read().decode('utf-8') # read file as utf8 decoded
    f.close()
        
    # tagging
    from konlpy.tag import Kkma
    #from konlpy.utils import pprint
    kkma = Kkma()
    print ('now extracting nouns...')
    tagged = kkma.nouns(text)
    
    # Write tagged file
    (path,fnameExt) = os.path.split(filename)
    (fname,fext) = os.path.splitext(fnameExt)
    tagged_file = fname+'_'+'noun'+fext
    fw = open(tagged_file,'w')
    for line in tagged:
        strs = line.encode('utf-8')
        fw.write(strs+"\n")
    fw.close()
    print '%s is created' % (tagged_file)    

def main():
    args = sys.argv[1:]
    
    # Check konlp module
    if not CheckModule():
        sys.exit(1)
    
    # Check arguments
    if not args:
        print '\n<< How to use run_KoNLPy.py >>\n'
        print 'usage1: python run_KoNLPy.py filename'
        print 'usage2: python run_KoNLPy.py filename sentence'
        print 'usage3: python run_KoNLPy.py filename noun'
        print 'usage4: python run_KoNLPy.py filename morpheme'
        print 'usage4: python run_KoNLPy.py filename sentence noun morpheme\n'
        print '[Example: python run_KoNLPy.py myText.txt sentence noun]'
        print '[Output: myText_tagged.txt, myText_sentence.txt, myText_noun.txt]\n'
        sys.exit(1)
        
    # Execute tagging
    tagPOS(args[0])
    
    if 'sentence' in args:
        SortSentence(args[0])
    
    if 'noun' in args:
        SortNoun(args[0])
        
    if 'morpheme' in args:
        tagMORPH(args[0])

if __name__ == '__main__':
    main()
    
    
    
    