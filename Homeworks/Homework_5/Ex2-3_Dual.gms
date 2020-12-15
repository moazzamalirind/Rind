$ontext

CEE 6410 - Water Resources Systems Analysis
Irrigation Development Problem

Problem #3 of Chapter 2 from Water Resources System Analysis book by Bishop et al.,

Dual settings

Moazzam Rind
moazzamalirind@gmail.com
September 29, 2020
$offtext

Sets
T                       Time in months /June,July,August/
Y                       Dual variables/Land,June,July,August/
;

Parameters
*Given data
Hay_Req(T)              Monthly water requirement for Hay crop (acft per acre)/June 2, July 1,August 1/
Grain_Req(T)            Monthly water requirement for Grain crop (acft per acre)/June 1, July 2,August 0/
;


Positive variables
X(Y)                 Dual variables
*X(Land) is in acres and other variables are in ac-ft.
;

Variable
Min_Z                   Total benefit from the Irrigation development i.e. objective function value ($);

Scalars
Avail_land               Total available land (acres) /10000/
June_Water               Available water in June (acft)/14000/
July_Water               Available water in July (acft) /18000/
August_Water             Available water in August (acft) /6000/
Rate_Hay                 Return from Hay crop ($ per acre) /100/
Rate_Grain               Return from Grain crop ($ per acre) /120/
;

Equations
Min_benefit              Objective function i.e. to minimize the resources required for irrigation development($)
Hay_DUAL                 Reduced Cost ($) associated with using resources for Hay crop
Grain_DUAL               Reduced Cost ($) associated with using resources for Grain crop

;

*Objective function (i.e Maximize Benefits).

Min_benefit..                    Min_Z =e= Avail_land* X("Land") + June_Water *X("June")+ July_Water *X("July")+ August_Water *X("August") ;

*constraints
Hay_DUAL..                       X("Land")*1 + X("June")*Hay_Req("June")+ X("July")*Hay_Req("July")+ X("August")*Hay_Req("August")=g= Rate_Hay ;
Grain_DUAL..                     X("Land")*1 + X("June")*Grain_Req("June")+ X("July")*Grain_Req("July")+ X("August")*Grain_Req("August")=g= Rate_Grain ;


*  Defininig a model having all equations
MODEL Dual /ALL/;

Option LP= conopt;
*Selection of Solver


SOLVE Dual USING LP Minimize Min_Z;
*Solution Statement


