#include "utils.h"

#include <fstream> /* ifstream */
#include <sstream> /* sstream */

std::string
slurp(std::string filename)
{
  std::ifstream stream(filename);
  std::stringstream buffer;

  buffer << stream.rdbuf();

  return buffer.str();
}