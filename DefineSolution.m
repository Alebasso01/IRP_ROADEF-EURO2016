%% 4) Set solver options and solve the problem

% solver's options
options = optimoptions('intlinprog', ...  
                       'UseParallel', true, ...  
                       'IntegerTolerance', 1e-3, ...  % tolleranza sugli errori
                       'MaxTime', 3600, ...  
                       'Display', 'off');  

% solver
[solution, cost] = solve(prob, 'options', options);

if isempty(solution)
    disp('No solution found.');
else
    disp('Solution successfully found.');  
    disp(['Total cost of solution: ' num2str(cost)]);  
end