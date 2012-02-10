def x0(n):
    '''Bottom.'''
    raise Exception('undefined')


def g(x):
    '''Factorial functional.'''
    def _x(n):
        if n == 0:
            return 1
        return n * x(n - 1)
    return _x


def iterate(f, x):
    '''Return x, f(x), f(f(x)), ...'''
    yield x
    while True:
        x = f(x)
        yield x


def take(xs, n):
    '''Return xs[n] for an iterator.'''
    for i, x in enumerate(xs):
        if i == n:
            return x
    raise Exception('missing')


xs = iterate(g, x0)
x10 = take(xs, 10)


# fixed-point combinator
Z = lambda f: (lambda x: f(lambda *args: x(x)(*args)))(lambda x: f(lambda *args: x(x)(*args)))
fact = Z(g)
