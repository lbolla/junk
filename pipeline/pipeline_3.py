'''Pipeline

(yield) -> receiver
.send -> producer

Provide initial state to producer, avoiding globals.
Stop iteration after a bit.
Wrap in nice class.
'''


class StopPipeline(Exception):
    pass


class Pipeline(object):
    '''Chain stages together. Assumes the last is the consumer.'''

    def __init__(self, *args):
        c = Pipeline.C(args[-1])
        c.next()
        t = c
        for stg in reversed(args[1:-1]):
            s = Pipeline.S(stg, t)
            s.next()
            t = s
        p = Pipeline.P(args[0], t)
        p.next()
        self._pipeline = p

    def start(self, initial_state):
        try:
            self._pipeline.send(initial_state)
        except StopIteration:
            self._pipeline.close()


    @staticmethod
    def P(f, n):
        '''Producer: only .send (and yield as entry point).'''

        state = (yield)  # get initial state
        while True:
            try:
                res, state = f(state)
            except StopPipeline:
                return
            n.send(res)


    @staticmethod
    def S(f, n):
        '''Stage: both (yield) and .send.'''

        while True:
            r = (yield)
            n.send(f(r))


    @staticmethod
    def C(f):
        '''Consumer: only (yield).'''

        while True:
            r = (yield)
            f(r)


def produce(state):
    '''Given a state, produce a result and the next state.'''
    import time
    if state == 3:
        raise StopPipeline('Enough!')
    time.sleep(1)
    return state, state + 1


def stage(x):
    print 'Stage', x
    return x + 1


def consume(x):
    print 'Consumed', x


if __name__ == '__main__':
    p = Pipeline(
            produce,
            stage,
            stage,
            stage,
            consume,
            )
    initial_state = 0
    p.start(initial_state)
