# -*- coding: utf-8 -*-
"""
Copyright 2016  Korea University & EMCS Labs  (Author: Hyungwon Yang)
Apache 2.0

*** Introduction ***
This script generates FA requisite files from sound wav and text file.

*** USAGE ***
Ex. python fa_prep_data.py $audio_files $text_files
"""

import sys
import os
import re
import wave

# Arguments check.
if len(sys.argv) != 3:
    print(len(sys.argv))
    print("Input arguments are incorrectly provided. Two argument should be assigned.")
    print("1. Data directory.")
    print("2. Save directory.")
    print("*** USAGE ***")
    print("Ex. python fa_prep_data.py $data_directory $save_directory")
    raise ValueError('RETURN')

# sound and text directory
data_dir = sys.argv[1]
save_dir = sys.argv[2]

if not os.path.exists(save_dir):
    os.makedirs(save_dir)

# Separate data.
whole_list = os.listdir(data_dir)
sound_list=[]
text_list=[]
for one in whole_list:
    if re.findall('wav',one) != []:
        sound_list.append(one)
    elif re.findall('txt',one) != []:
        text_list.append(one)
# Sorting the list.
sound_list.sort()
text_list.sort()
if len(sound_list) != len(text_list):
    raise ValueError('The number of sound and text files are not matched.\n'
                     'Each sound file should pair with each text file.')

### text
'''
Generate text
'''
text_cont=[]
for rd in text_list:
    with open('/'.join([data_dir,rd]),'r') as txt:
        text_cont.append(txt.read())

with open('/'.join([save_dir,'text']),'w') as text:
    for turn in range(len(sound_list)):
        tmp_sound = re.sub('.wav','',sound_list[turn])
        text.write(tmp_sound + ' ' + text_cont[turn] + '\n')

### textraw
'''
Generate textraw
'''
text_cont=[]
for rd in text_list:
    with open ('/'.join([data_dir,rd]),'r') as txt:
        text_cont.append(txt.read())

with open('/'.join([save_dir,'textraw']),'w') as text:
    for turn in text_cont:
        text.write(turn + '\n')

## segments
'''
Generate segments
'''
print("In this script, segments assumes each file contains one utterance.")
with open('/'.join([save_dir,'segments']),'w') as seg:
    for sd in sound_list:
        sig = wave.open('/'.join([data_dir, sd]), 'rb')
        sig_dur = sig.getnframes() / (sig.getframerate() * 1.0)
        dur = "{0:.2f}".format(sig_dur)
        if float(dur) > sig_dur:
            tmp_dur = float(dur)
            tmp_dur -= 0.001
            dur = str(tmp_dur)
        nowav=re.sub('.wav','',sd)
        seg.write(nowav + ' ' + nowav + ' ' + '0' + ' ' + dur + '\n')

# wav.scp
'''
Generate wav.scp
'''
with open ('/'.join([save_dir,'wav.scp']),'w') as scp:
    for win in range(len(sound_list)):
        nowav = re.sub('.wav', '', sound_list[win])
        scp.write(nowav + ' ' + '/'.join([data_dir,sound_list[win]]) + '\n')

# utt2spk
'''
Generate utt2spk
'''
with open ('/'.join([save_dir,'utt2spk']),'w') as u2s:
    dir_name = data_dir.split('/')[-1]
    if dir_name == '':
        print("WARNING: Please remove '/' at the end of the data directory path next time.")
        dir_name =data_dir.split('/')[-2]
    for uin in range(len(sound_list)):
        utwav = re.sub('.wav', '', sound_list[uin])
        u2s.write(utwav + ' ' + dir_name + '\n')

print("All prerequisite data files are successfully generated.")
