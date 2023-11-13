% Parameters for exponential growth
growth_rate = 0.7623;  % Adjust as needed
initial_population = 0.3;
num_years = 13;  % Adjust the number of years as needed

% Initialize arrays to store time and population values
time = zeros(1, num_years);
populations = zeros(1, num_years);

% Calculate the exponential growth for each year
for year = 1:num_years
    time(year) = year;
    populations(year) = initial_population * exp(growth_rate * year);
end

% Plot the exponential growth
figure;
plot(time, populations, '-o', 'LineWidth', 2, 'MarkerSize', 8);
title('Exponential Growth');
xlabel('Year');
ylabel('Population');
grid on;
