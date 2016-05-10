'''
Language to language translator.


                                                                    Written by Hyungwon Yang
                                                                                2016. 05. 02
                                                                                   EMCS Labs
'''

import os
import re
import speech_recognition as sr
import requests
import time

from util import *

##### Google API Key Number is Required #####
key_number = 'AIzaSyB52DQtWqssMqJ3ORlQzA_MveJlRU5WRBM'
#############################################

# Error check needs to be added.
# 1. api key validity check
# 2. package installation check
# 3. computer os check(it needs to be mac)
# 4. tts check. samantha and yuna should be installed.
# problems 3 and 4 will be solved if tts can be accessed through api.
# 5. The most important questions are... how to improve accuracy and rapidity

def sort_out(dict, key, *keys):
    if keys:
        return sort_out(dict.get(key, {}), *keys)
    return dict.get(key)

# Internet check
A = internet_check()
if A is False:
    raise ConnectionError

### get the interpreted sentence.
def translator_manager():

    recorder = sr.Recognizer()
    ### Language selection ###
    os.system('say -v samantha Hello, this is translate manager, please answer the following questions in order to set the language options')
    source, target, confirm = inter_setting()
    with sr.Microphone() as mike:
        os.system(source)
        source_sound = recorder.listen(mike)
    source_lang = recorder.recognize_google(source_sound)
    print('source language: ' + source_lang)

    with sr.Microphone() as mike:
        os.system(target)
        target_sound = recorder.listen(mike)
    target_lang = recorder.recognize_google(target_sound)
    print('target language: ' + target_lang)

    # Parameter setting.
    lang_form = language_form()
    source_idx = list(lang_form.keys()).index(source_lang)
    target_idx = list(lang_form.keys()).index(target_lang)

    S = list(lang_form.values())[source_idx]
    T = list(lang_form.values())[target_idx]

    translate_form = translate_lang_form()
    lang_opt = translate_form[S]


    confirm_text = confirm[S]
    setting_text = re.sub('<source>',source_lang,confirm_text)
    setting_text = re.sub('<target>',target_lang,setting_text)
    os.system(setting_text)


    ### Start translation.
    ic = Interpreter_contents(S,T)
    # Get the sound
    recorder = sr.Recognizer()
    with sr.Microphone() as mike:
        print('Please speaking.')
        os.system(ic.inter_first())
        my_sound = recorder.listen(mike)

    print('Processing...')

    tmp_words = recorder.recognize_google(my_sound,language=lang_opt)
    os.system(ic.inter_second() + tmp_words)

    ### Language translation.
    int_url = 'https://www.googleapis.com/language/translate/v2?'
    param = {'key':key_number,'q':tmp_words,'source':S,'target':T}
    # Get the translated sentence.
    get_response = requests.get(int_url,param)
    contents = get_response.content.decode('utf-8')

    # Extract the only source data.
    dict_contents = eval(contents)
    covered_sent = sort_out(dict_contents,'data','translations')
    source_sent = sort_out(covered_sent[0],'translatedText')

    # TTS
    os.system(ic.inter_third())
    os.system(ic.inter_fourth() + source_sent)

    os.system(ic.inter_end())

    '''
    ### First round is finished. keep continue or quit? ###
    os.system(ic.inter_continue())
    time.sleep(3)
    '''

if __name__ == '__main__':
    translator_manager()
