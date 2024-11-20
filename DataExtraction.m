% DataExtraction.m

if ~exist('xmlData', 'var')
    error('La variabile xmlData non esiste nel workspace. Esegui prima XMLReading.m per generarla.');
end

data = struct();

instance = xmlData.IRP_Roadef_Challenge_Instance;

% time unit 
if isfield(instance, 'unit')
    data.unit = str2double(instance.unit.Text);
end

% time horizon
if isfield(instance, 'horizon')
    data.horizon = str2double(instance.horizon.Text);
end

% timeMatrices
if isfield(instance, 'timeMatrices') && isfield(instance.timeMatrices, 'ArrayOfInt')
    timeMatrices = instance.timeMatrices.ArrayOfInt;
    if ~iscell(timeMatrices)
        timeMatrices = {timeMatrices};
    end
    data.timeMatrices = cellfun(@(x) extractIntValues(x), timeMatrices, 'UniformOutput', false);
else
    data.timeMatrices = {};
end

% drivers
if isfield(instance, 'drivers') && isfield(instance.drivers, 'IRP_Roadef_Challenge_Instance_driver')
    drivers = instance.drivers.IRP_Roadef_Challenge_Instance_driver;
    if ~iscell(drivers)
        drivers = {drivers};
    end
    data.drivers = cellfun(@(x) extractDriverData(x), drivers, 'UniformOutput', false);
else
    data.drivers = [];
end

% trailers
if isfield(instance, 'trailers') && isfield(instance.trailers, 'IRP_Roadef_Challenge_Instance_Trailers')
    trailers = instance.trailers.IRP_Roadef_Challenge_Instance_Trailers;
    if ~iscell(trailers)
        trailers = {trailers};
    end
    data.trailers = cellfun(@(x) extractTrailerData(x), trailers, 'UniformOutput', false);
else
    data.trailers = [];
end

% bases
if isfield(instance, 'bases') && isfield(instance.bases, 'index')
    bases = instance.bases.index;
    if ~iscell(bases)
        bases = {bases};
    end
    data.bases = cellfun(@(x) str2double(x.Text), bases);
else
    data.bases = [];
end

% sources
if isfield(instance, 'sources') && isfield(instance.sources, 'IRP_Roadef_Challenge_Instance_Sources')
    sources = instance.sources.IRP_Roadef_Challenge_Instance_Sources;
    if ~iscell(sources)
        sources = {sources};
    end
    data.sources = cellfun(@(x) extractSourceData(x), sources, 'UniformOutput', false);
else
    data.sources = [];
end

% customers
if isfield(instance, 'customers') && isfield(instance.customers, 'IRP_Roadef_Challenge_Instance_Customers')
    customers = instance.customers.IRP_Roadef_Challenge_Instance_Customers;
    if ~iscell(customers)
        customers = {customers};
    end
    data.customers = cellfun(@(x) extractCustomerData(x), customers, 'UniformOutput', false);
else
    data.customers = [];
end

% DistMatrices
if isfield(instance, 'DistMatrices') && isfield(instance.DistMatrices, 'ArrayOfDouble')
    distMatrices = instance.DistMatrices.ArrayOfDouble;
    if ~iscell(distMatrices)
        distMatrices = {distMatrices};
    end
    data.DistMatrices = cellfun(@(x) extractDoubleValues(x), distMatrices, 'UniformOutput', false);
else
    data.DistMatrices = {};
end

% store data in a variabile in the workspace
assignin('base', 'data', data);

% delete other variables in the workspace 
clearvars -except data;



%% Functions 

% function helper to extract value from <int>
function values = extractIntValues(arrayOfInt)
    if isfield(arrayOfInt, 'int')
        intValues = arrayOfInt.int;
        if ~iscell(intValues)
            intValues = {intValues};
        end
        values = cellfun(@(x) str2double(x.Text), intValues);
    else
        values = [];
    end
end

% function helper to extract value from <double>
function values = extractDoubleValues(arrayOfDouble)
    if isfield(arrayOfDouble, 'double')
        doubleValues = arrayOfDouble.double;
        if ~iscell(doubleValues)
            doubleValues = {doubleValues};
        end
        values = cellfun(@(x) str2double(x.Text), doubleValues);
    else
        values = [];
    end
end

% function helper to extract data from driver
function driver = extractDriverData(driverNode)
    driver.index = getFieldAsDouble(driverNode, 'index');
    driver.maxDrivingDuration = getFieldAsDouble(driverNode, 'maxDrivingDuration');
    driver.timewindows = extractTimeWindows(driverNode.timewindows);
    driver.trailer = getFieldAsDouble(driverNode, 'trailer');
    driver.minInterSHIFTDURATION = getFieldAsDouble(driverNode, 'minInterSHIFTDURATION');
    driver.TimeCost = getFieldAsDouble(driverNode, 'TimeCost');
end

% function helper to extract data from time windows
function timewindows = extractTimeWindows(timewindowsNode)
    if isfield(timewindowsNode, 'TimeWindow')
        timeWindows = timewindowsNode.TimeWindow;
        if ~iscell(timeWindows)
            timeWindows = {timeWindows};
        end
        timewindows = cellfun(@(x) struct('start', str2double(x.start.Text), 'end', str2double(x.end.Text)), timeWindows, 'UniformOutput', false);
    else
        timewindows = [];
    end
end

% function helper to extract data from trailers
function trailer = extractTrailerData(trailerNode)
    trailer.index = getFieldAsDouble(trailerNode, 'index');
    trailer.Capacity = getFieldAsDouble(trailerNode, 'Capacity');
    trailer.InitialQuantity = getFieldAsDouble(trailerNode, 'InitialQuantity');
    trailer.DistanceCost = getFieldAsDouble(trailerNode, 'DistanceCost');
end

% function helper to extract data from sources
function source = extractSourceData(sourceNode)
    source.index = getFieldAsDouble(sourceNode, 'index');
    source.setupTime = getFieldAsDouble(sourceNode, 'setupTime');
end

% function helper to extract data from customers
function customer = extractCustomerData(customerNode)
    customer.index = getFieldAsDouble(customerNode, 'index');
    customer.setupTime = getFieldAsDouble(customerNode, 'setupTime');
    customer.allowedTrailers = extractAllowedTrailers(customerNode.allowedTrailers);
    customer.Forecast = extractForecastValues(customerNode.Forecast);    
    customer.Capacity = getFieldAsDouble(customerNode, 'Capacity');
    customer.InitialTankQuantity = getFieldAsDouble(customerNode, 'InitialTankQuantity');
    customer.SafetyLevel = getFieldAsDouble(customerNode, 'SafetyLevel');
end

% function helper to extract data from allowed trailers
function allowedTrailers = extractAllowedTrailers(allowedTrailersNode)
    if isfield(allowedTrailersNode, 'int')
        intValues = allowedTrailersNode.int;
        if ~iscell(intValues)
            intValues = {intValues};
        end
        allowedTrailers = cellfun(@(x) str2double(x.Text), intValues);
    else
        allowedTrailers = [];
    end
end

% function helper to extract data from Forecast 
function forecast = extractForecastValues(forecastNode)
    if isfield(forecastNode, 'double')
        doubleValues = forecastNode.double;
        if ~iscell(doubleValues)
            doubleValues = {doubleValues};
        end
        forecast = cellfun(@(x) str2double(x.Text), doubleValues);
    else
        forecast = [];
    end
end 

% function helper to obtain a field double
function value = getFieldAsDouble(node, fieldName)
    if isfield(node, fieldName) && isfield(node.(fieldName), 'Text')
        value = str2double(node.(fieldName).Text);
    else
        value = NaN;
    end
end
