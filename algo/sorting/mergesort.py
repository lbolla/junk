import random

def merge(v1, v2):
	v = []
	while len(v1) > 0 or len(v2) > 0:
		if len(v1) > 0 and len(v2) > 0:
			if v1[0] < v2[0]:
				v.append(v1[0])
				v1 = v1[1:]
			else:
				v.append(v2[0])
				v2 = v2[1:]
		elif len(v1) > 0:
			v.extend(v1)
			break
		else:
			v.extend(v2)
			break
	return v

def mergesort(v):
	l = len(v)
	if l < 2:
		return v
	return merge(mergesort(v[:l/2]), mergesort(v[l/2:]))

v = range(10) * 2
random.shuffle(v)

print(v)
u = mergesort(v)
print(u)
