"""
evaluateFA.py
~~~~~~~~~~

This script evaluates a TextGrid (i.e. prediction; usually of forced alignment)
with regard to one reference TextGrid (i.e. target; usually human segmented).

 Input: 1) Name of .TextGrid file to evaluate (usually a forced alignment)
        2) Name of .TextGrid file to refer to (usually by human)
        3) Tolerance (ms) for accuracy calculation (default: 20 ms)

Output: 'evaluation.csv' with 5 columns (cf. first three columns filled with input arguments)
        1) Total Error (ms)
        2) Alignment Accuracy (%)
            = what percentage of the automatically labeled boundaries are within
            a given time tolerance (threshold) of the manually labeled boundaries.


Usage:  $ python evaluateFA.py fa.TextGrid human.TextGrid 30


Yejin Cho (scarletcho@gmail.com)
Last updated: 2016-11-09
"""

import sys,os
import re
import operator
import csv

def parseInput():
    textgrid_fa_fname = sys.argv[1]
    textgrid_target_fname = sys.argv[2]

    if len(sys.argv) < 4:
        tolerance_ms = 20   # default tolerance: 20 ms
    else:
        tolerance_ms = int(sys.argv[3])
    return textgrid_fa_fname, textgrid_target_fname, tolerance_ms


def extractAlignments(lines):
    intervaltier_idx = []
    for i in range(0, len(lines)):
        if re.search('IntervalTier', lines[i]):
            intervaltier_idx.append(i)
    ali_lines = lines[intervaltier_idx[0]+5:intervaltier_idx[1]]
    return ali_lines


def divideByType(lines):
    time_init=[]
    time_end=[]
    labels=[]

    for i in range(0, len(lines)):
        if (i+1) % 3 == 1:
            time_init.append(lines[i])
        if (i+1) % 3 == 2:
            time_end.append(lines[i])
        if (i+1) % 3 == 0:
            labels.append(lines[i])

    return time_init, time_end, labels


def getTimeEndNLabels(lines):
    # Extract lines containing alignment time & label info
    ali_lines = extractAlignments(lines)

    # Divide ali_lines into 'time_init', 'time_end', and 'labels'
    [time_init, time_end, labels] = divideByType(ali_lines)
    return time_end, labels


def identityCheck(labels_fa, labels_target, time_end_fa, time_end_target):
    # Check if two sets of labels match
    # (If not matched, show error messages and stop evaluation)
    if (labels_fa != labels_target) | (len(time_end_fa) != len(time_end_target)):
        print('[WARNING] Labels NOT matched! Evaluation may be unreliable.\n')
    else:
        print('Label matching is successfully done.\n')


def calculateError(time_end_fa, time_end_target):
    # Remove non-digits & Convert into floating point numbers
    for i in range(0, len(time_end_fa)):
        time_end_fa[i] = float(re.sub(r'[^0-9.]', '', time_end_fa[i])) * 1000
        time_end_target[i] = float(re.sub(r'[^0-9.]', '', time_end_target[i])) * 1000

    pattern = '%.2f'
    print('Boundary time (FA) in ms: ' + str([pattern % i for i in time_end_fa]))
    print('Boundary time (Target) in ms: ' + str([pattern % i for i in time_end_target]))

    # Compare two sets of time_end indices
    # Subtract 'time_end_fa' from 'time_end_target')
    error = list(map(operator.sub, time_end_fa, time_end_target))
    error_absolute = list(map(abs, error))
    error_sum = sum(error_absolute)
    print('\nTotal Error: ' + str(round(error_sum, 3)) + ' ms')
    return error_absolute, error_sum


def calculateAccPercent(error_absolute, tolerance_ms):
    within_thresh = 0
    for i in range(0, len(error_absolute)):
        if error_absolute[i] <= tolerance_ms:
            within_thresh += 1
    accuracy_percent = round(within_thresh / len(error_absolute) * 100, 2)
    print('Boundaries within the error tolerance: ' + str(accuracy_percent) +\
          ' %' + ' (tolerance: ' + str(tolerance_ms) + ' ms)')
    return accuracy_percent


def writeResult(error_sum, tolerance_ms, accuracy_percent):
    if not os.path.exists('./evaluation.csv'):
        with open('./evaluation.csv', 'w') as csvfile:
            fieldnames = ['fa_filename', 'target_filename', 'tolerance_ms', 'error_total_ms', 'accuracy_percent']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            writer.writeheader()
            writer.writerow({'fa_filename': textgrid_fa_fname,
                             'target_filename': textgrid_target_fname,
                             'tolerance_ms' : tolerance_ms,
                             'error_total_ms': error_sum,
                             'accuracy_percent': accuracy_percent})
    else:
        csvfile = open('./evaluation.csv', 'a')
        fieldnames = ['fa_filename', 'target_filename', 'tolerance_ms', 'error_total_ms', 'accuracy_percent']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writerow({'fa_filename': textgrid_fa_fname,
                         'target_filename': textgrid_target_fname,
                         'tolerance_ms': tolerance_ms,
                         'error_total_ms': error_sum,
                         'accuracy_percent': accuracy_percent})


[textgrid_fa_fname, textgrid_target_fname, tolerance_ms] = parseInput()

textgrid_target = open(textgrid_target_fname)
textgrid_fa = open(textgrid_fa_fname)

lines_target = textgrid_target.readlines()
lines_fa = textgrid_fa.readlines()

[time_end_target, labels_target] = getTimeEndNLabels(lines_target)
[time_end_fa, labels_fa] = getTimeEndNLabels(lines_fa)

identityCheck(labels_fa,labels_target,time_end_fa,time_end_target)

[error_absolute, error_sum] = calculateError(time_end_fa, time_end_target)
accuracy_percent = calculateAccPercent(error_absolute, tolerance_ms)

writeResult(error_sum, tolerance_ms, accuracy_percent)

