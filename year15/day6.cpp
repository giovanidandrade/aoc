#include "utils.h"
#include <iostream>

enum InstructionKind
{
  TURN_ON,
  TURN_OFF,
  TOGGLE
};

struct Instruction
{
  InstructionKind kind;
  int x0;
  int y0;
  int x1;
  int y1;
};

Instruction
parse_instruction(std::string const& description)
{
  Instruction instruction;

  std::string input = description;

  std::string kind = take_until_digit(input);
  if (kind == "turn on ") {
    instruction.kind = TURN_ON;
  } else if (kind == "turn off ") {
    instruction.kind = TURN_OFF;
  } else {
    instruction.kind = TOGGLE;
  }

  std::string x0 = take_until_sep(input, ",");
  instruction.x0 = std::stoi(x0);

  // Consuming the separator
  take_until_digit(input);

  std::string y0 = take_until_sep(input, " ");
  instruction.y0 = std::stoi(y0);

  // Consume useless fluff
  take_until_digit(input);

  std::string x1 = take_until_sep(input, ",");
  instruction.x1 = std::stoi(x1);

  // Consuming the separator
  take_until_digit(input);

  std::string y1 = take_until_sep(input, "\n");
  instruction.y1 = std::stoi(y1);

  return instruction;
}

void
exec_old(std::vector<int>& grid, Instruction& instruction)
{
  for (int x = instruction.x0; x <= instruction.x1; ++x) {
    for (int y = instruction.y0; y <= instruction.y1; ++y) {
      int index = x + y * 1000;

      if (instruction.kind == TURN_ON) {
        grid[index] = 1;
      } else if (instruction.kind == TURN_OFF) {
        grid[index] = 0;
      } else {
        grid[index] = !grid[index];
      }
    }
  }
}

void
exec(std::vector<int>& grid, Instruction& instruction)
{
  for (int x = instruction.x0; x <= instruction.x1; ++x) {
    for (int y = instruction.y0; y <= instruction.y1; ++y) {
      int index = x + y * 1000;

      if (instruction.kind == TURN_ON) {
        grid[index] += 1;
      } else if (instruction.kind == TURN_OFF) {
        grid[index] -= 1;
        if (grid[index] < 0) {
          grid[index] = 0;
        }

      } else {
        grid[index] += 2;
      }
    }
  }
}

int
main()
{
  std::vector<std::string> lines = read_lines("input.txt");

  std::vector<int> old_grid(1'000'000, 0);
  std::vector<int> grid(1'000'000, 0);

  for (std::string& line : lines) {
    Instruction instruction = parse_instruction(line);
    exec_old(old_grid, instruction);
    exec(grid, instruction);
  }

  int number_lights_old = 0;
  int brightness = 0;
  for (int i = 0; i < 1'000'000; ++i) {
    number_lights_old += old_grid[i];
    brightness += grid[i];
  }

  std::cout << "Part 1: " << number_lights_old << "\n";
  std::cout << "Part 2: " << brightness << "\n";
  return 0;
}