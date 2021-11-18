#include "utils.h"
#include <boost/algorithm/string.hpp>
#include <iostream>
#include <openssl/md5.h>

/* Wrapper around SSL MD5 implementation.
 * Strictly speaking, deprecated but I don't need the sophistication
 * of the newer version, I just need a simple API.
 */
int
first_six_nibbles_md5(std::string const& message)
{
  unsigned char digest[MD5_DIGEST_LENGTH];

  unsigned long number_bytes = message.length();
  MD5((unsigned char*)message.c_str(), number_bytes, digest);

  return (digest[0] << 16) + (digest[1] << 8) + digest[2];
}

int
find_nil_five_nibbles(std::string const& key)
{
  for (int number = 0; number >= 0; ++number) {
    std::string message = key + std::to_string(number);

    /* Right shift because we don't care about the last nibble */
    int hash_prefix = first_six_nibbles_md5(message) >> 4;
    if (hash_prefix == 0) {
      return number;
    }
  }

  /* if no int satisfies this problem, return a sentinel value */
  return -1;
}

int
find_nil_six_nibbles(std::string const& key)
{
  for (int number = 0; number >= 0; ++number) {
    std::string message = key + std::to_string(number);

    int hash_prefix = first_six_nibbles_md5(message);
    if (hash_prefix == 0) {
      return number;
    }
  }

  /* if no int satisfies this problem, return a sentinel value */
  return -1;
}

int
main()
{
  std::string input = slurp("input.txt");
  boost::trim_right(input);

  std::cout << "Part 1: " << find_nil_five_nibbles(input) << "\n";
  std::cout << "Part 2: " << find_nil_six_nibbles(input) << "\n";
  return 0;
}