#include <stdio.h>
#include <string.h>

int atoi(const char* s, size_t l) {
	int i, tmp;
	int sum = 0;
	int sign = 1;
	for (i = 0; i < l; ++i) {
		if (i == 0 && s[i] == '-') {
			sign = -1;
			continue;
		}
		tmp = (int)s[i] - 48;
		if (0 <= tmp && tmp <= 9)
			sum = 10 * sum + tmp;
	}
	return sign * sum;
}

int main() {
	const char* s;
	int x;

	s = "1234";
	x = atoi(s, strlen(s));
	printf("%d\n", x);

	s = "12a4";
	x = atoi(s, strlen(s));
	printf("%d\n", x);

	return 0;
}
