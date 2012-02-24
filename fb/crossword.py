import itertools as I

words = set([
        'abc',
        'def',
        'ghi',
        'adg',
        'beh',
        'cfi',
        'aei',
        'ceg',
        'zzz',
        'xxx',
        ])

def verify(cw):
    return \
            cw[0:3] in words and \
            cw[3:6] in words and \
            cw[6:9] in words and \
            cw[0:9:3] in words and \
            cw[1:9:3] in words and \
            cw[2:9:3] in words and \
            cw[0]+cw[4]+cw[8] in words and \
            cw[2]+cw[4]+cw[6] in words

# for candidate in I.combinations(words, 3):
for candidate in I.permutations(words, 3):
    cw = ''.join(candidate)
    if verify(cw):
        print candidate
