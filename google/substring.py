# Find the substring in a given string

def substring(s, f):
    for i in xrange(len(s)):
        if s.startswith(f, i):
            return i
    return -1


print substring("hello world", "ell")  # 1
print substring("hello world", "elw")  # -1
print substring("hello world", "world")  # 6
