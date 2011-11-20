from itertools import takewhile

def heavy_decimal_count ( A,B ):
    # write your code here
    assert(A >= 0 and B >= 0 and A <= B)
    # return run_linear(A, B)
    return run_maybe_better(A, B)


def run_linear(A, B):
    # Complexity not good enough...
    return len(list(filter(is_heavy, range(A, B+1))))


def avg(l):
    return 1. * sum(l) / len(l)


def is_heavy(x):
    return avg(list(map(int, list(str(x))))) > 7


def run_maybe_better(A, B):
    # Sort range by a signature so that, after a certain number, they'll all be
    # "heavy".
    # For example:
    # [8765, 8766, 8776, 8860, 8861, 8862, 8863, 8864, 8865, 8866, 8876, 8876, 8886, 9876, 9886]
    # [False, False, False, False, False, False, False, False, False, False, True, True, True, True, True]
    # Use bisect to find the first True. Result = len(range) - index_first_true
    # Not enough time for bisect. Use takewhile, starting from end of range.
    r = range(A, B + 1)
    def signature(x):
        return int(''.join(sorted(str(x), reverse=True)))
    signatures = sorted(map(signature, r), reverse=True)
    return len(list(takewhile(is_heavy, signatures)))


def main():
    print(run_linear(8675,8689))
    print(run_maybe_better(8675,8689))
