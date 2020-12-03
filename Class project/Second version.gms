$ontext
Re-operate Lake Powell and Lake Mead for Ecosystem and Water Supply Benefits (3 year model)
###################################
Created By: Moazzam and Mahmudur Rahman Aveek
Email: moazzamalirind@gmail.com

Created : 10/28/2020
Last updated: 12/03/2020

*****Description: (You can write this or I can write sometime, a breif abstract telling what this model is about and what it produce as output)
This model considers water year calender for its calculations.

######################################
$offtext

****Model code:

Set
             yr                 water years /y1*y3/
             M                  Months in a year /M1*M12/
             Loc                Reserviors /L1 "Glen Canyon Dam", L2 "Hoover Dam"/
             modpar             Saving model parameter for each of the solutions for each of the scenario/ ModStat "Model Statistics", SolStat "Solve Statistics"/
             S                  Saving results from each of the model. there are total 5 models /S1*S5/
;


*Define a second name for the sets
Alias (yr,Y);
Alias (M,Month);
Alias (Loc,Location);

*======================================
Parameters
*======================================
*Initial storages
Init_Powell                           Initial reservoir storage in Lake Powell i.e. storage on 30th september (acre-ft)/14664000/
Init_Mead                             Initial reservoir storage in Lake Mead i.e. storage on 30th september (acre-ft)/10182000/
*Here  we consider 2018,2019,2020 water years as an example. The values given here were measured at the start of october 2017.

*Inflows to the system
Inflow_Powell(yr,M)                   Monthly inflows to lake Powell (acre-ft)
Inflow_Paria(yr,M)                    Monthly inflows from Paria river  (acre-ft)
Inflow_Local(yr,M)                    Monthly  inflows from the tributaries within the Grand Canyon (acre-ft)

****************************************
* Physical and operational constraints
***************************************
MaxStorage(Loc)                    Maximum reservior live capacity (ac-ft)/L1 25970918, L2 27383237/
MinStorage(Loc)                    Minimum reservior live capacity at dead pool (ac-ft)/L1 0, L2 0/
MaxRel(Loc)                        Maximum reservior release at any time(cfs)/L1 46500, L2 140000/
*For GCD: 3150 cfs from turbines and 15000 cfs from the river outlets.
*For Hoover:40000 cfs from the turbines and 100000 from the river outlets (http://www.riversimulator.org/Resources/USBR/MaxProbableFloods.pdf)

MinRel(Loc)                        Minimum reservior release at any time (cfs)/L1 8000, L2 8000/
evap_Rate(Loc,M)                   Monthly Evaporation rate(Monthly evaporation volume per monthly reservior storage)
* For Evaporation rate we have used evaporation data from WY2018 to WY2020.

****************
*Lake Powell
***************
Temp_ThresholdUp                      Storage upper limit to produce desirable temperature releases from GCD (ac-ft)/20539038/
Temp_ThresholdDown                    Storage lower limit to produce desirable temperature releases from GCD (ac-ft)/11750075/
LB_Threshold                          Annual lower basin demand from the Glen Canyon Dam (ac-ft)/8230000/

**************
*Lake Mead
**************
Obj_Mead                              Reservior storage which keep pearce ferry rapid intact/15120000/
LB_Mead                               Annual deliveries from the Hoover Dam(ac-ft)/9000000/

**************************************************

*Storing Results
Rstore(Location,S,Y,Month)                    Store Average monthly release values (cfs)
Sstore(Location,S,Y,Month)                    Store monthly Storage values (ac-ft)
Rel_vol(Location,S,Y)                         Store Annual release volume (ac-ft)
ModelResults(S,Y,Month,modpar)                Model Results for the scenarios

GCD_Temp(S)                       Temperature objective value of GCD in each of the model
GCD_LB(S)                         Lower basin objective value of GCD in each of the model
Hoover_Elev(S)                    Elevation objective value of Lake mead in each of the model
Hoover_LB(S)                      Lower basin objective value of Hoover Dam in each of the model
Total_Obj(S)                      Combine value of the objectives
;

Table Days_Months(yr,M)    Number of days in months (Here we are considering WY2018 to WY2020)
     M1  M2  M3  M4  M5  M6  M7  M8  M9  M10  M11  M12
y1   31  30  31  31  28  31  30  31  30  31   31   30
y2   31  30  31  31  28  31  30  31  30  31   31   30
y3   31  30  31  31  29  31  30  31  30  31   31   30 ;

*===================================================
* Read data from Excel
*===================================================
$CALL GDXXRW.EXE input=Input_2018-20WY.xlsx output=V2_Results.gdx  par=Inflow_Powell rng=Inflow_powell!A1 Rdim=2  par=Inflow_Paria rng=Inflow_paria!A1 Rdim=2 par=Inflow_Local rng=Inflow_Local!A1 Rdim=2  par=evap_Rate rng=EvapFrac!A1 Rdim=2

*Write the input Data into a GDX file
$GDXIN V2_Results.gdx

* loading parameters and input data from the GDX file into the model
$LOAD Inflow_Powell
$LOAD Inflow_Paria
$LOAD Inflow_Local
$LOAD evap_Rate

*Close the GDX file
$GDXIN

Display Inflow_Powell,Inflow_Paria,Inflow_Local,evap_Rate;
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

Temp_Obj                    Summer months when GCD releases are from favorable reservior elevation that produces required release temperature
LB_Obj                      Annual  release volume of GCD meeting lower basin demand of 8.23 MAF per year
Mead_Obj                    Months lake mead is below 1135ft to maintain the pearce ferry rapid
MeadLB_Obj                  Annual release volume of Hoover Dam meeting lower basin demand of 9 MAF per year
Tot_Obj                     Sum of all the objectives
;

**************************************************************************************************************************
Equation
EQ1_Massblc_Powell(Loc,yr,M)       Mass balance at Powell(ac-ft)
EQ2_Massblc_Mead(Loc,yr,M)         Mass balance at Mead(ac-ft)
EQ3_MaxStorage(Loc,yr,M)           Maximum reservior storage during any timestep (ac-ft)
EQ4_MinStorage(Loc,yr,M)           Minimum reservior storage during any timestep (ac-ft)
EQ5_MaxRel(Loc,yr,M)               Maximum reservior release(cfs)
EQ6_MinRel(Loc,yr,M)               Minimum reservior release (cfs)
EQ7_AnnualVol(Loc,yr)              Total annual release volume per water year(ac-ft)
EQ8_obj_temp                       Objective function representing the GCD is making releases from the deseriable storage level window during summer months
EQ9_obj_LB                         Objective function representing the GCD is making enough annual releases to fulfill lower basin demands
EQ10_obj_Mead                      Objective function counting number of months lake mead has elevation less than 1135ft so that pearce ferry rapid should not disappear
EQ11_obj_MeadLB                    Objective function representing the Hoover dam is making enough annual releases to fulfill lower basin demands
EQ12_AllObj                        Sum of all objectives
;

*****************************************************************************************************************************
*Mass Balance
EQ1_Massblc_Powell(Loc,yr,M)$(ord(Loc)eq 1)..                  Storage(Loc,yr,M)=e= Init_Powell$(ord(yr)eq 1 and ord(M)eq 1)+ Storage(Loc,yr,M-1)$(ord(M)gt 1) + Storage(Loc,yr-1,"M12")$(ord(yr)gt 1 and ord (M)eq 1)+ Inflow_Powell(yr,M)- (Release(Loc,yr,M)*Convert*Days_Months(yr,M))- (evap_Rate(Loc,M)$(ord(yr)eq 1 and ord(M)eq 1))*(Init_Powell + Inflow_Powell(yr,M))- (evap_Rate(Loc,M)$(ord(M)gt 1))*(Storage(Loc,yr,M-1)+ Inflow_Powell(yr,M)) - (evap_Rate(Loc,M)$(ord(yr)gt 1 and ord(M)eq 1))*(Storage(Loc,yr-1,"M12")+ Inflow_Powell(yr,M));

EQ2_Massblc_Mead(Loc,yr,M)$(ord(Loc)eq 2)..                     Storage(Loc,yr,M)=e= Init_Mead$(ord(yr)eq 1 and ord(M)eq 1)+ Storage(Loc,yr,M-1)$(ord(M)gt 1) + Storage(Loc,yr-1,"M12")$(ord(yr)gt 1 and ord (M)eq 1)+ Release("L1",yr,M)*Convert*Days_Months(yr,M)+ Inflow_Paria(yr,M)+ Inflow_Local(yr,M)- (Release(Loc,yr,M)*Convert*Days_Months(yr,M))- (evap_Rate(Loc,M)$(ord(yr)eq 1 and ord(M)eq 1))*(Init_Mead + (Release("L1",yr,M)*Convert*Days_Months(yr,M))+ Inflow_Local(yr,M))- (evap_Rate(Loc,M)$(ord(M)gt 1))*(Storage(Loc,yr,M-1)+ (Release("L1",yr,M)*Convert*Days_Months(yr,M))+ Inflow_Local(yr,M)) - (evap_Rate(Loc,M)$(ord(yr)gt 1 and ord(M)eq 1))*(Storage(Loc,yr-1,"M12")+ (Release("L1",yr,M)*Convert*Days_Months(yr,M))+ Inflow_Local(yr,M));

*Constraints
EQ3_MaxStorage(Loc,yr,M)..            Storage(Loc,yr,M)=l= MaxStorage(Loc);
EQ4_MinStorage(Loc,yr,M)..            Storage(Loc,yr,M)=g= MinStorage(Loc);
EQ5_MaxRel(Loc,yr,M)..                Release(Loc,yr,M)=l= MaxRel(Loc);
EQ6_MinRel(Loc,yr,M)..                Release(Loc,yr,M)=g= MinRel(Loc);
EQ7_AnnualVol(Loc,yr)..               WY_Volume(Loc,yr)=e= sum(M, Release(Loc,yr,M)*Convert*Days_Months(yr,M));
*objectives
EQ8_obj_temp..                        Temp_Obj=e= sum(yr, sum(M $(ord (M)gt 7 and ord(M)lt 12),((((arctan((Storage("L1",yr,M)$(ord (M)gt 7 and ord(M) lt 12)- Temp_ThresholdDown)/Slope)/(pi/2))+1)*0.5)*(((arctan((Storage("L1",yr,M)$(ord (M)gt 7 and ord (M) lt 12)-Temp_ThresholdUp)/Slope)/(pi/2))+1)* (-0.5) +1))));

EQ9_obj_LB..                          LB_Obj=e= sum(yr,((arctan((sum(M,((Release("L1",yr,M)*Convert*Days_Months(yr,M))+ Inflow_Paria(yr,M)))-LB_Threshold)/Slope)/(pi/2))+1)*0.5);

EQ10_obj_Mead..                       Mead_Obj=e= sum(M,(((arctan((Storage("L2","y1",M)-Obj_Mead)/Slope)/(pi/2))+1)*(-0.5)+1))+sum(M,(((arctan((Storage("L2","y2",M)-Obj_Mead)/Slope)/(pi/2))+1)*(-0.5)+1))+sum(M,(((arctan((Storage("L2","y3",M)-Obj_Mead)/Slope)/(pi/2))+1)*(-0.5)+1));
EQ11_obj_MeadLB..                     MeadLB_Obj =e= sum(yr,((arctan((sum(M,Release("L2",yr,M)*Convert*Days_Months(yr,M))-LB_Mead)/Slope)/(pi/2))+1)*0.5);
EQ12_ALLobj..                         Tot_Obj=e= Temp_Obj+ LB_Obj + Mead_Obj + MeadLB_Obj;
*********************************************************************************************

*Initialization
Storage.L(Loc,yr,M)= 1000000;
Release.L(Loc,yr,M)= 10000;

*********************************************************************************************
*********************************************************************************************
MODEL Model1 Only consider the temperature objective of GCD Using NLP/ALL/;

option NLP= CONOPT;

SOLVE Model1 USING nlp maximize Temp_Obj;
GCD_Temp("S1")= Temp_Obj.L;
GCD_LB("S1")=LB_Obj.L;
Hoover_Elev("S1")= Mead_Obj.L;
Hoover_LB("S1")= MeadLB_Obj.L;
Total_Obj("S1")= Tot_Obj.L;

loop((Location,Y,Month),
*saving values
Rstore(Location,"S1",Y,Month)= Release.L(Location,Y,Month);
Sstore(Location,"S1",Y,Month)= Storage.L(Location,Y,Month);
Rel_vol(Location,"S1",Y)= Sum(M,Release.L(Location,Y,Month)*Convert*Days_Months(Y,Month));

ModelResults("S1",Y,Month,"SolStat")=Model1.solvestat;
ModelResults("S1",Y,Month,"ModStat")=Model1.modelstat;
);

DISPLAY Rstore,Sstore,Rel_vol;
*option clear=Release,clear=Storage,clear=Rel_vol;

*********************************************************************************************
*********************************************************************************************
MODEL Model2 Only consider the Lower Basin GCD objective Using NLP/ALL/;

option NLP= CONOPT;

SOLVE Model2 USING nlp maximize LB_Obj;
GCD_Temp("S2")= Temp_Obj.L;
GCD_LB("S2")=LB_Obj.L;
Hoover_Elev("S2")= Mead_Obj.L;
Hoover_LB("S2")= MeadLB_Obj.L;
Total_Obj("S2")= Tot_Obj.L;

loop((Location,Y,Month),
*saving values
Rstore(Location,"S2",Y,Month)= Release.L(Location,Y,Month);
Sstore(Location,"S2",Y,Month)= Storage.L(Location,Y,Month);
Rel_vol(Location,"S2",Y)= Sum(M,Release.L(Location,Y,Month)*Convert*Days_Months(Y,Month));

ModelResults("S2",Y,Month,"SolStat")=Model1.solvestat;
ModelResults("S2",Y,Month,"ModStat")=Model1.modelstat;
);

DISPLAY Rstore,Sstore,Rel_vol;
*option clear=Release,clear=Storage,clear=Rel_vol;

*********************************************************************************************
*********************************************************************************************
MODEL Model3 Only consider Pearce Ferry objective using NLP/ALL/;


option NLP= CONOPT;

SOLVE Model3 USING nlp maximize Mead_Obj;
GCD_Temp("S3")= Temp_Obj.L;
GCD_LB("S3")=LB_Obj.L;
Hoover_Elev("S3")= Mead_Obj.L;
Hoover_LB("S3")= MeadLB_Obj.L;
Total_Obj("S3")= Tot_Obj.L;

loop((Location,Y,Month),
*saving values
Rstore(Location,"S3",Y,Month)= Release.L(Location,Y,Month);
Sstore(Location,"S3",Y,Month)= Storage.L(Location,Y,Month);
Rel_vol(Location,"S3",Y)= Sum(M,Release.L(Location,Y,Month)*Convert*Days_Months(Y,Month));

ModelResults("S3",Y,Month,"SolStat")=Model1.solvestat;
ModelResults("S3",Y,Month,"ModStat")=Model1.modelstat;
);

DISPLAY Rstore,Sstore,Rel_vol;
*option clear=Release,clear=Storage,clear=Rel_vol;

*********************************************************************************************
*********************************************************************************************
MODEL Model4 Only consider the Lower Basin Hoover Dam objective Using NLP/ALL/;

option NLP= CONOPT;

SOLVE Model4 USING nlp maximize MeadLB_Obj;
GCD_Temp("S4")= Temp_Obj.L;
GCD_LB("S4")=LB_Obj.L;
Hoover_Elev("S4")= Mead_Obj.L;
Hoover_LB("S4")= MeadLB_Obj.L;
Total_Obj("S4")= Tot_Obj.L;

loop((Location,Y,Month),
*saving values
Rstore(Location,"S4",Y,Month)= Release.L(Location,Y,Month);
Sstore(Location,"S4",Y,Month)= Storage.L(Location,Y,Month);
Rel_vol(Location,"S4",Y)= Sum(M,Release.L(Location,Y,Month)*Convert*Days_Months(Y,Month));

ModelResults("S4",Y,Month,"SolStat")=Model1.solvestat;
ModelResults("S4",Y,Month,"ModStat")=Model1.modelstat;
);

DISPLAY Rstore,Sstore,Rel_vol;
*option clear=Release,clear=Storage,clear=Rel_vol;

*********************************************************************************************
*********************************************************************************************
MODEL Model5 All objectives using NLP/ALL/;

option NLP= CONOPT;

SOLVE Model5 USING nlp maximize Tot_Obj;
GCD_Temp("S5")= Temp_Obj.L;
GCD_LB("S5")=LB_Obj.L;
Hoover_Elev("S5")= Mead_Obj.L;
Hoover_LB("S5")= MeadLB_Obj.L;
Total_Obj("S5")= Tot_Obj.L;

loop((Location,Y,Month),
*saving values
Rstore(Location,"S5",Y,Month)= Release.L(Location,Y,Month);
Sstore(Location,"S5",Y,Month)= Storage.L(Location,Y,Month);
Rel_vol(Location,"S5",Y)= Sum(M,Release.L(Location,Y,Month)*Convert*Days_Months(Y,Month));

ModelResults("S5",Y,Month,"SolStat")=Model1.solvestat;
ModelResults("S5",Y,Month,"ModStat")=Model1.modelstat;
);

DISPLAY Rstore,Sstore,Rel_vol;
*option clear=Release,clear=Storage,clear=Rel_vol;


*------------------------------------------------------------------------------*
* Dump all input data and results to a GAMS gdx file
Execute_Unload "V2_Results.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls V2_Results.gdx"
