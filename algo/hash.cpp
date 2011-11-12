#include <iostream>
#include <vector>
#include <list>

using namespace std;

template <class K, class V>
class Item {
	public:
		Item(K _k, V _v): k(_k), v(_v) {}
		K k;
		V v;
};

template <class K, class V>
class HashTable {
	public:
		HashTable(int n) { table.resize(n); }
		void set(K k, V v) { 
			int idx = getIdx(k);
			list_t* l = &table[idx];
			if (l->size() == 0) {
				// new element
				cout << "new element" << endl;
				l->push_back(item_t(k, v));
			} else {
				// scan the list
				cout << "scanning" << endl;
				bool found = false;
				for (typename list_t::iterator it = l->begin(); it != l->end(); ++it) {
					if (it->k == k) {
						it->v = v;
						found = true;
						cout << "found" << endl;
						break;
					}
				}
				if (!found) {
					l->push_back(item_t(k, v));
				}
			}
		}
		void print() {
			int row = 0;
			for (typename vector<list_t>::iterator iv = table.begin(); iv != table.end(); ++iv) {
				cout << row++ << ". [" << iv->size() << "] ";
				for (typename list_t::iterator it = iv->begin(); it != iv->end(); ++it) {
					cout << "(" << it->k << "," << it->v << ") -> ";
				}
				cout << endl;
			}
		}
	private:
		typedef Item<K,V> item_t;
		typedef list<Item<K,V> > list_t;
		vector<list_t> table;
		int getIdx(K k) { return hash(k)%table.size(); }
		int hash(K k) { 
			int hash = 0;
			int c;
			while (c = *k++)
				hash += c;
			return hash;
};

int main () {
	HashTable<int,int> h(10);
	h.set("1", 11);
	h.print();
	return 0;
}
