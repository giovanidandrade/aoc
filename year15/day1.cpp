#include "utils.h"
#include <iostream>

int
from_paren(char ch)
{
  switch (ch) {
    case '(':
      return 1;
    case ')':
      return -1;
    default:
      return 0;
  }
}

int
get_floor(std::string input)
{
  int floor = 0;

  for (char& ch : input) {
    floor += from_paren(ch);
  }

  return floor;
}

int
first_to_basement(std::string input)
{
  int floor = 0;

  for (int index = 0; index < input.length(); ++index) {
    floor += from_paren(input[index]);
    if (floor == -1) {
      return index + 1;
    }
  }

  return -1;
}

int
main()
{
  std::string input = slurp("input.txt");

  std::cout << "Part 1: " << get_floor(input) << std::endl;
  std::cout << "Part 2: " << first_to_basement(input) << std::endl;

  return 0;
}