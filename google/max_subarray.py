# Given an array, find the subarray with the max sum


def max_subarray(v):
    max_so_far = current_max = 0
    max_range = (0, 0)
    current_range = [0, 0]
    for i, item in enumerate(v):
        current_max += item
        current_range[1] = i + 1
        if current_max > max_so_far:
            max_so_far = current_max
            max_range = tuple(current_range)
        elif current_max < 0:
            current_max = 0
            current_range[0] = i + 1
    return v[max_range[0]: max_range[1]]


print max_subarray([1, -3, 5, -2, 9, -8, -6, 4])  # [5, -2, 9]
print max_subarray([1, -3, 5, -2, 9, 1, 3, -8, -6, 4])  # [5, -2, 9]
