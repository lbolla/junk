#include <stdlib.h>
#include <iostream>
#include <algorithm>
#include <vector>

using namespace std;

int partition(vector<int>& v, int left, int right, int p_idx) {
	int p_val = v[p_idx];
	swap(v[p_idx], v[right]);
	int s_idx = left;
	for (int i = left; i < right; ++i) {
		if (v[i] <= p_val) {
			swap(v[i], v[s_idx]);
			s_idx += 1;
		}
	}
	swap(v[right], v[s_idx]);
	return s_idx;
}

void qsort(vector<int>& v, int left, int right) {
	if (right > left) {
		int p_idx = left + (right - left) / 2;
		int p_idx_new = partition(v, left, right, p_idx);
		qsort(v, left, p_idx_new - 1);
		qsort(v, p_idx_new + 1, right);
	}
}

void print(const vector<int>& v) {
	for (vector<int>::const_iterator i = v.begin(); i != v.end(); ++i)
		cout << *i << endl;
}

void fill(vector<int>& v) {
	for (vector<int>::iterator i = v.begin(); i != v.end(); ++i)
		*i = rand();
}

int main (int argc, char** argv) {
	const int n = 10;
	vector<int> v(n);
	fill(v);
	cout << endl << "unsorted" << endl;
	print(v);
	qsort(v, 0, n-1);
	cout << endl << "sorted" << endl;
	print(v);
	return 0;
}
