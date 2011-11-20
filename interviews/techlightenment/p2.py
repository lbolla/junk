'''Given a string representing a hex number, return the number of '1's in its
binary representation.
'''


def hex_bitcount(S):
    # write your code here
    return bin(int(S, 16)).count('1')


def hex_bitcount_2(S):
    # alternative version, but slower
    i = int(S, 16)
    c = 0
    while i:
        c += i & 1
        i >>= 1
    return c


# lookup table, built once
ONES_IN = dict((str(c), hex_bitcount(str(c)))
        for c in list(range(10)) + list('abcdef'))


def ones_in(c):
    return ONES_IN[c]


def hex_bitcount_3(S):
    # another version with lookup table (still slower than the first one)
    return sum(map(ones_in, list(S.lower())))


def main():
    print(hex_bitcount('2F'))


if __name__ == '__main__':
    main()
