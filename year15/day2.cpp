#include "utils.h"
#include <algorithm>
#include <iostream>

struct Box
{
  int length;
  int width;
  int height;

  int area() const
  {
    return 2 * (length * width + width * height + height * length);
  };

  int largest_dimension() const
  {
    return std::max(length, std::max(width, height));
  }

  int smallest_area() const
  {
    return length * width * height / largest_dimension();
  };

  int volume() const { return length * width * height; };

  int smallest_perimeter() const
  {
    return 2 * (width + length + height - largest_dimension());
  }
};

/* Parses a box from a string where its dimensions are given separated by 'x' */
Box
parse_box(std::string const& line)
{
  Box box;

  std::vector<std::string> dimensions = split(line, "x");

  box.length = std::stoi(dimensions[0]);
  box.width = std::stoi(dimensions[1]);
  box.height = std::stoi(dimensions[2]);

  return box;
}

int
main()
{
  std::vector<std::string> lines = read_lines("input.txt");

  int area = 0;
  int ribbon = 0;
  for (std::string& line : lines) {
    Box box = parse_box(line);

    area += box.area() + box.smallest_area();
    ribbon += box.volume() + box.smallest_perimeter();
  }

  std::cout << "Part 1: " << area << " ft²\n";
  std::cout << "Part 2: " << ribbon << " ft\n";

  return 0;
}