#!/bin/bash
#
# Copyright 2016 Media Zen & 
#				 Korea University (author: Hyungwon Yang) v1.5.2
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# *** INTRODUCTION ***
# This is the forced alignment toolkit developed by EMCS labs.
# Run this script in the folder in which force_align.sh presented.
# It means that the user needs to nevigate to this folder in linux or
# mac OSX terminal and then run this script. Otherwise this script
# won't work properly.
# Do not move the parts of scripts or folders or run the main script
# from outside of this folder.

# Kaldi directory ./kaldi
kaldi=/Users/hyungwonyang/kaldi
# Model directory
fa_model=model4fa
# lexicon directory
dict_dir=main/data/local/dict
# language directory
lang_dir=main/data/lang
# FA data directory
data_dir=
trans_dir=main/data/trans_data
# align data directory
ali_dir=fa_dir
# result direcotry
result_dir=tmp/result
# Code directory
code_dir=main/local/core
# log directory
log_dir=tmp/log
# Number of jobs(just fix it to one)
mfcc_nj=1
align_nj=1
passing=0
align_error=0
fail_num=0

# Check kaldi directory.
if [ ! -d $kaldi ]; then
	echo -e "ERROR: Kaldi directory is not found. Please reset the kaldi directory by editing force_align.sh.\nCurrent kaldi directory : $kaldi" && exit 1
fi

# Option Parsing and checking. 
# Option default.
tg_word_opt=
tg_phone_opt=
tg_skip_opt=
usage="=======================================================\n\
\t         The Usage of Korean Foreced Aligner.         \n\
=======================================================\n\
\t*** OPTION ARGUMENT ***\n\
-h  | --help    : Print the direction.\n\
-s  | --skip    : This option excludes wave data from alignment which already have TextGrid files.\n\
-nw | --no-word : This opiton excludes word label from TextGrid.\n\
-np | --no-phone: This option excludes phone label from TextGrid.\n\
\t*** INPUT ARGUMENT ***\n\
File directory. ex) example/my_record\n\n\
\t*** USAGE ***\n\
bash forced_align.sh [option] [data directory]\n\
bash forced_align.sh -np example/my_record\n"

if [ $# -gt 3 ] || [ $# -lt 1 ]; then
   echo -e $usage  && exit
fi

arg_num=$#
while [ $arg_num -gt 0 ] ; do 
  case "$1" in
    -h) echo -e $usage && exit; break ;;
	-s) tg_skip_opt="--skip"; shift; arg_num=$((arg_num-1)) ;;
    -nw) tg_word_opt="--no-word"; shift; arg_num=$((arg_num-1)) ;;
    -np) tg_phone_opt="--no-phone"; shift; arg_num=$((arg_num-1)) ;;

    --help) echo -e $usage && exit; break ;;
	--skip) tg_skip_opt="--skip"; shift; arg_num=$((arg_num-1)) ;;
    --no-word) tg_word_opt="--no-word"; shift; arg_num=$((arg_num-1)) ;; 
    --no-phone) tg_phone_opt="--no-phone"; shift; arg_num=$((arg_num-1)) ;;
    -*) echo -e "*** UNKNOWN OPTION: $1 ***\n"$usage ; exit  ;;
    --*) echo -e "*** UNKNOWN OPTION: $1 ***\n"$usage ; exit ;;
	*) break ;;
  esac
done

# Folder directory that contains wav and text files.
tmp_data_dir=$1
if [ "$tmp_data_dir" == "" ]; then
	echo "ERROR: data directory is not provided." && exit
fi

# Check data_dir
alias realpath="perl -MCwd -e 'print Cwd::realpath(\$ARGV[0]),qq<\n>'"
data_dir=`realpath $tmp_data_dir`
if [ ! -d $data_dir ]; then
	echo "ERROR: $data_dir is not present. Please check the data directory."  && exit
fi

# Remove previous log, tmp, and data directories.
[ -d log ] && rm -rf log
[ -d tmp ] && rm -rf tmp
[ -d main/data ] && rm -rf main/data

# Directory check.
source path.sh $kaldi
[ ! -d tmp ] && mkdir -p tmp
[ ! -d main/data/local/dict ] && mkdir -p main/data/local/dict
[ ! -d main/data/source_wav ] && mkdir -p main/data/source_wav
[ ! -d main/data/lang ] && mkdir -p main/data/lang
[ ! -d main/data/trans_data ] && mkdir -p $trans_dir
[ ! -d tmp/model_ali ] && mkdir -p tmp/model_ali
[ ! -d tmp/log ] && mkdir -p tmp/log

# Check the text files. 
wav_list=
txt_list=
wav_num=
txt_num=
python main/local/check_text.py $tg_skip_opt $data_dir || exit 1
if [ "$tg_skip_opt" == "--skip" ]; then
	echo -e "Skipping option is activated.\nWave data which already have TextGrid files will be excluded from alignment list."
	# Wave file which has a textgrid will not be aligned.
	# Check wave file list and select files that have not textgrids.
	tmp_wav_list=`ls $data_dir | grep .wav`
	tmp_txt_list=`ls $data_dir | grep .txt`
	for wav in $tmp_wav_list; do
		tmp_wav=`echo $wav | sed "s/.wav//g"`
		if [ ! -f $data_dir/$tmp_wav.TextGrid ] && [ -f $data_dir/$tmp_wav.txt ]; then
			wav_list+="$tmp_wav.wav "
			txt_list+="$tmp_wav.txt "
		fi
	done
	wav_num=`echo $wav_list | wc -w`
	txt_num=`echo $txt_list | wc -w`
	if [ $wav_num -eq 0 ]; then 
		echo -e "No file is remained to be aligned.\nExit alignment." && exit
	fi
else
	wav_list=`ls $data_dir | grep .wav `
	wav_num=`echo $wav_list | tr ' ' '\n' | wc -l`
	txt_list=`ls $data_dir | grep .txt `
	txt_num=`echo $txt_list | tr ' ' '\n' | wc -l`
	if [ $wav_num -eq 0 ]; then 
		echo -e "No file is remained to be aligned.\nExit alignment." && exit
	fi
fi

# Check if each audio file has a matching text file.
if [ $wav_num != $txt_num ]; then
	echo "ERROR: The number of audio and text files are not matched. Please check the input data." 
	echo "Audio list: "$wav_list
	echo "Text  list: "$txt_list && exit
fi

echo ===================================================================
echo "                    Korean Forced Aligner                        "    
echo ===================================================================
echo The number of audio files: $wav_num
echo The number of text  files: $txt_num

# Main loop for alignment.
for turn in `seq 1 $wav_num`; do
	mkdir -p main/data/source_wav/source$turn
	mkdir -p $trans_dir/trans$turn
	sel_wav=`echo $wav_list | tr ' ' '\n' | sed -n ${turn}p`
	sel_txt=`echo $txt_list | tr ' ' '\n' | sed -n ${turn}p`
	log_name=`echo $sel_wav | sed -e "s/.wav//g"`

	source_dir=$PWD/main/data/source_wav/source$turn
	echo Alinging: $sel_wav '('$turn /$wav_num')'
	cp $data_dir/$sel_wav $source_dir
	cp $data_dir/$sel_txt $source_dir
	echo "Procedure: $turn " > $log_dir/process.$log_name.log
	echo "Audio: $data_dir/$sel_wav, Text: $data_dir/$sel_txt." >> $log_dir/process.$log_name.log

	python main/local/fa_prep_data.py $source_dir $trans_dir/trans$turn >> $log_dir/process.$log_name.log || exit 1
	$code_dir/utt2spk_to_spk2utt.pl $trans_dir/trans$turn/utt2spk > $trans_dir/trans$turn/spk2utt 
	echo "spk2utt file was generated." >> $log_dir/process.$log_name.log

	# Generate raw sentence text file.
	[ ! -d tmp/raw_sent ] && mkdir -p tmp/raw_sent
	words=`cat $source_dir/$sel_txt`
	txt_rename=`echo $sel_txt | sed -e "s/txt/raw/g"`
	echo "$words" | tr ' ' '\n' > tmp/raw_sent/$txt_rename
	echo "raw_sentence: " >> $log_dir/process.$log_name.log
	cat tmp/raw_sent/$txt_rename >> $log_dir/process.$log_name.log

	## For Generating new_lexicon file.
	# Set prono directories.
	[ ! -d tmp/prono ] && mkdir -p tmp/prono
	[ -f tmp/prono/new_lexicon.txt ] && rm tmp/prono/new_lexicon.txt

	# g2p conversion.
	for div in $words; do
		python main/local/g2p.py $div >> tmp/prono/prono_list
	done
	paste -d' ' tmp/raw_sent/$txt_rename tmp/prono/prono_list >> tmp/prono/new_lexicon.txt
	echo "Lexicon: " >> $log_dir/process.$log_name.log
	cat tmp/prono/new_lexicon.txt >> $log_dir/process.$log_name.log

	## Language modeling.
	# Combine new_lexicon to lexicon file in order to make an appropriate language model.
	paste -d'\n' tmp/prono/new_lexicon.txt model/lexicon.txt | sort | uniq | sed '/^\s*$/d' > $dict_dir/lexicon.txt
	bash main/local/prepare_new_lang.sh $dict_dir $lang_dir "<UNK>" >/dev/null

	## Feature extraction.
	# MFCC default setting.
	echo "Extracting the features from the input data." >> $log_dir/process.$log_name.log
	mfccdir=mfcc
	cmd="$code_dir/run.pl"

	# Wav file sanitiy check.
	# Audio file should have only 1 channel.
	wav_ch=`sox --i $source_dir/$sel_wav | grep "Channels" | awk '{print $3}'`
	if [ $wav_ch -ne 1 ]; then
		sox $source_dir/$sel_wav -c 1 $source_dir/ch_tmp.wav
		mv $source_dir/ch_tmp.wav $source_dir/$sel_wav; fi
		echo "$sel_wav channel changed." >> $log_dir/process.$log_name.log
	# Sampling rate should be set to 16000.
	wav_sr=`sox --i $source_dir/$sel_wav | grep "Sample Rate" | awk '{print $4}'`
	if [ $wav_sr -ne 16000 ]; then
		sox $source_dir/$sel_wav -r 16000 $source_dir/sr_tmp.wav
		echo "$sel_wav sampling rate changed." >> $log_dir/process.$log_name.log
		mv $source_dir/sr_tmp.wav $source_dir/$sel_wav; fi

	# Extracting MFCC features and calculate CMVN.
	$code_dir/make_mfcc.sh --nj $mfcc_nj --cmd "$cmd" $trans_dir/trans$turn $log_dir tmp/$mfccdir >> $log_dir/process.$log_name.log
	$code_dir/fix_data_dir.sh $trans_dir/trans$turn >> $log_dir/process.$log_name.log
	$code_dir/compute_cmvn_stats.sh $trans_dir/trans$turn $log_dir tmp/$mfccdir >> $log_dir/process.$log_name.log
	$code_dir/fix_data_dir.sh $trans_dir/trans$turn >> $log_dir/process.$log_name.log
	
	## Forced alignment.
	# Aligning data. Total 4 trials will be executed to align every audio file. Smaller parameter setting will give the best result 
	# but some audio file cannot be aligned with the smaller setting. After 4 trials the audio file will be rejected to be aligned 
	# because larger than the 4th parameter setting would not give a adequate result which means that the result cannot be credible.
	echo "Force aligning the input data." >> $log_dir/process.$log_name.log
	for pass in 1 2 3 4; do
		if [ $pass == 1 ]; then
			beam=10
			retry_beam=40
		elif [ $pass == 2 ]; then
			beam=50
			retry_beam=60
		elif [ $pass == 3 ]; then
			beam=70
			retry_beam=80;
		elif [ $pass == 4 ]; then
			beam=90
			retry_beam=100; 
		fi

		# Alignement.
		$code_dir/align_si.sh --nj $align_nj --cmd "$cmd" \
							$trans_dir/trans$turn \
							$lang_dir \
							model/$fa_model \
							tmp/model_ali \
							$beam \
							$retry_beam \
							$log_name >> $log_dir/process.$log_name.log 2>/dev/null

		# Sanity check.
		# If error occurred, stop alignment right away.
		if [ $pass == 1 ]; then
			error_check=`cat tmp/log/align.$log_name.log | grep "ERROR" | wc -l`
			if [ $error_check != 0 ]; then
				echo -e "Fail Alignment: ERROR has been detected during alignment.\n" | tee -a $log_dir/process.$log_name.log
				fail_num=$((fail_num+1))
				passing=1
				break
			fi
		fi

		# Check the alignemnt result.
		align_check=`cat tmp/log/align.$log_name.log | grep "Did not successfully decode file" | wc -l`
		if [ $align_check == 0 ]; then
			break
		elif [ $align_check == 0 ] && [ $pass == 4 ]; then
			echo "WARNNING: $sel_wav was difficult to align, the result might be unsatisfactory." | tee -a $log_dir/process.$log_name.log
		elif [ $align_check != 0 ] && [ $pass == 4 ]; then
			echo -e "Fail Alignment: $sel_wav might be corrupted.\n" | tee -a $log_dir/process.$log_name.log
			fail_num=$((fail_num+1))
			passing=1
		fi
	done

	## Generating textgrid file.
	# If the error has not been occurred during alginment, textgrid with respect to audio file will be generated. Otherwise this step will be skipped.
	if [ $passing -ne 1 ]; then
		
		# CTM file conversion.
		[ ! -d $result_dir ] && mkdir -p $result_dir
		$kaldi/src/bin/ali-to-phones --ctm-output model/$fa_model/final.mdl ark:"gunzip -c tmp/model_ali/ali.1.gz|" - > tmp/model_ali/raw_ali.ctm
		echo "ctm result: " >> $log_dir/process.$log_name.log
		cat tmp/model_ali/raw_ali.ctm >> $log_dir/process.$log_name.log

		# Move requisite files.
		cp tmp/model_ali/raw_ali.ctm $result_dir/raw_ali.txt
		cp main/data/lang/phones.txt $result_dir
		cp $trans_dir/trans$turn/segments $result_dir

		# id to phone conversion.
		echo "Reconstructing the alinged data." >> $log_dir/process.$log_name.log
		python main/local/id2phone.py $result_dir/phones.txt \
									   $result_dir/segments \
									   $result_dir/raw_ali.txt \
									   $result_dir/final_ali.txt >> $log_dir/process.$log_name.log || exit 1;
		echo "final_ali result: " >> $log_dir/process.$log_name.log
		cat $result_dir/final_ali.txt >> $log_dir/process.$log_name.log

		# Split the whole text files.
		echo "Inserting labels for each column in the aligned data." >> $log_dir/process.$log_name.log
		mkdir -p $result_dir/tmp_fa
		int_line="utt_id\tfile_id\tphone_id\tutt_num\tstart_ph\tdur_ph\tphone\tstart_utt\tend_utt\tstart_real\tend_real"
		cat $result_dir/final_ali.txt | sed '1i '"${int_line}" > $result_dir/tmp_fa/tagged_final_ali.txt

		# Generate text_num file.
		cat tmp/raw_sent/$txt_rename | wc -l >> tmp/raw_sent/text_num.raw || exit 1;

		# Generate Textgrid files and save it to the data directory.
		echo "Organizing the aligned data to textgrid format." >> $log_dir/process.$log_name.log
		# Generate textgrid.
		python main/local/generate_textgrid.py $tg_word_opt $tg_phone_opt \
								$result_dir/tmp_fa \
								tmp/prono/new_lexicon.txt \
								tmp/raw_sent/text_num.raw \
								$source_dir 2>/dev/null || align_error=1;
		if [ $align_error -eq 1 ]; then
			echo -e "Fail Result Composition: $sel_wav might be corrupted.\n" | tee -a $log_dir/process.$log_name.log
			fail_num=$((fail_num+1))
			align_error=0
		else
			echo -e "$sel_wav was successfully aligned.\n" | tee -a $log_dir/process.$log_name.log
			tg_name=`echo $sel_txt | sed 's/.txt//g'`
			mv $source_dir/tagged_final_ali.TextGrid $data_dir/$tg_name.TextGrid
		fi
	fi

	passing=0
	rm -rf tmp/{mfcc,model_ali,prono,result,raw_sent}/*
	rm -rf $source_dir
done


# Print result information.
echo "===================== FORCED ALIGNMENT FINISHED  =====================" | tee -a $log_dir/process.$log_name.log
echo "** Result Information on $(date) **									" | tee -a $log_dir/process.$log_name.log
echo "Total Trials:" $wav_num									        	  | tee -a $log_dir/process.$log_name.log
echo "Success     :" $((wav_num - fail_num))								  | tee -a $log_dir/process.$log_name.log
echo "Fail        :" $fail_num												  | tee -a $log_dir/process.$log_name.log
echo "----------------------------------------------------------------------" | tee -a $log_dir/process.$log_name.log
echo "Result      : $((wav_num - fail_num)) / $wav_num (Success / Total)"	  | tee -a $log_dir/process.$log_name.log
if [ $fail_num -gt 0 ]; then 
echo "To check the failed results, refer to the ./log directory."; fi
echo


# Collect log files.
mkdir tmp/log/align_log tmp/log/feature_log tmp/log/process_log
mv tmp/log/align.* tmp/log/align_log
mv tmp/log/{cmvn,make_mfcc}_* tmp/log/feature_log
mv tmp/log/process.* tmp/log/process_log

# Redirect log directory and remove a tmp directory.
mv tmp/log .
rm -rf tmp main/data
