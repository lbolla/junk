A = [-2, 1, -3, 4, -1, 2, 1, -5, 4]

def maxsubarray(A):
    assert any(x > 0 for x in A)
    m = m_here = 0
    istart = iend = 0
    for i, x in enumerate(A):
        m_here = max(m_here + x, 0)
        if m_here == 0:
            istart = i + 1
        m = max(m, m_here)
        if m == m_here:
            iend = i
        print x, m_here, m, istart, iend
    return m, A[istart:iend + 1]

print maxsubarray(A)
