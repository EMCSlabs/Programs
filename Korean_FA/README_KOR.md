# Korean_FA: 한국어 강제정렬 시스템
                                                    Hyungwon Yang
                                                    Jaekoo Kang
                                                    Yejin Cho
                                                    
                                                    2016.10.20
                                                    EMCS Labs

### MacOSX and Linux
----------------------------------------------------------------
Mac OS X (El Capitan 10.11.6): 안정성 테스트 완료.

Linux (Ubuntu 14.04): 안정성 테스트 완료.

Bash
Python 3.5
(그 외 다른 버전에서는 테스트되지 않음.)


### PRE-REQUISITE (준비사항)
1. **Kaldi 설치**
 - 터미널에 다음과 같이 입력하면 Kaldi ASR Toolkit 을 다운로드 받을 수 있다.
	 - $ git clone https://github.com/kaldi-asr/kaldi.git kaldi --origin upstream
   	 - $ cd kaldi
   	 - $ git pull 
 - INSTALL 문서를 읽어보고, 지시에 따라 설치를 완료한다.

2. **SoX, xlrd, coreutils 설치**
 -  Mac 사용자는 터미널에 다음과 같이 입력해 SoX, xlrd, coreutils 를 설치한다.
 	 - $ brew install sox
 	 - $ pip3 install xlrd (Make sure to install xlrd into python3 library not in python2. If you use anaconda then you have to install it in there. Otherwise, install it into a proper directory.)
     - $ brew install coreutils


### MATERIALS (데이터 준비)
1. **음성 파일 (.wav)** (of sampling rate at 16,000Hz)
 - 음성 파일은 샘플링 주기가 16,000Hz인 WAV 파일(.wav)의 형태로 준비한다.
2. **텍스트 파일 (.txt)**
 - 음성을 받아적은 전사 텍스트(.txt)는 파일명에 순차적으로 번호를 매긴 형태로 준비한다.
 - ex) name01.txt, name02.txt, ...
 - 각 텍스트 파일은 하나의 문장을 포함한다.
 - 구두점 및 문장부호는 포함하지 않아야 한다.
 - 모든 텍스트는 한글로 적혀야 한다.
 - 텍스트 각 라인의 마지막에 공백이나 탭이 남아있지 않도록 한다.
 - 보다 나은 강제정렬 성능을 위한 고려사항들은 다음과 같다.
	 - 띄어쓰기는 가능한 한 적게 사용하는 것이 좋다.
	 - 문법적인 띄어쓰기 규칙을 엄격하게 지키기보다, 화자가 발화 중 휴지(pause)를 넣은 곳에 띄어쓰기를 적용하는 것이 좋다.
		- ex) 음성: "나는 그시절 사람들과 사는것이 좋았어요"
		   - 나쁜 예: 나는 그 시절 사람들과 사는 것이 좋았어요 (띄어쓰기 규칙 준수)
		   - 좋은 예: 나는 그시절 사람들과 사는것이 좋았어요 (화자의 휴지 패턴을 따라 전사)

### DIRECTION (사용법)

1. 터미널에서 'Korean_FA' 디렉토리로 접근한다.
2. 'forced_align.sh'을 열어 사용자의 kaldi 경로를 수정한다.
 - 쉘 스크립트 내 'kaldi' 변수에 사용자의 kaldi 경로를 할당한다. (기본 경로: kaldi=/home/kaldi)
3. 강제정렬하려는 데이터의 경로와 함께 'forced_align.sh' 코드를 실행한다.
 - ex) $ forced_align.sh ./example/readspeech
 -     $ (Main code: forced_align.sh) (입력 데이터가 위치한 폴더의 상대 경로)
4. 기본적으로 음소와 어절 단위의 레이블 표기가 동시에 제공되며, 다음의 옵션을 통해 특정 레이블만 텍스트그리드에 
    표기하도록 설정할 수 있다.
 - -h  | --help    : 코드 및 옵션사용에 대한 정보를 제공한다.
 - -nw | --no-word : 어절 단위의 표기를 생략한다. 
 - -np | --no-phone: 음소 단위의 표기를 생략한다.
4. 강제정렬이 끝나면 입력 데이터 폴더에 자소 단위로 분절된 텍스트그리드(.TextGrid)가 생성된다.
 - 텍스트그리드(.TextGrid)는 Praat 프로그램을 통해 열어볼 수 있다.
 - Praat: http://www.fon.hum.uva.nl/praat/


### CONTACTS (연락처)
---
본 프로그램에 문제가 발견되거나 제안할 내용이 있으면 다음 주소로 연락 주시기 바랍니다.


Hyungwon Yang / hyung8758@gmail.com
Jaekoo Kang / jaekoo.jk@gmail.com
Yejin Cho / scarletcho@korea.ac.kr

Hosung Nam / hnam@korea.ac.kr


### VERSION HISTORY
- v.1.0(08/27/16): gmm, sgmm_mmi, and dnn based Korean FA is released.
- v.1.1(09/06/16): g2p updated. monophone model is added.
- v.1.2(10/10/16): phoneset is simplified. Choosing model such as dnn or gmm for forced alignment is no longer available. 
- v.1.3(10/24/16): Selecting specific labels in TextGrid is available. Procedure of alignment is changed. Audio files collected in the directory will be aligned one by one. Due to this change, alignment takes more time, but its accuracy is increased. Log directory will show the alignment process in detail. More useful information is provided during alignment on the command line. 

