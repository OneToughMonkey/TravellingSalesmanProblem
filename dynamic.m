%% Solve the travelling salesman problem with the efficiency improved dynamic programming approach
% Accepts: a n x n - matrix of distances between at least 3 different places
% Returns:  - length of best possible route that passes exactly once through all 3 of the locations,
%           . the equivalent ordering of n in a 1 x n - matrix (the best route)
%
function [distance, route] = dynamic(distanceMatrix)

n = size(distanceMatrix, 1);

table = {zeros(n, 2^(n - 1)), zeros(n, 2^(n-1), n+1)};
% n x |P(2:n)| format
% one layer for distances, one layer for respective routes

%% Fill table column 1 with distance from each city to start
% represented by the distance of city to empty subset of 2:n
table(:,1) = distanceMatrix(:,1);

%% Calculate distances for ever growing subsets of 2:n
% For each subset A and each city i not in that subset we need to find
% the minimum of
%   distance from city i to each subset element j
%   + distance from j to the sub-subset Z that doesn't include j
%
% To simplify table maneuvration we give each subset the unique index
% of the value of its binary representation where each subset element j
% has the value of 2^(j-2): 2 -> 2^0, 3 -> 2^1, ..., n -> 2^(n-2).
% As the empty subset would thus have the value 0, but table indexing
% starts from 1, 1 is added to the calculated index.

for k = 1:n-1
    for A = nchoosek(2:n, k)'
        for i = find(~ismember(1:n, A))
            iToJVec = distanceMatrix(i,A);
            
            % Determine index of sub-subsets Z
            if k == 1
                indexZVec = 1;
                % The only subset of A for |A| = 1 is the empty subset
            else
                ZVec = nchoosek(A, k-1);
                indexZVec = fliplr((sum(2.^(ZVec - 2), 2) + 1)');
                % ZVec are all subsets of A with one element missing.
                % nchoosek returns them in order of decreasing value
                % of missing element. Since elements are ordered in
                % increasing order in A, we reverse the index vector to
                % align each subset Z's index with the missing element.
            end
            
            jToStartVec = zeros(1,size(A,1)); % preallocation
            
            for j = [A'; 1:size(A,1)]
                % j(1) = element j
                % j(2) = index of element j
                jToStartVec(j(2)) = table(j(1), indexZVec(j(2)));
            end
            
            iToStartVec = iToJVec + jToStartVec;
            
            % Determine index of A and its minimum route and store in table
            indexA = sum(2.^(A-2)) + 1;
            [table{1}(i, indexA), minJIndex] = min(iToStartVec);
            
            % Copy last part of route from table and append current i
            table{2}(i, indexA, :) = table{2}(A(minJIndex), indexZVec(minJIndex), :);
            table{2}(i, indexA, end - (size(A,1) + 1)) = i;
        end
    end
end

distance = table{1}(1, end);
route = table{2}(1, end, :);

end
