%% Go grab a distanceMatrix from the Google Distance Matrix API
%% if you have an API-key
% Accepts:  a 1 x n-matrix of strings representing cities
% Returns:  a n x n-matrix of distances between the cities, km units
%
% Notes:    - number of queried cities is limited to 25 by Google's server restrictions
%           - potential network/server-side failures or user error not taken into account
%           - symmetrical distances are assumed to contain network query overhead

function distanceMatrix = getDistanceMatrix(cities)

key = '';  % INSERT YOUR API-KEY
distanceMatrix = zeros(size(cities, 2), size(cities, 2));
jsonData = cell(1, size(cities, 2));

% Query upper right half of matrix from the API row by row
for i = 1:size(cities, 2) - 1
    cityQuery = '';
    for city = cities(i + 1:end)
        cityQuery = strcat(cityQuery, city, '|');
    end
    jsonData{i} = webread('https://maps.googleapis.com/maps/api/distancematrix/json', 'origins', cities(i), 'destinations', cityQuery, 'key', key);
end

% Construct symmetrical output matrix
for i = 1:size(cities, 2) - 1
    for j = 1:size(jsonData{i}.rows(1).elements)
        distance = split(jsonData{i}.rows(1).elements(j).distance.text, ' ');
        distance{1,1} = str2double(distance{1,1});
        if distance{2,1} == "m"
            distance{1,1} = distance{1,1} / 1000;
        end
        distanceMatrix(i, j + i) = distance{1,1};
        distanceMatrix(j + i, i) = distance{1,1};
    end
end

end
