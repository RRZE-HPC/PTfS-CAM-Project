CXX=icpx make

LIKWID=on CXX=icpx make


FLAGS =
INCLUDES =-Iinclude
LDFLAGS = -lstdc++fs
LIBS =
DEBUG ?= false

ifeq ($(CXX), g++)
	TEST_FLAGS = 
else
	TEST_FLAGS = -fp-model=precise
endif

EXTRA_FLAGS :=
ifeq ($(DEBUG), true)
	EXTRA_FLAGS := $(EXTRA_FLAGS) -DDEBUG
endif

LIKWID_FLAG =
LIKWID_LINK_LIB =

ifeq ($(LIKWID), on)
	LIKWID_FLAG = -DLIKWID_PERFMON $(LIKWID_INC)
	LIKWID_LINK_LIB = $(LIKWID_LIB) -llikwid
endif

ifeq ($(CXX), g++)
	FLAGS = -std=c++0x -Wall -Winline -Wshadow -W -O3 -fopenmp -march=native $(LIKWID_FLAG)
else
	FLAGS = -std=c++0x -Wall -Winline -Wshadow -W -O3 -qopenmp -xHOST -Wno-tautological-constant-compare $(LIKWID_FLAG)
endif

CXXFLAGS = $(FLAGS) $(EXTRA_FLAGS)

DEPS = Grid.o PDE.o Solver.o timer.o

all: clean test perf

perf: perf.o $(DEPS)
	$(CXX) $(CXXFLAGS) -Wno-tautological-constant-compare -o perf perf.o $(DEPS) $(LDFLAGS) $(LIBS) $(LIKWID_LINK_LIB)

test: test_test.o $(DEPS:.o=_test.o)
	$(CXX) $(CXXFLAGS) $(TEST_FLAGS) -o test test_test.o $(DEPS:.o=_test.o) $(LDFLAGS) $(LIBS) $(LIKWID_LINK_LIB)

%.o: src/%.cpp
	$(CXX) -c $(CXXFLAGS) -Wno-tautological-constant-compare $(INCLUDES) src/$(@:.o=).cpp

%_test.o: src/%.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDES) $(TEST_FLAGS) -o $(@:_test=) src/$(@:_test.o=).cpp

clean:
	@$(RM) -rf *.o perf test results
