def hex_bitcount ( S ):
    # write your code here
    return bin(int(S, 16)).count('1')


def hex_bitcount_2 ( S ):
    # alternative version, but slower
    i = int(S, 16)
    c = 0
    while i:
        c += i & 1
        i >>= 1
    return c


def main():
    print(hex_bitcount('2F'))
