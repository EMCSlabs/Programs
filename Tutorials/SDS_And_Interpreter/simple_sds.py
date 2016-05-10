'''
This is demo version: SDS preparation.
Find closest starbucks or coffee bean and check today's weather.
1. Run the script.
2. say 'find me starbucks'

                                                              Hyungwon Yang
                                                                 2015.04.14
                                                                   EMCS lab
Spoken Dialogue System (SDS) overview

SDS procedure
1. ASR (Automatic Speech Recognition)
2. SLU (Spoken Language Understanding)
3. DM  (Dialogue Manage)
4. NLG (Natural Language Generation)
5. TTS (Text to Speech)

This is only runnable in python 3.

Reference
1. ASR

2. SLU
    http://www.nltk.org/api/nltk.classify.html?highlight=decisiontree#nltk.classify.decisiontree.DecisionTreeClassifier
    http://www.nltk.org/howto/parse.html
    http://www.nltk.org/book/

3. DM

4. NLG
    http://streamhacker.com/
    http://resources.narrativescience.com/h/i/124944227-what-is-natural-language-generation
    https://books.google.co.kr/books?id=PC5nBAAAQBAJ&dq=dialogue+manager+python&hl=ko&source=gbs_navlinks_s
5. TTS
    http://www.ispeech.org/text.to.speech
    https://pypi.python.org/pypi/gTTS/1.0.2 > blocked. cannot test.
    https://pypi.python.org/pypi/pyttsx > Not Good.

## Add what?
# speaker recognition
# language recognition

'''

import re
import speech_recognition as sr
import requests
import nltk


from nltk import word_tokenize
from nltk import Nonterminal, nonterminals, Production, CFG
from nltk.parse import RecursiveDescentParser
from bs4 import BeautifulSoup

from util import *


# Check list.

A = internet_check()
if A is False:
    raise ConnectionError


# Step1. ASR
# Use recognizer to record the speech.
recorder = sr.Recognizer()
starting = sentence_generation('hello')
with sr.Microphone() as mike:
    print('Hello. Please speaking.')
    os.system(starting)
    my_sound = recorder.listen(mike)

print('Processing...')

# Speech signal to text. Supported by google Speech api: Internet needs to be connected.
tmp_words = recorder.recognize_google(my_sound)
words = str(tmp_words)

# test printing...
print(words)

# Step2. SLU
# 1. find the specific places to users.
#words = 'show me starbucks'

# Tokenize the sentence.
tokenized = word_tokenize(words)

# Build the grammar for parsing.
GOAL_FIND,ENTITY_PLACE = nonterminals('GOAL_FIND,ENTITY_PLACE')
usr_goal = ENTITY_PLACE
usr_find = GOAL_FIND
VP,NP,O = nonterminals('VP,NP,O')

grammar = CFG.fromstring("""
VP -> GOAL_FIND O ENTITY_PLACE | GOAL_FIND ENTITY_PLACE
NP -> P ENTITY_PLACE | ENTITY_PLACE
GOAL_FIND -> 'find'
GOAL_FIND  -> 'show'
GOAL_FIND  -> 'tell'
O -> 'me'
P -> 'in'
ENTITY_PLACE -> 'starbucks'
ENTITY_PLACE -> 'Starbucks'
ENTITY_PLACE -> 'Coffee Bean'
ENTITY_PLACE -> 'Coffeebean'

""")
rd_parser = RecursiveDescentParser(grammar)

# Parsing the sentence.
parsed_words = []
for parsing in rd_parser.parse(tokenized):
    print(parsing)

# Find GOAL and ENTITY
for detect in parsing:
    if detect.label() == 'GOAL_FIND':
        usr_goal = detect.leaves()[0]
    if detect.label() == 'ENTITY_PLACE':
        usr_place = detect.leaves()[0]

finding = sentence_generation('finding')
finding = re.sub('<place>',usr_place,finding)
os.system(finding)

# 2. Provide weather information to users.

# Step3. DM
# Collect information from the internet.
# Location
google_url = "https://www.google.co.kr/?gfe_rd=cr&ei=8YoTV-OdF8WL8AWGp5DgDg&gws_rd=ssl#newwindow=1&q="
daum_url = 'http://search.daum.net/search?w=tot&DA=YZR&t__nil_searchbox=btn&sug=&sugo=&sq=&o=&q='

# Connect to the internet to proceed the users' request: goal and entity.
if usr_goal == 'find':
    # Searching in Daum.
    usr_request_url = daum_url + usr_place + '&tltm=1'
    request = requests.get(usr_request_url)
    soup = BeautifulSoup(request.content,'html.parser')

    # Searching in Google.
    #usr_request_url = google_url + usr_place
    #request = requests.get(usr_request_url)
    #soup = BeautifulSoup(request)

# Collect information.
# Find the closest 5 places around the location in which you start to request.
all_data = soup.find_all('div',{'class','cont_place'})

first_data = all_data[0]

# Address
address_info = all_data[0].find_all('a',{'class','more_address'})[0].text
# Phone Number
phone_info = all_data[0].find_all('span',{'class','f_url'})[0].text
# Location (map)
map_info = all_data[0].find('a').get('href')

# Weather



# Step4. NLG
# Generate an appropriate sentence.
answer_text = NLG_transoformation('find')

# Adjust the words if it is Korean.
address_info = ' '.join(KORtoENG(address_info))

# Substitude the markers to proper words
answer_text = re.sub('<place>',usr_place,answer_text)
answer_text = re.sub('<address>',address_info,answer_text)
answer_text = re.sub('<phone>',phone_info,answer_text)

# Step5. TTS
os.system('say ' + answer_text)



### reference and test section ###
'''
import nltk
from nltk.corpus import state_union
from nltk.tokenize import PunktSentenceTokenizer

train_text = state_union.raw('2005-GWBush.txt')
sample_text = state_union.raw('2006-GWBush.txt')

custom_tokenizer = PunktSentenceTokenizer(train_text)
tokenized = custom_tokenizer.tokenize(sample_text)

celling = []
for i in tokenized:
    words = nltk.word_tokenize(i)
    tagged = nltk.pos_tag(words)
    #print(tagged)
    name_ent = nltk.ne_chunk(tagged,binary=True)
    celling.append(name_ent)

os.system('say -v Samantha The closest place starbucks is located in; say -v Yuna 서울시 성북구 인촌로 72가; say -v Samantha and the phone number 02-333-8273')

'''