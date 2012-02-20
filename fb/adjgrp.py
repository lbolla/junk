# http://www.glassdoor.com/Interview/Facebook-Interview-RVW1340742.htm

x = [0, 1, 1, 1, 1, 0, 1, 0, 0]
y = [[0, 1, 1, 0, 1, 1],
     [1, 0, 1, 0, 0, 0],
     [1, 0, 1, 0, 0, 1],
     ]


def find_1d_seqs(x):
    in_seq = False
    l = len(x)
    s = e = 0
    seqs = []
    for i, c in enumerate(x):
        if not in_seq:
            if c == 1:
                s = i
                in_seq = True
        else:
            if c == 0:
                e = i
                in_seq = False
                if (e - s) > 1:
                    seqs.append((s, e))
    if in_seq and (i + 1 - s) > 1:
        seqs.append((s, i + 1))
    # return seqs
    return len(seqs)


def find_2d_seqs(y):
    h = map(find_1d_seqs, y)
    # return h
    return sum(h)


def transpose(y):
    nrows = len(y)
    ncols = len(y[0])
    t = []
    for j in xrange(ncols):
        t_row = []
        for i in xrange(nrows):
            t_row.append(y[i][j])
        t.append(t_row)
    return t

print x
print find_1d_seqs(x)
# print find_1d_seqs([0, 1, 1])
# print find_1d_seqs([1, 1, 1])
# print find_1d_seqs([1, 1, 1, 0])
# print find_1d_seqs([1, 1, 1, 0, 0, 1])

print y
# print find_2d_seqs(y), find_2d_seqs(transpose(y))
print find_2d_seqs(y) + find_2d_seqs(transpose(y))
