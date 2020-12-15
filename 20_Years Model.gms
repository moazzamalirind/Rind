
$ontext
Re-operate Lake Powell and Lake Mead for Ecosystem and Water Supply Benefits (20 years model)
###################################
Created By: Moazzam and Mahmudur Rahman Aveek
Email: moazzamalirind@gmail.com

Created : 10/28/2020
Last updated: 12/11/2020

*****Description: *****Description: This model is developed to find a cooridated optimal reservoir operation of Lake Powell and Lake mead to benefit both water supply and Ecosystem objectives.
This model considers water year calender for its calculations.

######################################
$offtext

****Model code:

Set
             yr                 water years /y1*y20/
             M                  Months in a year /M1*M12/
             Loc                Reserviors /Powell "Glen Canyon Dam", Mead "Hoover Dam"/
             modpar             Saving model parameter for each of the solutions for each of the scenario/ ModStat "Model Statistics", SolStat "Solve Statistics"/
             Obj                Objectives in the model/Temp_Obj "Temperature objective at GCD", UB_Del "Upper basin Delivery",Elev_Mead "Mead Elevation objective to keep Pearce Ferry Rapid",LB_Obj "lower basin delivery objective from Lake Mead"/
             S                  Saving results from each of the model. There are total 2 models to find the extreme point /Max,Min,Valid,Frac/
;


*Define a second name for the sets
Alias (yr,Y);
Alias (M,Month);
Alias (Loc,Location);
Alias (Obj,Objective)

*======================================
Parameters
*======================================
*Parameters for constrainted method i.e. controlling the activation of the objective function equation and values of the objectives
FtoUse(Obj)                             Objective functions to use (1=yes 0=no)
FLevel(Obj)                             Right hand side of constraint when the objective is constrained

Obj_dir                                 Parameter to decide the direction of the objective function (Maximize 1 and Minimize -1)

*Number of days in different months. Here we are using Water year, which means the first month in the simulation here is october.
Days_Month(M)                          Number of days in each months/M1 31,M2 30,M3 31,M4 31,M5 28,M6 31,M7 30,M8 31,M9 30,M10 31,M11 31,M12 30/
Yr_Month_Day(yr,M)                     Days in months during different years. This parameter is basically introduce to differentiate leap year from others.

*Initial storages
Init_Powell                           Initial reservoir storage in Lake Powell i.e. storage on 30th september (acre-ft)/20752807/
Init_Mead                             Initial reservoir storage in Lake Mead i.e. storage on 30th september (acre-ft)/22443956/
*Here  we consider 2000 to 2020 water years as an example. The values given here were measured at the start of october 2000.

End_Storage(Loc)                      Excepted storage at the end of simulation period (acre-ft)/Powell 12000000,Mead  12000000/
* Here we are making an assumption that at the end of the model simulation period the storage in Powell should be equal to or greater than 12 MAF and 12 MAF at hoover.

*Inflows to the system
Inflow_Powell(yr,M)                   Monthly inflows to lake Powell (acre-ft)
Inflow_Paria(yr,M)                    Monthly inflows from Paria river  (acre-ft)
Inflow_Local(yr,M)                    Monthly  inflows from the tributaries within the Grand Canyon (acre-ft)

****************************************
* Physical and operational constraints
***************************************
MaxStorage(Loc)                    Maximum reservior live capacity (ac-ft)/Powell 25970918, Mead 27383237/

MinStorage(Loc)                    Minimum reservior live capacity at dead pool (ac-ft)/Powell 0, Mead 0/
MaxRel(Loc)                        Maximum reservior release at any time(cfs)/Powell 46500, Mead 140000/
*For GCD: 3150 cfs from turbines and 15000 cfs from the river outlets.
*For Hoover:40000 cfs from the turbines and 100000 from the river outlets (http://www.riversimulator.org/Resources/USBR/MaxProbableFloods.pdf)

MinRel(Loc)                        Minimum reservior release at any time (cfs)/Powell 8000, Mead 8000/


****************
*Lake Powell
***************
Temp_ThresholdUp                      Storage upper limit to produce desirable temperature releases from GCD (ac-ft)/20539038/
Temp_ThresholdDown                    Storage lower limit to produce desirable temperature releases from GCD (ac-ft)/11750075/
LB_Threshold                          Annual lower basin demand from the Glen Canyon Dam (ac-ft)/8230000/

Rel_Powell(yr,M)                      Constraining the Lake powell releases (cfs)
**************
*Lake Mead
**************
Obj_Mead                              Reservior storage which keep pearce ferry rapid intact/15120000/
LB_Mead                               Annual deliveries from the Hoover Dam(ac-ft)/9000000/

Rel_Mead(yr,M)                       Constraining the Lake Mead releases (cfs)

**************************************************

*Storing Results
Rstore(Obj,Location,S,Y,Month)                    Store Average monthly release values (cfs)
Sstore(Obj,Location,S,Y,Month)                    Store monthly Storage values (ac-ft)
Rel_vol(Obj,Location,S,Y)                         Store Annual release volume (ac-ft)
ModelResults(Obj,S,Y,Month,modpar)                Model Results for the scenarios
Objective_Val(Obj,S)                              Store objective values from each of the models

;

Yr_Month_Day(yr,M)= Days_Month(M);
*Here we are making 29 days in feburary because of leap year (2004,2008,2012,2016, and 2020).
Yr_Month_Day("y4","M5")= 29;
Yr_Month_Day("y8","M5")= 29;
Yr_Month_Day("y12","M5")= 29;
Yr_Month_Day("y16","M5")= 29;
Yr_Month_Day("y20","M5")= 29;

*===================================================
* Read data from Excel
*===================================================
$CALL GDXXRW.EXE input=Input_2000-20WY.xlsx output=20yr_Results.gdx  par=Inflow_Powell rng=Inflow_powell!A1 Rdim=2  par=Inflow_Paria rng=Inflow_paria!A1 Rdim=2 par=Inflow_Local rng=Inflow_Local!A1 Rdim=2  par=Rel_Powell rng=Rel_Powell!A1 Rdim=2  par=Rel_Mead rng=Rel_Mead!A1 Rdim=2

*Write the input Data into a GDX file
$GDXIN 20yr_Results.gdx

* loading parameters and input data from the GDX file into the model
$LOAD Inflow_Powell
$LOAD Inflow_Paria
$LOAD Inflow_Local
$LOAD Rel_Powell
$LOAD Rel_Mead

*Close the GDX file
$GDXIN

Display Inflow_Powell,Inflow_Paria,Inflow_Local, Rel_Powell,Rel_Mead;
*===============================================

*========================================
Scalar
*========================================
Convert                      conversion factor from cfs to ac-ft per day (0.0014*60*24)/1.983/
Slope                        Slope for the sigmoidal function/0.01/
pi                           value of pi/3.14/
;

Variables
*Mass balance at both reserviors
Storage(Loc,yr,M)           Reservior Storage at each timestep (ac-ft)

Release(Loc,yr,M)           Reservior Release (cfs)
WY_Volume(Loc,yr)           Annual release volume during water year (ac-ft)

ObjectiveVal(Obj)           Objective function value

CombineObjective            Combine objective value

;

**************************************************************************************************************************
Equation
*EQ1_Massblc(Loc,yr,M)              Mass balance at the reservoir (ac-ft)
*This is a commom mass balance equation which can work for both reservoirs but once we get a evaporation equation

EQ1_Massblc_Powell(Loc,yr,M)       Mass balance at Powell(ac-ft)
EQ2_Massblc_Mead(Loc,yr,M)         Mass balance at Mead(ac-ft)
EQ3_EndofTime_Storage(Loc)         Storage of the reservoirs at the end of the simulation period must be equal to or greater than the starting storage levels.
EQ4_MaxStorage(Loc,yr,M)           Maximum reservior storage during any timestep (ac-ft)
EQ5_MinStorage(Loc,yr,M)           Minimum reservior storage during any timestep (ac-ft)
EQ6_MaxRel(Loc,yr,M)               Maximum reservior release(cfs)
EQ7_MinRel(Loc,yr,M)               Minimum reservior release (cfs)
EQ8_AnnualVol(Loc,yr)              Total annual release volume per water year(ac-ft)
EQ9_obj_temp(obj)                  Objective function representing the GCD is making releases from the deseriable storage level window during summer months
EQ10_UB_Delivery(obj)              Objective function representing the GCD is making enough annual releases to fulfill delivery demands
EQ11_obj_Mead(obj)                 Objective function counting number of months lake mead has elevation less than 1135ft so that pearce ferry rapid should not disappear
EQ12_obj_MeadLB(obj)               Objective function representing the Hoover dam is making enough annual releases to fulfill lower basin demands
EQ13_CombinedObjectives            Defining all objective in single equation


;

*****************************************************************************************************************************
*Mass Balance
*EQ1_Massblc(Loc,yr,M)..                                        Storage(Loc,yr,M)=e= Init_Storage(Loc)$(ord(yr)eq 1 and ord(M)eq 1)+ Storage(Loc,yr,M-1)$(ord(M)gt 1) + Storage(Loc,yr-1,"M12")$(ord(yr)gt 1 and ord (M)eq 1)+ Inflow_Powell(yr,M)$(ord(Loc) eq 1)+ Release("L1",yr,M)$(ord(Loc) eq 2)*Convert*Yr_Month_Day(yr,M)+ Inflow_Paria(yr,M)$(ord(Loc) eq 2)+ Inflow_Local(yr,M)$(ord(Loc) eq 2) - (Release(Loc,yr,M)*Convert*Yr_Month_Day(yr,M))- (apeeqv);

EQ1_Massblc_Powell(Loc,yr,M)$(ord(Loc)eq 1)..                   Storage(Loc,yr,M)=e= Init_Powell$(ord(yr)eq 1 and ord(M)eq 1)+ Storage(Loc,yr,M-1)$(ord(M)gt 1) + Storage(Loc,yr-1,"M12")$(ord(yr)gt 1 and ord (M)eq 1)+ Inflow_Powell(yr,M)- (Release(Loc,yr,M)*Convert*Yr_Month_Day(yr,M))- ((0.0029*Storage(Loc,yr,M) + 7200.6)$(ord(M) gt 1 and ord(M) lt 9)) - ((0.0057 *Storage(Loc,yr,M) + 14360)$(ord(M) eq 1 and ord(M) gt 8));
EQ2_Massblc_Mead(Loc,yr,M)$(ord(Loc)eq 2)..                     Storage(Loc,yr,M)=e= Init_Mead$(ord(yr)eq 1 and ord(M)eq 1)+ Storage(Loc,yr,M-1)$(ord(M)gt 1) + Storage(Loc,yr-1,"M12")$(ord(yr)gt 1 and ord (M)eq 1)+ Release("Powell",yr,M)*Convert*Yr_Month_Day(yr,M)+ Inflow_Paria(yr,M)+ Inflow_Local(yr,M)- (Release("Mead",yr,M)*Convert*Yr_Month_Day(yr,M))- ((0.0024*Storage(Loc,yr,M) + 12046)$(ord(M) gt 2 and ord(M) lt 9)) - ((0.0048 *Storage(Loc,yr,M) + 24010)$(ord(M) lt 3 and ord(M) gt 8));

*Constraints
EQ3_EndofTime_Storage(Loc)..                                    Storage(Loc,"y20","M12")=g= End_Storage(Loc);
*depending on the number of water years involved in the simulation, on has to update the year index (e.g.y3 is used here because there are 3 water years considered in this simulation).

EQ4_MaxStorage(Loc,yr,M)..                          Storage(Loc,yr,M)=l= MaxStorage(Loc);
EQ5_MinStorage(Loc,yr,M)..                          Storage(Loc,yr,M)=g= MinStorage(Loc);
EQ6_MaxRel(Loc,yr,M)..                              Release(Loc,yr,M)=l= MaxRel(Loc);
EQ7_MinRel(Loc,yr,M)..                              Release(Loc,yr,M)=g= MinRel(Loc);
EQ8_AnnualVol(Loc,yr)..                             WY_Volume(Loc,yr)=e= sum(M, Release(Loc,yr,M)*Convert*Yr_Month_Day(yr,M));

*objectives
EQ9_obj_temp(obj)$(ord (obj) eq 1)..                ObjectiveVal(Obj)=e= sum(yr, sum(M $(ord (M)gt 7 and ord(M)lt 12),((((arctan((Storage("Powell",yr,M)$(ord (M)gt 7 and ord(M) lt 12)- Temp_ThresholdDown)/Slope)/(pi/2))+1)*0.5)*(((arctan((Storage("Powell",yr,M)$(ord (M)gt 7 and ord (M) lt 12)-Temp_ThresholdUp)/Slope)/(pi/2))+1)* (-0.5) +1))));
EQ10_UB_Delivery(obj)$(ord (obj) eq 2)..            ObjectiveVal(Obj)=e= sum(yr,((arctan((sum(M, Release("Powell",yr,M)*Convert*Yr_Month_Day(yr,M) + Inflow_Paria(yr,M))-LB_Threshold)/Slope)/(pi/2))+1)*0.5);
EQ11_obj_Mead(obj)$(ord (obj) eq 3)..               ObjectiveVal(Obj)=e= sum (yr, sum(M,(((arctan((Storage("Mead",yr,M)-Obj_Mead)/Slope)/(pi/2))+1)*(-0.5)+1)));
EQ12_obj_MeadLB(obj)$(ord (obj) eq 4)..             ObjectiveVal(Obj) =e= sum(yr,((arctan((sum(M,Release("Mead",yr,M)*Convert*Yr_Month_Day(yr,M))-LB_Mead)/Slope)/(pi/2))+1)*0.5);
EQ13_CombinedObjectives..                           CombineObjective=e= sum(Obj,FtoUse(Obj)*Obj_dir*ObjectiveVal(Obj));

*********************************************************************************************
*********************************************************************************************
Model Model1 getting maximum values of all objectives. considering  one objective at a time/AlL/;

loop(Objective,
*Ignore all the objectives
   FtoUse(Obj) = 0;
*  Only consider the current objective
   FtoUse(Objective) = 1;
   Display FtoUse;

option NLP= CONOPT;
*Initialization
Release.L(Loc,yr,M)= 10000;

*Here we are miximizing all the objectives, therefore, set obj_dir equals 1
 Obj_dir=1;
SOLVE Model1 using NLP Maximize CombineObjective;

Objective_Val(Objective,"Max")= CombineObjective.L

loop((Location,Y,Month),
*saving values
Rstore(Objective,Location,"Max",Y,Month)= Release.L(Location,Y,Month);
Sstore(Objective,Location,"Max",Y,Month)= Storage.L(Location,Y,Month);
Rel_vol(Objective,Location,"Max",Y)= WY_Volume.L(Location,Y);

ModelResults(Objective,"Max",Y,Month,"SolStat")=Model1.solvestat;
ModelResults(Objective,"Max",Y,Month,"ModStat")=Model1.modelstat;
);

DISPLAY Rstore,Sstore,Rel_vol;
option clear=Release,clear=Storage,clear=Rel_vol;
);


*********************************************************************************************
*********************************************************************************************
Model Model2 getting Minimum values of all objectives. considering  one objective at a time/AlL/;

loop(Objective,
*Ignore all the objectives
   FtoUse(Obj) = 0;
*  Only consider the current objective
   FtoUse(Objective) = 1;
   Display FtoUse;

option NLP= CONOPT;
*Initialization
Release.L(Loc,yr,M)= 1000;

*Here we are minimizing all the objectives, therefore, set obj_dir equals -1
Obj_dir= -1;

SOLVE Model2 using NLP Maximize CombineObjective;

*Here adding -ve sign on the  right hand side because the obj_dir is negative, which makes the objective value negative. The added - ve sign will nulify the effective of obj_dir on the values of objective funtions
Objective_Val(Objective,"Min")= - CombineObjective.L

loop((Location,Y,Month),
*saving values
Rstore(Objective,Location,"Min",Y,Month)= Release.L(Location,Y,Month);
Sstore(Objective,Location,"Min",Y,Month)= Storage.L(Location,Y,Month);
Rel_vol(Objective,Location,"Min",Y)= WY_Volume.L(Location,Y);

ModelResults(Objective,"Min",Y,Month,"SolStat")=Model2.solvestat;
ModelResults(Objective,"Min",Y,Month,"ModStat")=Model2.modelstat;
);

DISPLAY Rstore,Sstore,Rel_vol;
option clear=Release,clear=Storage,clear=Rel_vol;
);


*********************************************************************************************
*********************************************************************************************

EQUATION
EQ14_RelSim(Loc,yr,M)              Setting release values to predefined releases for simulation(cfs);

EQ14_RelSim(Loc,yr,M)..            Release(Loc,yr,M)=e= Rel_Powell(yr,M)$(ord (Loc)eq 1)+ Rel_Mead(yr,M)$(ord (Loc)eq 2);


Model Model3 validation model with made up release values/EQ1_Massblc_Powell,EQ2_Massblc_Mead,EQ4_MaxStorage,EQ5_MinStorage,EQ6_MaxRel,EQ7_MinRel,EQ8_AnnualVol,EQ9_obj_temp,EQ10_UB_Delivery,EQ11_obj_Mead,EQ12_obj_MeadLB,EQ13_CombinedObjectives,EQ14_RelSim/;


loop(Objective,
*Ignore all the objectives
   FtoUse(Obj) = 0;
*  Only consider the current objective
   FtoUse(Objective) = 1;
   Display FtoUse;

option NLP= CONOPT;

*Here we are miximizing all the objectives, therefore, set obj_dir equals 1
Obj_dir=1;
SOLVE Model3 using NLP Maximize CombineObjective;

Objective_Val(Objective,"Valid")= CombineObjective.L

loop((Location,Y,Month),
*saving values
Rstore(Objective,Location,"Valid",Y,Month)= Release.L(Location,Y,Month);
Sstore(Objective,Location,"Valid",Y,Month)= Storage.L(Location,Y,Month);
Rel_vol(Objective,Location,"Valid",Y)= WY_Volume.L(Location,Y);

ModelResults(Objective,"Valid",Y,Month,"SolStat")=Model3.solvestat;
ModelResults(Objective,"Valid",Y,Month,"ModStat")=Model3.modelstat;
);

DISPLAY Rstore,Sstore,Rel_vol;
option clear=Release,clear=Storage,clear=Rel_vol;
);

*------------------------------------------------------------------------------*
* Dump all input data and results to a GAMS gdx file
Execute_Unload "20yr_Results.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls 20yr_Results.gdx"
