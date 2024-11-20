%% 2) Problem Definition


% x: driver i uses trailer j at time t 
x = optimvar('x', numDrivers, numTrailers, numHours, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);

% y: driver i uses trailer j and delivery to customer c at time t 
y = optimvar('y', numDrivers, numTrailers, numCustomers, numHours, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);

% q: quantity delivered to customer c at time t 
q = optimvar('q', numCustomers, numHours, 'LowerBound', 0);

% z: driver i is active at time t 
z = optimvar('z', numDrivers, numHours, 'Type', 'integer', 'LowerBound', 0, 'UpperBound', 1);


% total cost for drivers
for d=1:numDrivers
    for t=1:numHours
        totalTransportCostDrivers = sum(timeCostDrivers(d)*z(d,t));
    end 
end 

% total cost for trailers
for i=1:numTrailers
    for t=1:numHours
        totalTransportCostTrailers = sum(timeCostTrailers(i)*x(:,i,t));
    end 
end 

% total objective function
totalTransportCost = totalTransportCostDrivers + totalTransportCostTrailers;

prob.Objective = totalTransportCost;