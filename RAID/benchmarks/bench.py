# TODO
# creation
# slicing
# modifying

import numpy


def numpy_create(nrows, ncols):
    data = numpy.zeros((nrows, ncols))


def numpy_create_record(nrows, dtype):
    data = numpy.zeros((nrows,), dtype=dtype)


def numpy_slice(data):
    s = data[3, :].sum()
    s = data[:, 3].sum()


def numpy_slice_record(data):
    s = data['f0'].sum()
    # Note: cannot sum fields of a record
    s = data['f3'].sum()


def numpy_modify(data):
    data[3, :].fill(666)
    data[:, 3].fill(999)
    data[0, :] = data[1, :]
    data[10, :] = numpy.sin(data[11, :]) + numpy.cos(data[12, :])


def numpy_modify_record(data):
    data['f0'].fill(666)
    data['f3'].fill(999)
    data['f0'] = data['f3']
    data['f10'] = numpy.sin(data['f11']) + numpy.cos(data['f12'])


def make_random_array(nrows, ncols):
    return numpy.random.random_sample((nrows, ncols))


def make_random_recarray(nrows, ncols):
    dtype = ','.join(['f4'] * ncols)
    data = numpy.zeros((nrows, ), dtype=dtype)
    for i in xrange(nrows):
        data[i] = tuple(numpy.random.random_sample(ncols))
    return data


def bench(stmt, setup):
    number_of_times, repetitions = 100, 3
    t = Timer(stmt, setup)
    elapsed_time = sum(t.repeat(number=number_of_times, repeat=repetitions)) / \
            (repetitions * number_of_times)
    print '%-50s: %.3f ms' % (stmt[:50], elapsed_time * 1000)


if __name__ == '__main__':
    from timeit import Timer
    import inspect

    ls = locals().copy()
    functions = [k for k, v in ls.iteritems() if inspect.isfunction(v)]
    stmts = ['from __main__ import %s' % ','.join(functions),
             'data = make_random_array(1000, 1000)',
             'recdata = make_random_recarray(1000, 1000)',
             ]
    setup_stmt = ';'.join(stmts)

    for stmt in [
        'numpy_create(1000, 1000)',
        'numpy_create_record(1000, "%s")' % ','.join(['f4'] * 1000),
        'numpy_slice(data)',
        'numpy_slice_record(recdata)',
        'numpy_modify(data)',
        'numpy_modify_record(recdata)',
        ]:
        bench(stmt, setup_stmt)
