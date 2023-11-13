function plot_monthly_temperatures()
    % Temperature data for Seoul
    seoul_temps = [-2.07, 1.21, 7.38, 13.23, 19.56, 24.36, 26.49, 27.55, 22.99, 16.73, 9.04, 0.25];
    
    % Temperature data for New York
    ny_temps = [0.31, 1.54, 5.43, 11.33, 17.33, 22.45, 26.27, 25.2, 21.56, 15.37, 8.53, 3.94];

    % Define the months
    months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};

    % Create a line plot
    figure;
    plot(1:12, seoul_temps, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Seoul');
    hold on;
    plot(1:12, ny_temps, '-s', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'New York');
    hold off;

    % Add labels and title
    title('Monthly Temperatures')
    xlabel('Month')
    ylabel('Temperature (Celsius)')
    xticks(1:12)
    xticklabels(months)
    legend('Location', 'Best')
end
