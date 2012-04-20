'''Pipeline

(yield) -> receiver
.send -> producer

Provide initial state to producer, avoiding globals.
'''

import time
from functools import partial


def P(f, n):
    '''Producer: only .send (and yield as entry point).'''

    state = (yield)  # get initial state
    while True:
        res, state = f(state)
        n.send(res)


def S(f, n):
    '''Stage: both (yield) and .send.'''

    while True:
        r = (yield)
        n.send(f(r))


def C(f):
    '''Consumer: only (yield).'''

    while True:
        r = (yield)
        f(r)


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


def produce(state):
    '''Given a state, produce a result and the next state.'''
    time.sleep(1)
    return state, state + 1


def stage(x):
    print 'Stage', x
    return x + 1


def consume(x):
    print 'Consumed', x


if __name__ == '__main__':
    p = pipeline(
            partial(P, produce),
            partial(S, stage),
            partial(S, stage),
            partial(S, stage),
            partial(C, consume),
            )
    initial_state = 0
    p.send(initial_state)
