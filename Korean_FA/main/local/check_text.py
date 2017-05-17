"""
Copyright 2016  Korea University & EMCS Labs  (Author: Hyungwon Yang)
Apache 2.0

*** Introduction ***
This script reads the text files and checks sentences.
Multiple spaces, tabs, and nuw lines will be removed.

*** USAGE ***
Ex. python check_text.py $data_directory
"""

import os
import re
import time
import optparse

# Option check.
parser = optparse.OptionParser()
parser.add_option("--skip", action="store_true", dest="textgrid_skip", default=False,
                  help="This option keeps textgrid files from deletion.")
(options,args) = parser.parse_args()
tg_option = options.textgrid_skip

# Arguments check.
if len(args) is 0 or len(args) > 1:
    print("Input arguments are incorrectly provided. One argument should be assigned.")
    print("1. data directory.")
    print("*** USAGE ***")
    print("Ex. python check_text.py [options] $data_directory")
    print("*** OPTIONS ***")
    print("--skip : Stop deleting textgrid files.")
    raise ValueError('RETURN')

# text directory
data_dir = args[0]

# Import text files.
data_list = os.listdir(data_dir)
text_list=[]
tg_list=[]
for one in data_list:
    if re.findall('txt',one) != []:
        text_list.append(one)
for tg in data_list:
    if re.findall('TextGrid',tg) != []:
        tg_list.append(tg)

# Execute the following lines based on the option setting.
# Check whether textgrids are already present or not. If so, remove all of them.
if tg_option is False:
    if len(tg_list) is not 0:
        print("WARNNING: TextGrids are already present. However, newly generated TextGrids will replace remained TextGrids.")
        for tg_rm in tg_list:
            os.remove('/'.join([data_dir,tg_rm]))

# Fix the problem if it exists.
inform=0
text_cont=[]
for rd in text_list:
    with open ('/'.join([data_dir,rd]),'r') as txt:

        # Check.
        text_try=txt.read()
        if re.findall('\s{2,}|[\t\n]',text_try) != [] and inform == 0:
            print("=============================== IMPORTANT ===============================")
            print("Text file is contaminated. However it will be fixed automatically.")
            print("Please check the text files again, because the result could be corrupted.")
            print("=========================================================================")
            time.sleep(3)
            inform += 1
        elif len(text_try) == 0:
            print("=============================== ERROR ===============================")
            print(rd + " file is empty. Please check the text files again.")
            print("=====================================================================")
            raise ValueError("Shut down the process.")

        # Fix.
        txt_tmp1=re.sub('\s{2,}|[\t\n]',' ',text_try)
        txt_tmp2=re.sub('[.,?/;:!@#$%^&*-_=+(){}\'\"]','',txt_tmp1)
        txt_fixed=re.sub('\s$','',txt_tmp2)

    with open('/'.join([data_dir,rd]),'w') as wr:
        wr.write(txt_fixed)

print("Text files have been checked.")
