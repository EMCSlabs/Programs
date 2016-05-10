'''
utils for asr and interpreter scripts.


                                                                    Written by Hyungwon Yang
                                                                                2016. 05. 02
                                                                                   EMCS Labs
'''

import warnings
import requests
import random
import os
import time

# Internet connection check

# Internet connection check.
def internet_check():

    try:
        requests.get("http://www.google.com", timeout=3)
    except IOError:
        print('\n Internet is not connected. Please connect the internet first.')
        os.system('say Internet is not connected. Please check the internet connection and try again.')
        return False

# Typical Sentence

def sentence_generation(type,):
    rand_num = random.randint(1,3)
    if type == 'hello':
        if rand_num == 1:
            gretting = 'say hello; say howcan I help you?'
        elif rand_num == 2:
            gretting = 'say good morning; say whatcan I do for you today'
        elif rand_num == 3:
            gretting = 'say hi; say please let me know what I have to do for you'

        return gretting

    if type == 'finding':
        finding = 'say finding <place>'
        return finding

    if type == 'searching':
        searching = 'say searching <place>'
        return searching



# NLG format

def NLG_transoformation(type):

    # request type: FIND
    if type == 'find':
        find_location = 'The closest <place> is located in <address> and the phone number is <phone>'
        return find_location

    # request type: SEARCH
    if type == 'search':
        search_weather = 'Today''s weather in <location> is <weather>'
        return  search_weather


def KORtoENG(code):

    words = code.split()
    # 임시방편이다. 한글 각 글자별로 지정하여 변경 가능하며 (코퍼스 데이터 있음) 그걸 가지고 있을경우 거의 대부분의 한글을 노가다 없이 영어표기변환이 가능하다.
    # http://blog.daum.net/_blog/BlogTypeView.do?blogid=07UlC&articleno=15894497 <  이곳에서 가져 오자.
    '''
    word_list = {'가','ga','각','간','갈','감','갑','갓','강','개','객',
                '거','건','걸','검','겁','게','겨','격','견','결',
                '겸','겹','경','계','고','곡','곤','골','곳','공',
                '곶','과','곽','관','괄','광','괘','괴','굉','교',
                '구','국','군','굴','굿','궁','권','궐','귀','규',
                '균','귤','그','극','근','글','금','급','긍','기',
                '긴','길','김','까','깨','꼬','꼭','꽃','꾀','꾸',
                '꿈','끝','끼',

                '나','낙','난','날','남','납','낭','내','냉','너','널','네',
                '녀','녁','년','념','녕','노','녹','논','놀','농',
                '뇌','누','눈','눌','느','늑','늠','능','늬','니',
                '닉','닌','닐','님',

                '다','단','달','담','답','당','대','댁','더','덕','도',
                '독','돈','돌','동','돼','되','된','두','둑','둔',
                '뒤','드','득','들','등','디','따','땅','때','또',
                '뚜','뚝','뜨','띠',

                '라','락','란','람','랑','래','랭','량','렁','레','려',
                '력','련','렬','렴','렵','령','례','로','록','론',
                '롱','뢰','료','룡','루','류','륙','료','률','륭',
                '르','륵','른','름','릉','리','린','림','립',

                '마','막','만','말','망','매','맥','맨','맹','머','먹',
                '메','며','멱','면','멸','명','모','목','몰','못',
                '몽','뫼','묘','무','믁','문','물','므','미','민','밀'

                '바','박','반','발','밥','방','배','백','뱀',
                '버','번','벌','범','법','벼','벽','변','별','병',
                '보','복','본','봉','부','북','분','불','붕','비',
                '빈','빌','빔','빙','빠','빼','뻐','뽀','뿌','쁘','삐',

                '사','삭','산','살','삼','삽','상','샅','새',
                '색','생','서','석','선','설','섬','섭','성','세',
                '셔','소','속','손','솔','솟','송','쇄','쇠','수',
                '숙','순','술','숨','숭','쉬','스','슬','슴','습',
                '승','시','식','신','실','심','십','싱','싸','쌍',
                '쌔','쏘','쑥','씨',

                '아','악','안','알','암','압','앙','앞','애','액','앵',
                '야','약','얀','양','어','억','언','얼','엄','업',
                '에','여','역','연','열','염','엽','영','예','오',
                '옥','온','올','옴','옹'}
    '''
    word_list = {'서울':'seoul','성북구':'sung book gu','인촌로':'in chon lo','73':'73'}
    restore = []
    for chunk in words:
        if isinstance(chunk,str):
            word_index = list(word_list.keys()).index(chunk)
            restore.append(list(word_list.values())[word_index])

    return restore


######### For interpreter.py #########

def inter_setting():

    source_ask = 'say -v samantha What is your source language'
    target_ask = 'say -v samantha What is your target language.'
    confirm_ask = {'ko':'say -v yuna 소스 언어는 <source> 이며, 타겟 언어는 <target> 입니다, 번역언어 설정이 완료 되었습니다',
                  'en':'say -v samantha The source language is <source>, and target language is <target>, language setting is completed'}
    return source_ask,target_ask,confirm_ask

def language_form():
    lang_form ={'korean':'ko','english':'en','Korean':'ko','English':'en'}
    return lang_form

def translate_lang_form():
    lang_form ={'ko':'ko','en':'en-US'}
    return lang_form


class Interpreter_contents(object):

    def __init__(self,source_lang,target_lang):
        self.source = source_lang
        self.target = target_lang

    def inter_first(self):
        text = {'ko':'say -v yuna 번역하고자하는 문장을 말해주세요.',
                'en':'say -v samantha please say a sentence that needs to be translated'}
        return text[self.source]

    def inter_second(self):
        text = {'ko':'say -v yuna 다음과 같이 말씀하셨습니다; say -v yuna ',
                'en':'say -v samantha The sentence you have mentioned is;say -v daniel '}
        return text[self.source]

    def inter_third(self):
        text = {'ko':'say -v yuna 번역이 완료되었습니다.',
                'en':'say -v samantha translation is completed'}
        return text[self.source]

    def inter_fourth(self):
        text = {'ko': 'say -v yuna ',
                'en': 'say -v samantha '}
        return text[self.target]

    def inter_end(self):
        text = {'ko':'say -v yuna 번역 매니저를 종료합니다, 감사합니다',
                'en':'say -v samantha Terminating translate manager, Thank you.'}
        return text[self.source]

    def inter_continue(self):
        text = {'ko': 'say -v yuna 잠시 후, 동시 번역 상태로 전환합니다. 원치않으실 경우, 시스템을 종료해주시기 바랍니다',
                'en': 'say -v samantha automatic translation will be activated in a few second, please turn off the system if you dont want to proceed'}
        return text[self.source]
