# Korean_FA: Korean Forced-Aligner  
---

2016
Media Zen & Korea University (Author: Hyungwon Yang)

                                                    



### MacOSX and Linux
----------------------------------------------------------------
Mac OS X (El Capitan 10.11.6): Stable.
Linux (Ubuntu 14.04): Stable.

Bash
Python 3.5
(This script was not tested on the other versions.)


### PREREQUISITE

1. **Install Kaldi**
 - Type below in command line.
    - $ git clone https://github.com/kaldi-asr/kaldi.git kaldi --origin upstream
    - $ cd kaldi
    - $ git pull 
 - Read INSTALL and follow the direction written there.

2. **Install Packages**
 - Install list: Sox, xlrd, coreutils.
 -  On mac
    - $ brew install sox
    - $ pip3 install xlrd (Make sure to install xlrd into python3 library not in python2. If you use anaconda then you have to install it in there. Otherwise, install it into a proper directory.)
    - $ brew install coreutils


### MATERIALS (Data Preparation)

1. **Audio files (.wav)** (of sampling rate at 16,000Hz)
 - Please provide audio file(s) in WAV format ('.wav') at 16,000Hz sampling rate.
 - Korean_FA is applied assuming that the sampling rate of input audio file(s) is 16,000Hz.
2. **Text files (.txt)**
 - Name your transcription text files suffixed by ordered numbers
 - ex) name01.txt, name02.txt, ...
 - Each text file should contain one full sentence.
 - Do NOT include any punctuation marks such as a period ('.') or a comma (',') in the text file.
 - Sentences should be written in Korean letters.
 - Remove every white space (or tab) in the end of the line.
 - Recommendations for better performance:
	 - Less usage of white spaces between characters is strongly recommended.
	 - Apply word spacing in transcription mostly according to the way the speaker reads. Strict compliance with prescriptive spacing rules is not recommended.
	 - i.e. Put a whitespace when a pause is present.
		- ex) If a speaker reads: "나는 그시절 사람들과 사는것이 좋았어요"
		   - Bad example: 나는 그 시절 사람들과 사는 것이 좋았어요
		   - Good example: 나는 그시절 사람들과 사는것이 좋았어요

### DIRECTION

1. Navigate to 'Korean_FA' directory.
2. Open forced_align.sh with any text editor to specify user path of kaldi directory.
 - Change 'kaldi' name variable. (initial setting: kaldi=/home/kaldi)
3. Run the code with the path of data to forced-align.
 - ex) $ sh forced_align.sh (options) (data directory)
 -     $ sh forced_align.sh -nw ./example/readspeech
 - Options:
	 1) -h  | --help    : Showing instruction.
	 2) -nw | --no-word : Deleting word tier.
	 3) -np | --no-phone: Deleting phone tier.

4. Textgrid(s) will be saved into data directoy.

### NOTICE

1. Do not copy or use audio files in the example directory for other purposes. However deleting them is allowed.
2. Report bugs or provide any recommendation to us through the following email addresses.

### CONTRIBUTORS
---
# In order to improve forced alignment performance, all linguistics named below participate in this project.

# Students
Hyungwon Yang / hyung8758@gmail.com
Jaekoo Kang / jaekoo.jk@gmail.com
Yejin Cho / scarletcho@korea.ac.kr
Yeonjung Hong / yvonne.yj.hong@gmail.com
Youngsun Cho / youngsunhere@gmail.com
Sung Hah Hwang / hshsun@gmail.com

# Advisor
Hosung Nam / hnam@korea.ac.kr


### VERSION HISTORY

- v.1.0(08/27/16): gmm, sgmm_mmi, and dnn based Korean FA is released.
- v.1.1(09/06/16): g2p updated. monophone model is added.
- v.1.2(10/10/16): phoneset is simplified. Choosing model such as dnn or gmm for forced alignment is no longer available. 
- v.1.3(10/24/16): Selecting specific labels in TextGrid is available. Procedure of alignment is changed. Audio files collected in the directory will be aligned one by one. Due to this change, alignment takes more time, but its accuracy is increased. Log directory will show the alignment process in detail. More useful information is provided during alignment on the command line. 
- v.1.4(01.14.16): It will catch more errors. The name of log files will be tagged with respect to each wave file name. 
- v.1.5(02.08.17): Main g2p was changed and it is now compatible with the new g2p system. Skipping option is added and it will skip alignment of audio files that have TextGrdis. A few minor bugs are fixed.
 - v.1.5.1(02.26.17): bug reports. Time mismatch in the word tier. fixed.

