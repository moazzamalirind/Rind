$ontext

CEE 6410 - Water Resources Systems Analysis
Reservior Problem
A reservoir is designed to provide hydropower and water for irrigation.  The turbine releases may also be used for irrigation.
At least one unit of water must be kept in the river each month at point A.  The hydropower turbines have a capacity of 4 units
of water per month (flows are constant during any single month), and any other releases must bypass the tur-bines.
The size of farmed area is very large relative to the amount of irrigation water available, so there is no upper limit on usable irrigation water.
The reservoir has a capacity of 9 units, and initial storage is 5 units of water.  The ending storage must be equal to or greater than the beginning storage.
The benefits per unit of water, and the estimated average inflows to the reservoir are given in Table 1.

*******
Table 1
********
Month    Inflow Units        Hydropower Benefits ($/unit)        Irrigation Benefits ($/unit)
1            2                     1.6                                 1.0
2            2                     1.7                                 1.2
3            3                     1.8                                 1.9
4            4                     1.9                                 2.0
5            3                     2.0                                 2.2
6            2                     2.0                                 2.2




Moazzam Rind
moazzamalirind@gmail.com
September 24, 2020
$offtext

Sets

Loc                     Location /Reservior "Reservior",Spill "Spill",Turbine "Hydropower",Flow_at_A "Flow at Point A" ,Irrigation "Irrigation"/
T                       Time in months /M1*M6/
;

Parameters
*Given data
Inflow(T)                Inflow volume (Inflow units) during time T /M1 2,M2 2,M3 3,M4 4,M5 3,M6 2/
hb(T)                    Hydropower Benefits ($ per unit)/M1 1.6,M2 1.7,M3 1.8,M4 1.9,M5 2,M6 2/
ib(T)                    Irrigation Benefits ($ per unit)/M1 1,M2 1.2,M3 1.9,M4 2,M5 2.2,M6 2.2/

;

Positive variables
X(Loc,T)                Water volume at location Loc at time T  (volume units);
*                       For reservior loaction it's storage volume and at other locations it's flow (volume/time)

Variable
Max_Z                   Objective Function value


Scalars
Initial_storage          Water avialable in reservior at start (volume)/5/
capacity_Reservior       Storage capacity of the Reservior (volume) /9/
ReqWater_PointA          Minimum water required at point A (volume per time) /1/
MaxTurbine_capacity      Maximum capacity of the turbine (volume per time)/4/
;

Equations

Max_benefit                 Objective function i.e. to maximize the benefit ($)
Reservior_capacity(T)       Reservior capacity constraint (volume)
PointA_Constraint(T)        Minimum flow constraint at point A (volume per time)
EndStorage_Constraint       Ending storage in reservior constraint (volume)
Turbine_capacity(T)         Maximum volume turbine can pass per time T (Volume per time)
Massbalance_pointB(T)       Max balance at point B at any time T
Reservior_Massbalance(T)    Reservior Mass balance (Volume)
Initial_Reservior(T)        Reservior Mass balance at first timestep (Volume)
;

*Objective function (i.e Maximize Benefits) and all constraints.
Max_benefit..                    Max_Z =e= sum (T,hb(T)* X("Turbine",T)+ ib(T)* X("Irrigation",T));
Reservior_capacity(T)..          X("Reservior",T)=l= capacity_Reservior;
PointA_Constraint(T)..           X("Flow_at_A",T)=g= ReqWater_PointA ;
EndStorage_Constraint..          X("Reservior","M6") =g= Initial_storage;
Turbine_capacity(T)..            X("Turbine",T)=l= MaxTurbine_capacity;
Massbalance_pointB(T)..          X("Turbine",T)+  X("Spill",T) =e=  X("Irrigation",T)+X("Flow_at_A",T);
Reservior_Massbalance(T)$(ord(T) gt 1)..     X("Reservior",T) =e= X("Reservior",T-1)+Inflow(T)-X("Spill",T)- X("Turbine",T);
Initial_Reservior(T)$(ord(T) eq 1)..         X("Reservior",T) =e= Initial_storage + Inflow(T) -X("Spill",T)- X("Turbine",T);


*  Primary model
MODEL Benefit /Max_benefit,Reservior_capacity,PointA_Constraint,EndStorage_Constraint,Turbine_capacity,Massbalance_pointB,Reservior_Massbalance,Initial_Reservior/;




********************************************************************************
* Model with increased instream flow requirement

parameter

AddWater_PointA          Minimum water required at point A (volume per time)/2/;
* Increased instream flow requiment from one to two

Equations
NewPointA_Constraint(T)        Minimum flow constraint at point A (volume per time);
NewPointA_Constraint(T)..           X("Flow_at_A",T)=g= AddWater_PointA ;

* Define model having increased instream flow requirement
MODEL PointA /Max_benefit,Reservior_capacity,NewPointA_Constraint,EndStorage_Constraint,Turbine_capacity,Massbalance_pointB,Reservior_Massbalance,Initial_Reservior/;




********************************************************************************
*Model with one more unit of water for months 1, 2, and 3.
parameter

New_Inflow(T)                Inflow volume (Inflow units) during time T /M1 3,M2 3,M3 4,M4 4,M5 3,M6 2/;
* one  additional unit inflow during first three months.

Equations
NewReservior_Massbalance(T)        Reservior Mass balance (Volume)
NewInitial_Reservior(T)            Reservior Mass balance at first timestep (Volume);

NewReservior_Massbalance(T)$(ord(T) gt 1)..     X("Reservior",T) =e= X("Reservior",T-1)+New_Inflow(T)-X("Spill",T)- X("Turbine",T);
NewInitial_Reservior(T)$(ord(T) eq 1)..         X("Reservior",T) =e= Initial_storage + New_Inflow(T) -X("Spill",T)- X("Turbine",T);;

* Define model for increased inflow condition
MODEL AddedInflows /Max_benefit,Reservior_capacity,PointA_Constraint,EndStorage_Constraint,Turbine_capacity,Massbalance_pointB,NewReservior_Massbalance,NewInitial_Reservior/;

*******************************************************************************



********************************************************************************
*Model to find that at which instream flow requirement the solution change its basis

Set
RUN                             Runs /r1*r5/;
*To make model run 5 times with different  inflow requirement values

parameters
Water_PointA(RUN)         Minimum water required at point A (volume per time)/r1 1,r2 2,r3 3,r4 4,r5 5/
* Increased instream flow requiment
Obj_Value(RUN)                  Save objective function value under different runs
Turbine_variable(RUN,T)         save decision variable (flow through turbine) under different runs
Irrigation_variable(RUN,T)      save decision variable (Flow to irrigation) under different runs
FlowRate_A                       Flow rate at point A (volume per time);

Equation
FlowA(T)                         flow rate at point A (volume per time);

FlowA(T)..                       X("Flow_at_A",T)=g= FlowRate_A;


* Define model having increased instream flow requirement
MODEL ChangeBasis /Max_benefit,Reservior_capacity,FlowA,EndStorage_Constraint,Turbine_capacity,Massbalance_pointB,Reservior_Massbalance,Initial_Reservior/;

loop(RUN,
   FlowRate_A= Water_PointA(RUN);

*    Initialize decision variable values to zero
    X.L("Turbine",T) = 0;
    X.L("Irrigation",T)=0;

SOLVE ChangeBasis USING LP MAXIMIZING Max_Z;
    Obj_Value(RUN)= Max_Z.L;
    Turbine_variable(RUN,T)= X.L("Turbine",T);
    Irrigation_variable(RUN,T)= X.L("Irrigation",T);
);


*******************************************************************************





*Solve statements for defined models
SOLVE Benefit USING LP MAXIMIZING Max_Z;
SOLVE PointA USING LP MAXIMIZING Max_Z;
SOLVE AddedInflows USING LP MAXIMIZING Max_Z;


* Dump all input data and results to a GAMS gdx file
Execute_Unload "Reservior.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls Reservior.gdx"
















