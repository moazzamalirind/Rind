$ontext

CEE 6410 - Water Resources Systems Analysis
Irrigation Development Problem

Problem Discription: ...................


Moazzam Rind
moazzamalirind@gmail.com
September 20, 2015
$offtext

Sets
T                       Time in months /June,July,August/
;

Parameters
*Given data
Hay_Req(T)              Monthly water requirement for Hay crop (acft per acre)/June 2, July 1,August 1/
Grain_Req(T)            Monthly water requirement for Grain crop (acft per acre)/June 1, July 2,August 0/
;

Positive variables
X_Hay                Land allocated to Hay crop during time T(acres)
X_Grain              Land allocated to Grain crop during time T (acres);

Variable
Max_Z                   Total benefit from the Irrigation development i.e. objective function value ($);

Scalars
Avail_land               Total available land (acres) /10000/
June_Water               Available water in June (acft)/14000/
July_Water               Available water in July (acft) /18000/
August_Water             Available water in August (acft) /6000/
Rate_Hay                 Return from Hay crop ($ per acre) /100/
Rate_Grain               Return from Grain crop ($ per acre) /120/
;

Equations

Max_benefit                 Objective function i.e. to maximize the benefit from irrigation development($)
Land_Constraint             Total Land available
Water_June                  Water available in June ~ constraint (acft)
Water_July                  Water available in July ~ constraint (acft)
Water_August                Water available in August ~ constraint (acft)

;

*Objective function (i.e Maximize Benefits).

Max_benefit..                    Max_Z =e= Rate_Hay* X_Hay + Rate_Grain* X_Grain;

*constraints
Land_Constraint..                 X_Hay + X_Grain =l= Avail_land;
Water_June..                      X_Hay *Hay_Req("June")+  X_Grain * Grain_Req("June") =l= June_Water;
Water_July..                      X_Hay *Hay_Req("July")+  X_Grain * Grain_Req("July") =l= July_Water;
Water_August..                    X_Hay *Hay_Req("August")+  X_Grain* Grain_Req("August") =l= August_Water;



*  Defininig a model having all equations
MODEL Benefit /ALL/;

Option LP= conopt;
*Selection of Solver


SOLVE Benefit USING LP MAXIMIZING Max_Z;
*Solution Statement


