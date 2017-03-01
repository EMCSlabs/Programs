# -*- coding: utf-8 -*-
"""
Created by Yeonjung Hong 2016-04-26
Modified by Hyungwon Yang 2016-08-10


4 arguments: phones.txt, segments, merged_ali.txt, final_ali.txt
merged_alignment.txt > merged_ali.txt
final_ali2.txt > final_ali.txt
Last argument sets the name of output file.
"""
import os
import sys

# Arguments check.
if len(sys.argv) != 5:
    print(len(sys.argv))
    raise ValueError('The number of input arguments is wrong.')

phone_file = sys.argv[1]
segments_file = sys.argv[2]
merged_ali_file = sys.argv[3]
final_result = sys.argv[4]

# read the three files required
phones = []
with open(phone_file) as a:
    data = a.readlines()
    for line in data:
        phones.append(line.split())
        
segments = [] 
with open(segments_file) as b:
    data = b.readlines()
    for line in data:
        segments.append(line.split())

ctm = []       
with open(merged_ali_file) as c:
    data = c.readlines()
    for line in data:
        ctm.append(line.split())
        
       
#
ctm_new = []
for k in phones:
    for i in ctm:
        if i[4] == k[1]:
            new = i + list([k[0]]) # merge phones and ctm by phone_id
            ctm_new.append(new)

ctm_new2 = []
for n in segments:
    for m in ctm_new:
        if n[0] == m[0]:
            # utt_id, file_id, phone_id, utt_num, start_ph, dur_ph, phone, start_utt, end_utt, start_real, end_real
            start_real = str(float(n[2]) + float(m[2]))
            tmp=float(start_real) + float(m[3])
            end_real = str("{0:.3f}".format(float(tmp * 10**3) / 10.0**3))
            new = [n[0],n[1],m[4],m[1],m[2],m[3],m[5],n[2],n[3],start_real,end_real]
            ctm_new2.append(new)

# write a text file "final_ali.txt"
with open (final_result,"w")as f:
    f.writelines('\t'.join(i) + '\n' for i in ctm_new2)
#
final_name = final_result.split('/')[-1]
print(final_result + " is successfully created.")
