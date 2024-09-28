CXX=icpx make

LIKWID=on CXX=icpx make


FLAGS =
INCLUDES =-Iinclude
LDFLAGS =
LIBS =
EXTRA_FLAGS :=

LIKWID_FLAG =
LIKWID_LINK_LIB =

ifeq ($(LIKWID), on)
	LIKWID_FLAG = -DLIKWID_PERFMON $(LIKWID_INC)
	LIKWID_LINK_LIB = $(LIKWID_LIB) -llikwid
endif

ifeq ($(CXX), g++)
	FLAGS = -std=c++0x -Wall -Winline -Wshadow -W -O3 -fopenmp -march=native $(LIKWID_FLAG)
else
	FLAGS = -std=c++0x -Wall -Winline -Wshadow -W -O3 -qopenmp -xHOST $(LIKWID_FLAG)
endif

CXXFLAGS = $(FLAGS) $(EXTRA_FLAGS)

all: clean test perf

perf: perf.o Grid.o PDE.o Solver.o timer.o
	$(CXX) $(CXXFLAGS) -o perf Grid.o PDE.o Solver.o perf.o timer.o $(LDFLAGS) $(LIBS) $(LIKWID_LINK_LIB)

test: test.o Grid.o PDE.o Solver.o timer.o
	$(CXX) $(CXXFLAGS) -o test Grid.o PDE.o Solver.o test.o timer.o $(LDFLAGS) $(LIBS) $(LIKWID_LINK_LIB)

perf.o: src/perf.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDES) src/perf.cpp

test.o: src/test.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDES) src/test.cpp

Solver.o: src/Solver.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDES) src/Solver.cpp

PDE.o: src/PDE.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDES) src/PDE.cpp

Grid.o: src/Grid.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDES) src/Grid.cpp

timer.o: src/timer.cpp
	$(CXX) -c $(CXXFLAGS) $(INCLUDES) src/timer.cpp


clean:
	@$(RM) -rf *.o perf test
