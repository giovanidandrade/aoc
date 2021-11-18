SRCS    := utils/util.cpp year$(year)/day$(day).cpp
OBJS    := $(patsubst %.cpp,%.o,$(SRCS))
DEPS    := $(wildcard include/*.h)

CXX     := clang-12
CFLAGS  := -Iinclude -Wall -std=c++11 -g

LIBS    := -lstdc++

aoc: $(OBJS)
	$(CXX) -o $@ $^ $(CFLAGS) $(LIBS)

%.o: %.cpp $(DEPS)
	$(CXX) -c -o $@ $< $(CFLAGS)

.PHONY: clean clean-all

clean:
	rm -f $(OBJS)

clean-all:
	rm -f */*.o