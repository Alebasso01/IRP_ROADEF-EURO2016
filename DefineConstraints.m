%% 3) Constraints

%% TRAILER'S CONSTRAINTS

% updating the level of each trailer 
for t=2:numHours 
    for i=1:numTrailers
        prob.Constraints.(['trailerInventoryLevel', num2str(i), '_', num2str(t)]) = CurrentLevelTrailer(i,t) == CurrentLevelTrailer (i,t-1) - sum(q(:,t-1));
    end
end 

% the sum of the quantities delivered must not exceed the capacity of the trailer
for j = 1:numTrailers
    for t = 1:numHours
        prob.Constraints.(['trailerCapacity_', num2str(j), '_', num2str(t)]) = sum(q(:, t)) <= capacityTrailers(j);
    end
end

%% CUSTOMER'S CONSTRAINTS

% updating the inventory level of each customer 
for c=1:numCustomers
    for t=2:numHours
        prob.Constraints.(['customerInventoryLevel', num2str(c), '_', num2str(t)]) = CurrentLevelInventoryCustomer(c,t) == CurrentLevelInventoryCustomer(c,t-1) + q(c,t-1);
    end 
end

% the inventory level of each customer must not be lower than safety level
for c=1:numCustomers
    for t =1:numHours
        prob.Constraints.(['safetyLevel', num2str(c), '_', num2str(t)]) = CurrentLevelInventoryCustomer(c,t) >= safetyLevels(c);
    end
end 

% the inventory level for each customer must not exceed the maximum capacity
for c=1:numCustomers
    for t = 1:numHours
        prob.Constraints.(['customerCapacity', num2str(c), '_', num2str(t)]) = CurrentLevelInventoryCustomer(c,t) <= capacityCustomers(c);
    end
end

%% QUANTITY'S CONSTRAINTS 

% I have to deliver as much as possible what is missing to reach inventory capacity
for c=1:numCustomers
    for t=1:numHours
        prob.Constraints.(['orderUpToLevel', num2str(c), '_', num2str(t)]) = q(c,t) <= capacityCustomers(c)-CurrentLevelInventoryCustomer(c,t);
    end
end


%% DRIVER'S CONSTRAINTS

% each driver has a minimum rest between two shifts
for i = 1:numDrivers

    lengthTimeWindows = length(data.drivers{1, i}.timewindows); 

    for k = 1:lengthTimeWindows-1 
        
        % end shift and start shift
        endTimeCurrentWindow = data.drivers{1, i}.timewindows{1, k}.end / unit;  
        startTimeNextWindow = data.drivers{1, i}.timewindows{1, k+1}.start / unit;  
        
        prob.Constraints.(['restTime_', num2str(i), '_', num2str(k)]) = ...
            startTimeNextWindow - endTimeCurrentWindow >= minInterShiftDurations(i);
    end
end



% the total driving time of each driver must not exceed maxdrivingtime
for i = 1:numDrivers
    for t = 1:numHours/numDays
        for d=1:numDays
            % total driving time for driver i at time t on day d
            drivingTime = sum(x(i, :, t)); 
            prob.Constraints.(['maxDrivingTime_', num2str(i), '_', num2str(t)]) = drivingTime <= data.drivers{i}.maxDrivingDuration;
            drivingTime = 0;
        end
    end
end


%% BIG M CONSTRAINTS

% big M constraint to connect x and y
for i = 1:numDrivers
    for j = 1:numTrailers
        for c = 1:numCustomers
            for t = 1:numHours
                
                prob.Constraints.(['bigM_x_y_', num2str(i), '_', num2str(j), '_', num2str(c), '_', num2str(t)]) = y(i, j, c, t) <= BigM * x(i, j, t);
            end
        end
    end
end

% big M constraint to connect x and z
for i = 1:numDrivers
    for j = 1:numTrailers
        for t = 1:numHours

            prob.Constraints.(['bigM_x_z_', num2str(i), '_', num2str(j), '_', num2str(t)]) = x(i, j, t) <= BigM * z(i, t);
        end
    end
end

% big M constraint to connect q and z
for c = 1:numCustomers
    for t = 1:numHours
        
        prob.Constraints.(['bigM_q_z_', num2str(c), '_', num2str(t)]) = q(c, t) <= BigM * sum(z(:, t));
    end
end

disp('Constraints definition completed.');