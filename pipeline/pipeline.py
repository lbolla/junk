# TODO this eats the first N...
# do it in python3, too

import time


N = 0


def P(n):
    '''Producer: only send (and yield as entry point).'''

    def _f():
        global N
        N += 1
        time.sleep(1)
        return N

    yield  # to "start"
    while True:
        n.send(_f())


def S(n):

    def _f(x):
        print 'Stage', x
        return x

    while True:
        r = (yield)
        n.send(_f(r))


def C():
    '''Consumer: only (yield).'''

    def _f(x):
        print x

    while True:
        r = (yield)
        _f(r)


def pipeline(*args):
    c = args[-1]()
    c.next()
    t = c
    for S in reversed(args[:-1]):
        s = S(t)
        s.next()
        t = s
    p = P(t)
    p.next()
    return p


# p = pipeline(P, S, S, S, C)
p = pipeline(P, C)
p.send(None)
