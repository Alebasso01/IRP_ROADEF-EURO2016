# Inventory Routing Problem for ROADEF-EURO Challenge 2016

This project implements a strategy to solve the Inventory Routing Problem (IRP) based on the instances provided for the [ROADEF/EURO Challenge 2016](https://www.roadef.org/challenge/2016/en/). The implementation is done using **MATLAB**.

## Project Overview

The instances of the IRP for the ROADEF/EURO Challenge 2016 are available at this [webpage](https://roadef.org/challenge/2016/en/instances.php). In this project, we use the instances from *Version 1.1 - Set A*. A brief description of each instance is available in the file *InstancesDescription.txt*.

Each instance is represented as an **XML file**, structured hierarchically with the following information:

- **Optimization horizon**
- **Time matrices** between nodes
- **Drivers**: index, maximum driving duration, time windows, assigned trailers, time cost
- **Trailers**: index, capacity, initial quantity, distance cost
- **Bases**: index, setup time
- **Sources**: index, setup time
- **Customers**: index, setup time, allowed trailers, forecast demand, inventory capacity, safety level, initial tank quantity
- **Distance matrices** between nodes

### Solution Format

The solution is expected as a list of shifts, each including:

- Shift index
- Driver index
- Trailer index
- Start time
- An operation list, with:
  - Arrival point
  - Arrival time
  - Loaded quantity

## Requirements

Ensure the following toolboxes and features are installed in your MATLAB environment:

- Optimization Toolbox
- xml2struct
  

## How to Use the Project

1. **Reading the XML file**  
  Run the `XmlReader.m` script, specifying the name of the XML file corresponding to the desired instance. This script loads and parses the data into MATLAB Workspace.
  
2. **Data extraction**  
  Run `DataExtraction.m` to extract and structure the instance's information into MATLAB workspace variables.
  
3. **Define problem parameters**  
  Use `DefineParameters.m` to read the workspace data and set up the initial problem parameters required for the optimization process.
  
4. **Define decision variables**  
  Execute `DefineDecisionVariables.m` to establish the decision variables and the objective function using the `optimvar` functionality from the Optimization Toolbox.
  
5. **Define constraints**  
  Run `DefineConstraints.m` to encode the main constraints of the problem, also utilizing the `optimvar` library.
  
6. **Solve the problem**  
  Use `DefineSolution.m` to configure the solver, define its options, and compute the solution using the defined parameters, variables, and constraints.
  

## Acknowledgments

This project was developed to explore real-world optimization problems as part of the academic exam [Industrial Automation](https://corsi.unige.it/off.f/2021/ins/51470) during Master's degree in Computer Engineering at the University of Genova. The instances and problem formulation are based on the official [ROADEF/EURO Challenge 2016](https://www.roadef.org/challenge/2016/en/).
