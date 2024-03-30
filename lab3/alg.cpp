#include <iostream>
#include <string>

std::string replaceDuplicates(const std::string& input) {
	std::string result;
	char prevChar = '\0'
	
	for (size_t i = 0; i < input.length(); i++) {
		if (input[i] != prevChar) {
			result += input[i];
			prevChar = input[i];
		}
	}

	return result;
}
