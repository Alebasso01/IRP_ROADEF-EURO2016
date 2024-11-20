%% 1) Reading data

prob = optimproblem('ObjectiveSense', 'min');

% basic parameters
unit = data.unit;
numCustomers = length(data.customers);  
numDays = data.horizon / 24;
numHours = data.horizon;  
numMinutes = data.horizon * data.unit;  
numTrailers = length(data.trailers);   
numDrivers = length(data.drivers); 
numBases = length(data.bases); 
numSources = length(data.sources);  
numPoints = numSources + numBases + numCustomers;

% max driving duration for each driver 
maxDrivingDuration = zeros(1, numDrivers);
for i = 1:numDrivers
    maxDrivingDuration(i) = data.drivers{1, i}.maxDrivingDuration/unit; 
end

% min intershift duration for each driver
minInterShiftDurations = zeros(1, numDrivers);
for i = 1:numDrivers
    minInterShiftDurations(i) = data.drivers{1, i}.minInterSHIFTDURATION/unit; 
end

% time windows for each driver
% generating 2 tables with start shift and end shift per driver
maxLengthTimeWindows = max(cellfun(@(d) length(d.timewindows), data.drivers));

timeWindows = zeros(maxLengthTimeWindows, 2, numDrivers);

for i = 1:numDrivers
    lengthTimeWindows = length(data.drivers{1, i}.timewindows); % Numero di turni per driver
    
    for k = 1:lengthTimeWindows
        timeWindows(k, :, i) = [data.drivers{1, i}.timewindows{1, k}.start/unit, ...
                                data.drivers{1, i}.timewindows{1, k}.end/unit];
    end
end



% customers and trailers capacities
capacityCustomers = zeros(1, numCustomers);
CurrentLevelInventoryCustomer = zeros(numCustomers, numHours);
for i = 1:numCustomers
    capacityCustomers(i) = data.customers{1, i}.Capacity;
    CurrentLevelInventoryCustomer(i) = data.customers{1, i}.InitialTankQuantity;
end

capacityTrailers = zeros(1, numTrailers);
CurrentLevelTrailer = zeros(numTrailers, numHours);
for i = 1:numTrailers
    capacityTrailers(i) = data.trailers{1, i}.Capacity;
    CurrentLevelTrailer(i) = data.trailers{1, i}.InitialQuantity;
end

% safety level for each customer
safetyLevels = zeros (1, numCustomers);
for i=1:numCustomers
    safetyLevels(i) = data.customers{1, i}.SafetyLevel;
end 

% parameters fpr each travel time
timeMatrix = [];
for i = 1:size(data.timeMatrices, 2)
    timeMatrix = [timeMatrix; data.timeMatrices{1, i}/unit];
end

% parameters for distance
distMatrix = [];
for i = 1:size(data.DistMatrices, 2)
    distMatrix = [distMatrix; data.DistMatrices{1, i}];
end


% TimeCostDrivers
timeCostDrivers = zeros(1, numDrivers);
for i = 1:numDrivers
    timeCostDrivers(i) = data.drivers{1, i}.TimeCost; 
end

% timeCostTrailers matrix
timeCostTrailers = zeros(1, numTrailers);
for i = 1:numTrailers
    timeCostTrailers(i) = data.trailers{1, i}.DistanceCost; 
end

% allowed trailers for each customer
% nan if a trailer is not allowed, otherwise index of the trailer
maxLength = max(cellfun(@length, {data.customers{:,1}.allowedTrailers})); 
allowedTrailersCustomers = nan(numCustomers, maxLength); 
for i = 1:numCustomers
    currentTrailers = data.customers{1, i}.allowedTrailers;
    allowedTrailersCustomers(i, 1:length(currentTrailers)) = currentTrailers;
end


% forecast customer = request of each customer at time t
customersForecast = [];
for i = 1:numCustomers
    customersForecast = [customersForecast; data.customers{1, i}.Forecast];
end

% BigM
BigM = 10000; 