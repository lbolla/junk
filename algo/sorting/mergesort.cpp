#include <stdlib.h>
#include <iostream>
#include <vector>

using namespace std;

void print(const vector<int>& v) {
	for (vector<int>::const_iterator i = v.begin(); i != v.end(); ++i)
		cout << *i << endl;
}

vector<int> merge(vector<int> left, vector<int> right) {
	vector<int> x(left.size() + right.size(), 0);
	for (vector<int>::iterator ileft = left.begin(), iright = right.begin(), ix = x.begin(); 
			ix != x.end(); 
			++ix) {
		if (ileft != left.end() && iright != right.end()) {
			if (*ileft <= *iright) {
				*ix = *ileft;
				++ileft;
			} else {
				*ix = *iright;
				++iright;
			}
		} else if (ileft != left.end()) {
			*ix = *ileft;
			++ileft;
		} else {
			*ix = *iright;
			++iright;
		}
	}
	return x;
}

vector<int> mergesort(vector<int> l) {
	int s = l.size();
	if (s < 2)
		return l;
	int m = s / 2;
	vector<int> left(m);
	vector<int> right(s - m);
	copy(l.begin(), l.begin() + m, left.begin());
	copy(l.begin() + m, l.end(), right.begin());
	return merge(mergesort(left), mergesort(right));
}

int main () {
	const int n = 10;
	vector<int> l(n);
	for (vector<int>::iterator i = l.begin(); i != l.end(); ++i) {
		*i = rand();
	}
	cout << endl << "unsorted" << endl;
	print(l);
	cout << endl << "sorted" << endl;
	print(mergesort(l));
	return 0;
}
