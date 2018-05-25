# Travelling Salesman Problem

This project contains MATLAB-code to solve the travelling salesman problem using two different approaches.

In more detail:
# bruteforceTSP.m
Solves the problem with a simple brute force algorithm. Requires a n x n - distance (or cost) matrix as input. Fails for large n.

# dynamicTSP.m
Solves the problem with a performance improved dynamic programming algorithm. Requires a n x n - distance (or cost) matrix as input

# getDistanceMatrix.m
Provides an interface for distance matrix creation via the Google Distance Matrix API. Requires an API-key.

# performanceTestSuite.m
Template for a performance test setup.
