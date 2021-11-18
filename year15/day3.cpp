#include "utils.h"
#include <iostream>
#include <unordered_set>

typedef std::unordered_set<int> hash_set;

int
pack_position(int x, int y)
{
  /* we're storing position in a int.
     We're putting X in the upper 16 bits
     and Y in the lower 16 bits */
  return ((x & 0xFFFF) << 16) | (y & 0xFFFF);
}

void
update_position(char ch, int* x, int* y)
{
  switch (ch) {
    case '^':
      ++*y;
      break;

    case 'v':
      --*y;
      break;

    case '<':
      --*x;
      break;

    case '>':
      ++*x;
      break;

    default:
      break;
  }
}

int
count_houses(std::string const& directions)
{
  int number_houses = 1;

  int x = 0, y = 0;
  hash_set memory;

  memory.insert(pack_position(x, y));

  for (char const& ch : directions) {
    update_position(ch, &x, &y);

    int position = pack_position(x, y);

    if (memory.find(position) == memory.end()) {
      ++number_houses;
      memory.insert(position);
    }
  }

  return number_houses;
}

int
count_houses_with_robo(std::string const& directions)
{
  int number_houses = 1;

  int santa_x = 0, santa_y = 0;
  int robo_x = 0, robo_y = 0;

  int* x = &santa_x;
  int* y = &santa_y;

  hash_set memory;
  memory.insert(pack_position(*x, *y));

  bool is_santa = true;
  for (char const& ch : directions) {
    update_position(ch, x, y);

    int position = pack_position(*x, *y);

    if (memory.find(position) == memory.end()) {
      ++number_houses;
      memory.insert(position);
    }

    // Now, let's see what the other one is doing
    if (is_santa) {
      x = &robo_x;
      y = &robo_y;
    } else {
      x = &santa_x;
      y = &santa_y;
    }

    is_santa = !is_santa;
  }

  return number_houses;
}

int
main()
{
  std::string input = slurp("input.txt");

  std::cout << "Part 1: " << count_houses(input) << " houses\n";
  std::cout << "Part 2: " << count_houses_with_robo(input) << " houses\n";
  return 0;
}