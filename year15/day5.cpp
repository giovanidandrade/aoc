#include "utils.h"
#include <iostream>

int
number_of_vowels(std::string const& string)
{
  int number = 0;
  for (char const& ch : string) {
    switch (ch) {
      case 'a':
      case 'e':
      case 'i':
      case 'o':
      case 'u':
        number += 1;
        break;
    }
  }

  return number;
}

bool
has_double_letter(std::string const& string)
{
  char previous_char = string[0];
  for (char const& ch : string.substr(1)) {
    if (ch == previous_char) {
      return true;
    }

    previous_char = ch;
  }

  return false;
}

bool
has_bad_substring(std::string const& string)
{
  std::vector<std::string> bad_substrings{ "ab", "cd", "pq", "xy" };

  for (std::string substring : bad_substrings) {
    if (string.find(substring) != std::string::npos) {
      return true;
    }
  }

  return false;
}

bool
has_sandwiched_letter(std::string const& string)
{
  if (string.length() < 3) {
    return false;
  }

  char c = string[0];
  char d = string[1];
  for (char const& ch : string.substr(2)) {
    if (c == ch) {
      return true;
    }

    c = d;
    d = ch;
  }

  return false;
}

bool
has_repeating_pair_no_overlap(std::string const& string)
{
  if (string.length() < 2) {
    return false;
  }

  std::string copy = string;

  bool result = false;

  while (!result && copy.length() >= 2) {
    std::string possible_pair = copy.substr(0, 2);
    if (copy.substr(2).find(possible_pair) != std::string::npos) {
      result = true;
    } else {
      copy.erase(0, 1);
    }
  }

  return result;
}

int
main()
{
  std::vector<std::string> lines = read_lines("input.txt");

  int number_nice_strings_old = 0;
  int number_nice_strings = 0;

  for (std::string& line : lines) {
    number_nice_strings_old += (number_of_vowels(line) >= 3) &&
                               has_double_letter(line) &&
                               !has_bad_substring(line);

    number_nice_strings +=
      has_sandwiched_letter(line) && has_repeating_pair_no_overlap(line);
  }

  std::cout << "Part 1: " << number_nice_strings_old << "\n";
  std::cout << "Part 2: " << number_nice_strings << "\n";

  return 0;
}