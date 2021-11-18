#include "utils.h"

#include <fstream> /* ifstream */
#include <iostream>
#include <sstream> /* sstream */

using namespace std;

string
slurp(string filename)
{
  ifstream stream(filename);
  stringstream buffer;

  buffer << stream.rdbuf();

  return buffer.str();
}

vector<string>
read_lines(string filename)
{
  string text = slurp(filename);
  return split(text, "\n");
}

vector<string>
split(string const& input, string delimiter)
{
  string input_copy = input;
  vector<string> tokens{};

  size_t position;
  string token;
  while ((position = input_copy.find(delimiter)) != string::npos) {
    token = input_copy.substr(0, position);
    tokens.push_back(token);

    input_copy.erase(0, position + delimiter.length());
  }

  tokens.push_back(input_copy);
  return tokens;
}