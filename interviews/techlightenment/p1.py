import operator


def equalization_steps ( A ):
    # write your code here
    return run(A)


def avg(A):
    return 1. * sum(A) / len(A)


def step(A):
    a = avg(A)
    delta = list(map(lambda x: (x - a) >= 0 and -1 or +1, A))
    return list(map(operator.add, A, delta))


def success(A):
    return all(map(lambda x: x == A[0], A))


def run(A):
    i = 0
    Aold = None
    while not success(A):
        i += 1
        A, Aold = step(A), A
        print(A)
        if sorted(A) == sorted(Aold):
            return -1
    return i

def main():
    # test code
    A = list(range(4))
    print(run(A))
    A = list([11,3,7,1])
    print(run(A))
