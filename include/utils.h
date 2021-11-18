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

/* Collects a prefix until sees a number.
 * Returns the prefix immediately before seeing the number.
 * Modifies the string
 */
std::string
take_until_digit(std::string& input);

/* Collects a prefix until sees a separator
 * Returns the prefix immediately before seeing the separator.
 * Modifies the string
 */
std::string
take_until_sep(std::string& input, std::string const& separator);

#endif