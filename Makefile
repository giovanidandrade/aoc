SRCS    := utils/util.cpp year$(year)/day$(day).cpp
OBJS    := $(patsubst %.cpp,%.o,$(SRCS))
DEPS    := $(wildcard include/*.h)

CXX     := clang-12
CFLAGS  := -Iinclude -Wall -std=c++14 -g

LIBS    := -lstdc++

# 2015 Day 3 needs an external library to compute MD5
ifeq ($(year)/$(day),15/4)
	LIBS += -lcrypto
endif

aoc: $(OBJS)
	$(CXX) -o $@ $^ $(CFLAGS) $(LIBS)

%.o: %.cpp $(DEPS)
	$(CXX) -c -o $@ $< $(CFLAGS)

.PHONY: clean clean-all

clean:
	rm -f $(OBJS)

clean-all:
	rm -f */*.o