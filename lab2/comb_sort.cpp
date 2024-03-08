#include <iostream>
#include <vector>

void comb(std::vector<int>& array) {
	double factor = 1.25;
	unsigned step = array.size() - 1;
	
	while (step >= 1) {
		for (int i = 0; i + step < array.size(); i++) {
			if (array[i] > array[i + step]) {
				std::swap(array[i], array[i + step])
			}
		}
		step /= factor;
	}
	
}
