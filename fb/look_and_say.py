import itertools as I

def look_and_say(x):
    while True:
        yield x
        x = int(''.join('%s%s' % (len(list(lst)), digit) for digit, lst in I.groupby(str(x))))

l = look_and_say(1)
for i in xrange(10):
    print l.next()
