import random
from qsort import partition


def ksel(x, left, right, k):
    if right == left and k == 0:
        return x[left]
    if right == left + 1:
        if k == 0:
            return min(x[left], x[right])
        elif k == 1:
            return max(x[left], x[right])
    p_idx = left + (right - left) / 2
    p_idx_new = partition(x, left, right, p_idx)
    if k == p_idx_new - left + 1:
        return x[p_idx_new]
    elif k < p_idx_new - left + 1:
        return ksel(x, left, p_idx_new - 1, k)
    else:
        return ksel(x, p_idx_new + 1, right, k - p_idx_new)


def main():
    x = range(10)
    random.shuffle(x)
    print ksel(x, 0, len(x) - 1, 3)


if __name__ == '__main__':
    main()
