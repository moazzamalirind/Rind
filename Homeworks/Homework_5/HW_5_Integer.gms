$ontext
CEE 6410 - Water Resources Systems Analysis
Example 7.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE PROBLEM:

A farmer plans to develop water for irrigation. He is considering two possible sources of water:
a gravity diversion from a possible reservoir with two alternative capacities and/or a pump from
a lower river diversion . Between the reservoir and pump site the river base flow increases by 2 acft/day
due to groundwater drainage into the river. Ignore losses from the reservoir. The river flow into the reservoir
and the farmer's demand during each of two six-month seasons of the year are given in Table 7.5.
Revenue is estimated at $300 per year per acre irrigated.

Table 7.5: Seasonal Flow and Demand
Season,           t River Inflow,Qt (acft)      Irrigation Demand (acft/acre)
1                     600                                   1.0
2                     200                                   3.0
Assume that there are only two possible sizes of reservoir: a high dam that has capacity of 700 acft
or a low dam with capacity of 300 acft. The capital costs are $10,000/year and $6,000/year for the high
and low dams, respectively (no operating cost). The pump capacity is fixed at 2.2 acft/day with a capital cost
(if it is built) of $8,000/year and operating cost of $20/acft.


Moazzam Ali Rind
moazzamalirind@gmail.com
October 4, 2020
$offtext


* 1. Define the sets
Sets
Loc          Location / res "at Reservior", pump " at pump", river "Reservior release to the River", farm "Reservior release to the farm"/
Time         Time in seasons /season1, season2/
*The given problem divides the whole year in two seasons of six months each
size         Size of reservior /size0, size1,size2/;

* 2. Define the input data
Parameters

Res_capacity(size)       Capacity of the reservior constructed (acft) / size0 0, size1 300, size2 700/
Res_capCost(size)        Capital cost of reservior construction ($ per year) / size0 0, size1 6000, size2 10000/
Inflow(Time)             Inflows to the system during the simulation period (acft) /Season1 600, Season2 200/
Demand(Time)             Seasonal Irrigation demands (acft per acre) /Season1 1, Season2 3/ ;

Scalars
Pump_Capacity            Maximum pump capacity (acft per season) /401.5/
* Given is pump capacity in acft/day. Which means for the 6 months seaason will be : (2.2* 365)/2 = 401.5 acft per season
Pump_capCost             Capital cost for building the pump ($ per year) /8000/
Pump_optCost             operational cost of the pump ($ per acreft) /20/
Groundwater              Amount of ground water inflows (acft per season) /365/
Irri_Revenue             Revenue earn per year per acre irrigated/300/
;


* 3. Define the Variables
variables

X(Loc,Time)             Flows at a given location (Loc) on a given time (Time) (acft)
R(Loc,size)             Binary decision to build  reservior of a size (Size) (1=yes 0=no)
P(Loc)                  Binary decision to build  Pump (1=yes 0=no)
Area                    Area irrigated (acres)
Benefit                Total benefits($);

*Non Negativity constraint
Binary variables R,P;
Positive variables X;

* 4.Define the equations

Equations
Total_Benefits                Objective function to calculate the total benefits ($)
Pump_Cap(Time)                Maximum Pump capacity constaint at all timesteps  (acft)
Dam_Build                     Constraint to make sure that only build one reservior at a time
ResStorage(Time)              Constriant to keep resevior storage less than or equal to built capacity at all times (acft)
MassBlc_stream(Time)          Mass balance at stream loaction (acft)
MassBlc_iniRes                Inital timestep Reservior mass balance (acft)
MassBlc_Res(Time)             Reservior mass balance in all t>1 timesteps (acft)
Area_Irr(Time)                Area irrigated (acres);



Total_Benefits ..               Benefit =e= (Irri_Revenue*Area)- sum(size, Res_capCost(size)*R('res',size))- Pump_capCost*P('pump') - sum(Time,Pump_optCost* X('pump',Time));
Pump_Cap(Time)..                X('pump',Time)=l= Pump_Capacity* P('pump');
Dam_Build..                     1 =e=  sum (size, R('res',size));
ResStorage(Time)..              X('res',Time)=l= sum (size, Res_capacity(size)*R('res',size));
MassBlc_stream(Time)..          X('pump',Time)=l= X('river',Time)+ Groundwater;
MassBlc_iniRes..                X('res','season1')=e= Inflow('season1')- X('river','season1')- X('farm','season1');
*There is no intial storage available in given model. Hence its igonred in Initial reservior mass balance equation
MassBlc_Res(Time)$(ord(Time) ge 2)..      X('res',Time)=e= Inflow(Time)+ X('res',Time-1)- X('river',Time)- X('farm',Time);
Area_Irr(Time)..                       Area=l= (X('farm',Time)+X('pump',Time))/Demand(Time) ;

* 5.Define a model for the equations

Model Integer_problem /all/;


* 6. Solution statement
SOLVE Integer_problem USING MIP Maximize Benefit;

