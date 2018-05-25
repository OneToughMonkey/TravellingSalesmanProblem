%% Test travelling salesman problem program performances for different numbers of places
% Plots and prints test results
% Requires getDistanceMatrix()-function that converts city strings to a distance matrix

%% Setup

% Setup maximum places list
places = [ " ", " ", " " ]  % enter as many places as you wish to travel
distanceMatrix = getDistanceMatrix(places);

% Setup the program input sizes that you want to test
nRange = [ 3, 5, 7 ];

% Preallocate result arrays
bruteforceDistances = zeros(1, size(nRange, 2));
bruteforceRunTimes = zeros(1, size(nRange, 2));

dynamicDistances = zeros(1, size(nRange, 2));
dynamicRunTimes = zeros(1, size(nRange, 2));

%% Testing
for i = [1:size(nRange, 2); nRange]
    n = i(2);
    i = i(1);
    subMatrix = distanceMatrix(1:n, 1:n);
    
    f = @() bruteforce(subMatrix);
    g = @() dynamic(subMatrix);
    
    %% Test return values
    
    try
        bruteforceDistances(i) = f();
    catch Exception
        % Bruteforce may fail with an Exception for n >= 13
        Exception % print exception details to console and set test value to NaN
        bruteforceDistances(i) = NaN;
    end
        
    dynamicDistances(i) = g();

    %% Test execution times
    
    try
        bruteforceRunTimes(i) = timeit(f);
    catch Exception
        Exception
        bruteforceRunTimes(i) = NaN;
    end
    
    dynamicRunTimes(i) = timeit(g);
end

%% Plot test results

% Return values
figure;
hold on;
xMax = max(nRange);
yMin = bruteforceDistances(1,1);
axis([3, xMax, yMin, inf]);
xlabel('n');
ylabel('return value');
plot(nRange, bruteforceDistances, 'DisplayName', 'Bruteforce algorithm');
plot(nRange, dynamicDistances, 'DisplayName', 'Dynamic programming');
annotation('textbox',[.4 1 0 0],'String','Return values','FitBoxToText','on');
legend('Location','northwest');
hold off;

% Execution times
figure;
hold on;
set(gca, 'YScale', 'log');
axis([3, xMax, 0, inf]);
xlabel('n');
ylabel('runtime');
plot(nRange, bruteforceRunTimes, 'DisplayName', 'Brutforce algorithm');
plot(nRange, dynamicRunTimes, 'DisplayName', 'Dynamic programming');
legend('Location','northwest');
annotation('textbox',[.4 1 0 0],'String','Runtimes','FitBoxToText','on');
hold off;

%% Print test results

bruteforceDistances
dynamicDistances

bruteforceRunTimes
dynamicRunTimes
