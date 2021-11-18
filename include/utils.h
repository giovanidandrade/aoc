#ifndef UTILS_H
#define UTILS_H

#include <string>
#include <vector>

/* Reads a file to a string */
std::string
slurp(std::string filename);

/* Reads a file into a vector of lines */
std::vector<std::string>
read_lines(std::string filename);

/* Splits a string into a vector of tokens */
std::vector<std::string>
split(std::string const& input, std::string delimiter);

#endif