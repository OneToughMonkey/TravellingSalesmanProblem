%% Crack the travelling salesman problem with a simple brute force algorithm
% Accepts: a n x n - matrix of distance between at least 3 different places
% Returns: length of best possible route that passes exactly once through all 3 of the places , the equivalent ordering of n in a 1 x n - matrix (the best route)

% Throws Mathlab Exception for n > 12 due to memory overflow in perms() function in authors configuration
function [bestDistance, bestRoute] = bruteforce(distanceMatrix)
%% Check all possible routes and save the shortest one

bestDistance = 0;

for route = perms(2:size(distanceMatrix, 1))'
    route = [1, route', 1];
    distance = 0;
    for i = 1:size(route,2) - 1
        distance = distance + distanceMatrix(route(i), route(i + 1));
    end
    if distance < bestDistance || ~bestDistance
        bestDistance = distance;
        bestRoute = route;
    end
end

end
