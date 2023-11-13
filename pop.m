transmission = 0.3;
CALC_SQ_MI = 881.823;

people = 76248;
max_ppl = 2736074;

num_years = 15;
time = 1:num_years;

intrinsic_rate = 0.765; % Set intrinsic growth rate

% Initial populations to consider
initial_populations = [0.0, 0.3, 0.7];

% Define color map from light blue to deep blue
colors = winter(length(initial_populations));

% Plot the results with varying line colors for each initial population
figure;

% Initialize arrays to store population values
population_matrix = zeros(length(initial_populations), length(time));

hold on;

% Plot the results for each initial population
for j = 1:length(initial_populations)
    initial_population = initial_populations(j);

    % Calculate population for each year using the given formula
    for year = 1:num_years
        if year == 1
            % Initial population
            population_matrix(j, year) = initial_population;
        else
            % Population growth formula
            new_population = population_matrix(j, year - 1) + population_matrix(j, year - 1) * intrinsic_rate * (1 - population_matrix(j, year - 1)) + transmission * (1 - 1/CALC_SQ_MI) * (people / max_ppl);

            % Ensure that the population does not exceed 1
            population_matrix(j, year) = min(new_population, 1);
        end
    end

    % Plot the current line with varying color
    line('XData', time, 'YData', population_matrix(j, :), 'LineWidth', 1.5, 'Color', colors(j, :));
end

%title(['Population Growth with Intrinsic Rate = ' num2str(intrinsic_rate * 100) '%']);
xlabel('Year');
ylabel('Population');
grid on;

% Set axis limits
ylim([min(initial_populations), 1]);

hold off;

% Add a colorbar
c = colorbar('Ticks', linspace(0, 1, 5));
caxis([min(initial_populations), max(initial_populations)]); % Set colorbar limits
colormap(winter);

ylabel(c, 'Initial Population');

% Add legend
legend(cellstr(num2str(initial_populations', 'Initial Population = %0.1f')));

% Adjust layout
sgtitle('Population Growth with Varying Initial Populations');
