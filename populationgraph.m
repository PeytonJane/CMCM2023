transmission = 0.3;
CALC_SQ_MI = 881.823;

people = 76248;
max_ppl = 2736074;

num_years = 15;
time = 1:num_years;
r = 0.7623; 

intrinsic_rates = linspace(0.6847, 0.8399, 25);
colors = winter(length(intrinsic_rates));

initial_populations = [0.0, 0.3, 0.7];

figure;

for j = 1:length(initial_populations)
    initial_population = initial_populations(j);
    
    % Initialize arrays to store population values
    population_matrix = zeros(length(intrinsic_rates), num_years);
    
    subplot(1, 3, j);
    hold on;
    
    for i = 1:length(intrinsic_rates)
        r = intrinsic_rates(i);
        
        population = zeros(1, num_years);
        
        for year = 1:num_years
            if year == 1
                population(year) = initial_population;
            else
                new_population = population(year - 1) + population(year - 1) * r * (1 - population(year - 1)) + transmission * (1 - 1/CALC_SQ_MI) * (people / max_ppl);
                
                % Ensure that the population does not exceed 1
                population(year) = min(new_population, 1);
            end
        end
        
        population_matrix(i, :) = population;
        
        line('XData', time, 'YData', population, 'LineWidth', 1.5, 'Color', colors(i, :));
    end
    
    title(['Initial Population = ' num2str(initial_population)]);
    xlabel('Year');
    ylabel('Population');
    grid on;
    
    % Set axis limits
    ylim([0, 1]);
    
    hold off;
end

c = colorbar('Ticks', linspace(0, 1, 5));
caxis([min(intrinsic_rates), max(intrinsic_rates)]);
colormap(winter);

ylabel(c, 'Intrinsic Rate (r)');

sgtitle('Cayuga County Percent of Affected Farms with Varying Intrinsic Rates and Initial Populations');
