'''Pipeline

(yield) -> receiver
.send -> producer
'''

import time

N = 0

def P(n):
    '''Producer: only .send (and yield as entry point).'''

    def _f():
        global N
        N += 1
        time.sleep(1)
        return N

    yield  # to "start"
    while True:
        n.send(_f())


def S(n):
    '''Stage: both (yield) and .send.'''

    def _f(x):
        print 'Stage', x
        return x + 1

    while True:
        r = (yield)
        n.send(_f(r))


def C():
    '''Consumer: only (yield).'''

    def _f(x):
        print 'Consumed', x

    while True:
        r = (yield)
        _f(r)


def pipeline(*args):
    '''Chain stages together. Assumes the last is the consumer.'''

    c = args[-1]()
    c.next()
    t = c
    for S in reversed(args[:-1]):
        s = S(t)
        s.next()
        t = s
    return t


if __name__ == '__main__':
    p = pipeline(P, S, S, S, C)
    p.next() # to "start"
