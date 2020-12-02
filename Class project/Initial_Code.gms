$ontext
Re-operate Lake Powell and Lake Mead for Ecosystem and Water Supply Benefits (3 year model)
###################################
Created By: Moazzam and Mahmudur Rahman Aveek
Email: moazzamalirind@gmail.com

Created : 10/28/2020
Last updated: 11/25/2020

*****Description: (You can write this or I can write sometime, a breif abstract telling what this model is about and what it produce as output)
This model considers water year calender for its calculations.

######################################
$offtext

****Model code:

Set
             yr                 water years /y1*y3/
             M                  Months in a year /M1*M12/
             modpar             Saving model parameter for each of the solutions for each of the scenario/ ModStat "Model Statistics", SolStat "Solve Statistics"/
             S                  Saving results from each of the model.. there are total 5 models /S1*S5/
;


*Define a second name for the sets
Alias (yr,Y);
Alias (M,Month);

*======================================
Parameters
*======================================
*Initial storages
Init_Powell                           Initial reservoir storage in Lake Powell i.e. storage on 30th september (acre-ft)/14664000/
Init_Mead                             Initial reservoir storage in Lake Mead i.e. storage on 30th september (acre-ft)/10182000/
*Here  we consider 2018,2019,2020 water years as an example. The values given here were measured at the start of october 2017.

*Inflows to the system
Inflow_Powell(yr,M)                      Monthly average inflows to lake Powell during three years (acre-ft)
Inflow_Paria(yr,M)                       Monthly average inflows from Paria river during three years (acre-ft)
Inflow_LitColorado(yr,M)                 Monthly average inflows from Little Colorado river during three years (acre-ft)
Inflow_KanabCreek(yr,M)                  Monthly average inflows from KanabCreek during three years (acre-ft)
Inflow_Havasu(yr,M)                      Monthly average inflows from Havasu during three years (acre-ft)
Inflow_Diamond(yr,M)                     Monthly average inflows from Diamond creek during three years (acre-ft)
Inflow_Mead(yr,M)                        Monthly average inflows to lake Mead during three years (acre-ft)
* Structural and operational constraints
****************
*Lake Powell
***************
Maxstorage_Powell                     Maximum Reservoir capacity of Lake Powell (acre-ft)/25970918/
*Volume Live capacity at maximum storage level of 3710 FT
Minstorage_Powell                     Minimum reservoir storage at dead pool(acre-ft)/0/
*Live storage capacity at 3370 FT level (dead level)
*Elevation to storage curve information can be found at; https://www.usbr.gov/lc/region/programs/strategies/FEIS/AppA.pdf

Min_RelPowell                         Minimum Powell release during any time period (cfs)/8000/
*****I think we can't say that flow can be zero.. If that's zero then ecosystem will die nothing will be there. I think 8000 minimum is decent but we can change if required.
Max_RelPowell                         Maximum Powell release during any time period (cfs)/46500/
*3150 cfs from turbines and 15000 cfs from the river outlets.

evap_Powell(M)                        Monthly Evaporation rate for Lake Powell. (Monthly evaporation volume per monthly reservior storage)
*we need rate i.e. (observed monthly/storage during that month).
Temp_ThresholdUp                      Storage upper limit to produce desirable temperature releases from GCD (ac-ft)/20539038/
Temp_ThresholdDown                    Storage lower limit to produce desirable temperature releases from GCD (ac-ft)/11750075/
LB_Threshold                          Annual lower basin demand from the Glen Canyon Dam (ac-ft)/8230000/


**************
*Lake Mead
**************
Maxstorage_Mead                       Maximum Reservoir storage capacity of Lake Mead (acre-ft)/27383237/
* Live storage capacity at maximum level of 1229 ft
Minstorage_Mead                       Minimum reservoir storage capacity of Lake Mead (acre-ft)/0/
* Live capacity at  deadpool
****Elevation to storage curve information can be found at; https://www.usbr.gov/lc/region/programs/strategies/FEIS/AppA.pdf

Min_RelMead                           Minimum Mead release during any time period (cfs)/8000/
Max_RelMead                           Maximum Mead release during any time period (cfs)/140000/
****40000 cfs from the turbines and 100000 from the river outlets.
*Those numbers can be found at: http://www.riversimulator.org/Resources/USBR/MaxProbableFloods.pdf

evap_Mead(M)                          Monthly Evaporation rate for Lake Mead. (Monthly evaporation volume per monthly reservior storage)
*we need rate i.e. (observed monthly/storage during that month).

Obj_Mead                              Reservior storage which keep pearce ferry rapid intact/15120000/
LB_Mead                               Annual deliveries from the Hoover Dam(ac-ft)/9000000/


**************************************************

*Storing Results
Rstore_Powell(S,Y,Month)                 Storing Average monthly release values of GCD(cfs)
Rstore_Mead(S,Y,Month)                   Storing Average monthly release values of Hoover Dam(cfs)
Sstore_Powell(S,Y,Month)                 Store Storage values of Powell for on a monthly scale (ac-ft)
Sstore_Mead(S,Y,Month)                   Store Storage values of Mead for on a monthly scale (ac-ft)
Rel_volPowell(S,Y)                       Annual release volume from Powell (ac-ft)
Rel_volMead(S,Y)                       Annual release volume from Mead (ac-ft)
ModelResults(S,Y,Month,modpar)           Model Results for the scenarios


Powell_yr1                               Storage volume in Powell at the end of the first water year (ac-ft)
Powell_yr2                               Storage volume in Powell at the end of the Second water year (ac-ft)

Mead_yr1                                 Storage volume in Mead at the end of the first water year (ac-ft)
Mead_yr2                                 Storage volume in Mead at the end of the Second water year (ac-ft)

GCD_Temp(S)                              Temperature objective value of GCD in each of the model
GCD_LB(S)                                Lower basin objective value of GCD in each of the model
Hoover_Elev(S)                           Elevation objective value of Lake mead in each of the model
Hoover_LB(S)                             Lower basin objective value of Hoover Dam in each of the model

;

*===================================================
* Read data from Excel
*===================================================
$CALL GDXXRW.EXE input=Input_2017-20WY.xlsx output=initial_Results.gdx  par=Inflow_Powell rng=Inflow_powell!A1 Rdim=2  par=Inflow_Paria rng=Inflow_paria!A1 Rdim=2 par=Inflow_LitColorado rng=Inflow_littleColorado!A1 Rdim=2 par=Inflow_KanabCreek rng=Inflow_KanabCreek!A1 Rdim=2 par=Inflow_Havasu rng=Inflow_Havasu!A1 Rdim=2 par=Inflow_Diamond rng=Inflow_diamond!A1 Rdim=2 par=Inflow_Mead rng=Inflow_Mead!A1 Rdim=2 par=evap_Powell rng=powell_EvapFrac!A1 Rdim=1 par=evap_Mead rng=mead_EvapFrac!A1 Rdim=1

*Write the input Data into a GDX file
$GDXIN initial_Results.gdx

* loading parameters and input data from the GDX file into the model
$LOAD Inflow_Powell
$LOAD Inflow_Paria
$LOAD Inflow_LitColorado
$LOAD Inflow_KanabCreek
$LOAD Inflow_Havasu
$LOAD Inflow_Diamond
$LOAD Inflow_Mead
$LOAD evap_Mead
$LOAD evap_Powell

*Close the GDX file
$GDXIN

Display Inflow_Powell,Inflow_Paria,Inflow_LitColorado,Inflow_KanabCreek,Inflow_Havasu,Inflow_Diamond,evap_Powell,evap_Mead;
*===============================================

*========================================
Scalar
*========================================
Convert                      conversion factor from cfs to ac-ft per day (0.0014*60*24)/1.983/
Slope                        Slope for the sigmoidal function/0.01/
pi                           value of pi/3.14/
;

Variables

*Mass balance at various locations of the study area
Storage_Powell(yr,M)        Storage in Lake Powell at each time step (ac-ft)

Storage_Mead(yr,M)          Storage in Lake Mead at each time step (ac-ft)

*Releases
Rel_Powell(yr,M)            Release from lake powell (cfs)
Rel_Mead(yr,M)              Release from Lake Mead (cfs)

*Volumes
Vol_Powell(yr)              Total volume of water released from lake powell during water year (ac-ft)
Vol_Mead(yr)                Total volume of water released from lake Mead during  water year (ac-ft)
Temp_Obj                    Summer months when GCD releases are from favorable reservior elevation that produces required release temperature
LB_Obj                      Annual  release volume of GCD meeting lower basin demand of 8.23 MAF per year
Mead_Obj                    Months lake mead is below 1135ft to maintain the pearce ferry rapid
MeadLB_Obj                  Annual release volume of Hoover Dam meeting lower basin demand of 9 MAF per year
Tot_Obj                     Sum of all the objectives

;


**************************************************************************************************************************
Equation
EQ1_Powell_1styr(yr,M)     Mass balance at Lake powell during year 1 (ac-ft)
EQ2_Powell_2ndyr(yr,M)     Mass balance at Lake powell during year 2 (ac-ft)
EQ3_Powell_3rdyr(yr,M)     Mass balance at Lake powell during year 3 (ac-ft)
EQ4_Mead_1styr(yr,M)       Mass balance at Lake Mead during year 1 (ac-ft)
EQ5_Mead_2ndyr(yr,M)       Mass balance at Lake Mead during year 2 (ac-ft)
EQ6_Mead_3rdyr(yr,M)       Mass balance at Lake Mead during year 3 (ac-ft)
EQ7_maxstor_Powell(yr,M)   Powell storage max (ac-ft)
EQ8_maxstor_Mead(yr,M)     Mead storage max (ac-ft)
EQ9_minstor_Powell(yr,M)   The minimum storage equivalent to reservoir deadpool level (ac-ft)
EQ10_minstor_Mead(yr,M)    The minimum storage equivalent to reservoir deadpool level (ac-ft)
EQ11_MaxR_Powell(yr,M)     Max Release for Powell(cfs)
EQ12_MaxR_Mead(yr,M)       Max Release for Mead(cfs)
EQ13_MinR_Powell(yr,M)     Minimum Release for Powell(cfs)
EQ14_MinR_Mead(yr,M)       Minimum Release for Mead(cfs)
EQ15_TotVolPowell(yr)      Total volume of water released from Lake powell during water year (ac-ft)
EQ16_TotVolMead(yr)        Total volume of water released from Lake Mead during water year (ac-ft)
EQ17_obj_temp              Objective function representing the GCD is making releases from the deseriable storage level window during summer months
EQ18_obj_LB                Objective function representing the GCD is making enough annual releases to fulfill lower basin demands
EQ19_obj_Mead              Objective function counting number of months lake mead has elevation less than 1135ft so that pearce ferry rapid should not disappear
EQ20_obj_MeadLB            Objective function representing the Hoover dam is making enough annual releases to fulfill lower basin demands
EQ21_ALLobj                Sum of all objectives

;
*****************************************************************************************************************************

*Mass Balance
EQ1_Powell_1styr(yr,M)$(ord (yr) eq 1)..          Storage_Powell(yr,M) =e= Init_Powell$(ord(M)eq 1)+ Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Inflow_Powell(yr,M)- Rel_Powell(yr,"M1")*Convert*31 - Rel_Powell(yr,"M2")*Convert*30 - Rel_Powell(yr,"M3")*Convert*31 - Rel_Powell(yr,"M4")*Convert*31 - Rel_Powell(yr,"M5")*Convert*28 - Rel_Powell(yr,"M6")*Convert*31 - Rel_Powell(yr,"M7")*Convert*30 - Rel_Powell(yr,"M8")*Convert*31 - Rel_Powell(yr,"M9")*Convert*30 - Rel_Powell(yr,"M10")*Convert*31 - Rel_Powell(yr,"M11")*Convert*31 - Rel_Powell(yr,"M12")*Convert*30 - evap_Powell(M)$(ord(M) eq 1)*(Init_Powell$(ord(M)eq 1)+ Inflow_Powell(yr,"M1"))- evap_Powell(M)$(ord(M) gt 1)*(Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Inflow_Powell(yr,M)$(ord(M)gt 1));
*                                                                                                                                                                October                            November                          December                           January                            Feburary                            March                      April                         May                                  June                                July                               August                     September
*                                                                                                                                                                                          Number in the equation is number of days in the specific months
EQ2_Powell_2ndyr(yr,M)$(ord (yr) eq 2)..          Storage_Powell(yr,M) =e= Powell_yr1$(ord(M)eq 1)+ Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Inflow_Powell(yr,M)- Rel_Powell(yr,"M1")*Convert*31 - Rel_Powell(yr,"M2")*Convert*30 - Rel_Powell(yr,"M3")*Convert*31 - Rel_Powell(yr,"M4")*Convert*31 - Rel_Powell(yr,"M5")*Convert*28 - Rel_Powell(yr,"M6")*Convert*31 - Rel_Powell(yr,"M7")*Convert*30 - Rel_Powell(yr,"M8")*Convert*31 - Rel_Powell(yr,"M9")*Convert*30 - Rel_Powell(yr,"M10")*Convert*31 - Rel_Powell(yr,"M11")*Convert*31 - Rel_Powell(yr,"M12")*Convert*30 - evap_Powell(M)$(ord(M)eq 1)*(Powell_yr1$(ord(M)eq 1)+ Inflow_Powell(yr,"M1"))- evap_Powell(M)$(ord (M) gt 1)*(Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Inflow_Powell(yr,M)$(ord(M)gt 1));

EQ3_Powell_3rdyr(yr,M)$(ord (yr) eq 3)..          Storage_Powell(yr,M) =e=  Powell_yr2$(ord(M)eq 1)+ Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Inflow_Powell(yr,M)- Rel_Powell(yr,"M1")*Convert*31 - Rel_Powell(yr,"M2")*Convert*30 - Rel_Powell(yr,"M3")*Convert*31 - Rel_Powell(yr,"M4")*Convert*31 - Rel_Powell(yr,"M5")*Convert*28 - Rel_Powell(yr,"M6")*Convert*31 - Rel_Powell(yr,"M7")*Convert*30 - Rel_Powell(yr,"M8")*Convert*31 - Rel_Powell(yr,"M9")*Convert*30 - Rel_Powell(yr,"M10")*Convert*31 - Rel_Powell(yr,"M11")*Convert*31 - Rel_Powell(yr,"M12")*Convert*30 - evap_Powell(M)$(ord(M) eq 1)*(Powell_yr2$(ord(M)eq 1)+ Inflow_Powell(yr,"M1"))- evap_Powell(M)$(ord (M) gt 1)*(Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Inflow_Powell(yr,M)$(ord(M)gt 1));

EQ4_Mead_1styr(yr,M)$(ord (yr) eq 1)..            Storage_Mead(yr,M) =e= Init_Mead$(ord(M)eq 1) + Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Rel_Powell(yr,"M1")*Convert*31 + Rel_Powell(yr,"M2")*Convert*30 + Rel_Powell(yr,"M3")*Convert*31 + Rel_Powell(yr,"M4")*Convert*31 + Rel_Powell(yr,"M5")*Convert*28 + Rel_Powell(yr,"M6")*Convert*31 + Rel_Powell(yr,"M7")*Convert*30 + Rel_Powell(yr,"M8")*Convert*31 + Rel_Powell(yr,"M9")*Convert*30 + Rel_Powell(yr,"M10")*Convert*31 + Rel_Powell(yr,"M11")*Convert*31 + Rel_Powell(yr,"M12")*Convert*30+ Inflow_Paria(yr,M)+ Inflow_KanabCreek(yr,M)+ Inflow_Havasu(yr,M)+Inflow_Diamond(yr,M)+ Inflow_LitColorado(yr,M)-Rel_Mead(yr,"M1")*Convert*31 - Rel_Mead(yr,"M2")*Convert*30 - Rel_Mead(yr,"M3")*Convert*31 - Rel_Mead(yr,"M4")*Convert*31 - Rel_Mead(yr,"M5")*Convert*28 - Rel_Mead(yr,"M6")*Convert*31 - Rel_Mead(yr,"M7")*Convert*30 - Rel_Mead(yr,"M8")*Convert*31 - Rel_Mead(yr,"M9")*Convert*30 - Rel_Mead(yr,"M10")*Convert*31 - Rel_Mead(yr,"M11")*Convert*31 - Rel_Mead(yr,"M12")*Convert*30 - evap_Mead(M)$(ord(M) eq 1)*(Init_Mead$(ord(M)eq 1)+ Inflow_Mead(yr,"M1"))- evap_Mead(M)$(ord(M) gt 1)*(Storage_Mead(yr,M-1)$(ord(M)gt 1)+ Inflow_Mead(yr,M)$(ord(M)gt 1));

EQ5_Mead_2ndyr(yr,M)$(ord (yr) eq 2)..            Storage_Mead(yr,M) =e= Mead_yr1$(ord(M)eq 1) + Storage_Mead(yr,M-1)$(ord(M)gt 1)+ Rel_Powell(yr,"M1")*Convert*31 + Rel_Powell(yr,"M2")*Convert*30 + Rel_Powell(yr,"M3")*Convert*31 + Rel_Powell(yr,"M4")*Convert*31 + Rel_Powell(yr,"M5")*Convert*28 + Rel_Powell(yr,"M6")*Convert*31 + Rel_Powell(yr,"M7")*Convert*30 + Rel_Powell(yr,"M8")*Convert*31 + Rel_Powell(yr,"M9")*Convert*30 + Rel_Powell(yr,"M10")*Convert*31 + Rel_Powell(yr,"M11")*Convert*31 + Rel_Powell(yr,"M12")*Convert*30+ Inflow_Paria(yr,M)+ Inflow_KanabCreek(yr,M)+ Inflow_Havasu(yr,M)+Inflow_Diamond(yr,M)+ Inflow_LitColorado(yr,M)-Rel_Mead(yr,"M1")*Convert*31 - Rel_Mead(yr,"M2")*Convert*30 - Rel_Mead(yr,"M3")*Convert*31 - Rel_Mead(yr,"M4")*Convert*31 - Rel_Mead(yr,"M5")*Convert*28 - Rel_Mead(yr,"M6")*Convert*31 - Rel_Mead(yr,"M7")*Convert*30 - Rel_Mead(yr,"M8")*Convert*31 - Rel_Mead(yr,"M9")*Convert*30 - Rel_Mead(yr,"M10")*Convert*31 - Rel_Mead(yr,"M11")*Convert*31 - Rel_Mead(yr,"M12")*Convert*30 - evap_Mead(M)$(ord (M) eq 1)*(Mead_yr1$(ord(M)eq 1)+ Inflow_Mead(yr,"M1"))- evap_Mead(M)$(ord(M) gt 1)*(Storage_Mead(yr,M-1)$(ord(M)gt 1)+ Inflow_Mead(yr,M)$(ord(M)gt 1));

EQ6_Mead_3rdyr(yr,M)$(ord (yr) eq 3)..            Storage_Mead(yr,M) =e= Mead_yr2$(ord(M)eq 1) + Storage_Mead(yr,M-1)$(ord(M)gt 1)+ Rel_Powell(yr,"M1")*Convert*31 + Rel_Powell(yr,"M2")*Convert*30 + Rel_Powell(yr,"M3")*Convert*31 + Rel_Powell(yr,"M4")*Convert*31 + Rel_Powell(yr,"M5")*Convert*28 + Rel_Powell(yr,"M6")*Convert*31 + Rel_Powell(yr,"M7")*Convert*30 + Rel_Powell(yr,"M8")*Convert*31 + Rel_Powell(yr,"M9")*Convert*30 + Rel_Powell(yr,"M10")*Convert*31 + Rel_Powell(yr,"M11")*Convert*31 + Rel_Powell(yr,"M12")*Convert*30+ Inflow_Paria(yr,M)+ Inflow_KanabCreek(yr,M)+ Inflow_Havasu(yr,M)+Inflow_Diamond(yr,M)+ Inflow_LitColorado(yr,M)-Rel_Mead(yr,"M1")*Convert*31 - Rel_Mead(yr,"M2")*Convert*30 - Rel_Mead(yr,"M3")*Convert*31 - Rel_Mead(yr,"M4")*Convert*31 - Rel_Mead(yr,"M5")*Convert*28 - Rel_Mead(yr,"M6")*Convert*31 - Rel_Mead(yr,"M7")*Convert*30 - Rel_Mead(yr,"M8")*Convert*31 - Rel_Mead(yr,"M9")*Convert*30 - Rel_Mead(yr,"M10")*Convert*31 - Rel_Mead(yr,"M11")*Convert*31 - Rel_Mead(yr,"M12")*Convert*30 - evap_Mead(M)$(ord (M) eq 1)*(Mead_yr2$(ord(M)eq 1)+ Inflow_Mead(yr,"M1"))- evap_Mead(M)$(ord(M) gt 1)*(Storage_Mead(yr,M-1)$(ord(M)gt 1)+ Inflow_Mead(yr,M)$(ord(M)gt 1));

*Constraints
EQ7_maxstor_Powell(yr,M)..            Storage_Powell(yr,M)=l= Maxstorage_Powell;
EQ8_maxstor_Mead(yr,M)..              Storage_Mead(yr,M)=l= Maxstorage_Mead;
EQ9_minstor_Powell(yr,M)..            Storage_Powell(yr,M)=g= Minstorage_Powell;
EQ10_minstor_Mead(yr,M)..             Storage_Mead(yr,M)=g= Minstorage_Mead;
EQ11_MaxR_Powell(yr,M)..              Rel_Powell(yr,M)=L= Max_RelPowell;
EQ12_MaxR_Mead(yr,M)..                Rel_Mead(yr,M)=L= Max_RelMead;
EQ13_MinR_Powell(yr,M)..              Rel_Powell(yr,M)=g= Min_RelPowell;
EQ14_MinR_Mead(yr,M)..                Rel_Mead(yr,M)=g= Min_RelMead;
EQ15_TotVolPowell(yr)..               Vol_Powell(yr)=e= Rel_Powell(yr,"M1")*Convert*31 + Rel_Powell(yr,"M2")*Convert*30 + Rel_Powell(yr,"M3")*Convert*31 + Rel_Powell(yr,"M4")*Convert*31 + Rel_Powell(yr,"M5")*Convert*28 + Rel_Powell(yr,"M6")*Convert*31 + Rel_Powell(yr,"M7")*Convert*30 + Rel_Powell(yr,"M8")*Convert*31 + Rel_Powell(yr,"M9")*Convert*30 + Rel_Powell(yr,"M10")*Convert*31 + Rel_Powell(yr,"M11")*Convert*31 + Rel_Powell(yr,"M12")*Convert*30;
EQ16_TotVolMead(yr)..                 Vol_Mead(yr) =e= Rel_Mead(yr,"M1")*Convert*31 + Rel_Mead(yr,"M2")*Convert*30 + Rel_Mead(yr,"M3")*Convert*31 + Rel_Mead(yr,"M4")*Convert*31 + Rel_Mead(yr,"M5")*Convert*28 + Rel_Mead(yr,"M6")*Convert*31 + Rel_Mead(yr,"M7")*Convert*30 + Rel_Mead(yr,"M8")*Convert*31 + Rel_Mead(yr,"M9")*Convert*30 + Rel_Mead(yr,"M10")*Convert*31 + Rel_Mead(yr,"M11")*Convert*31 + Rel_Mead(yr,"M12")*Convert*30;

*objectives
EQ17_obj_temp ..                      Temp_Obj=e= Sum(yr, sum(M $(ord (M)gt 7 and ord(M)lt 12),((((arctan((Storage_Powell(yr,M)$(ord (M)gt 7 and ord(M) lt 12)- Temp_ThresholdDown)/Slope)/(pi/2))+1)*0.5)*(((arctan((Storage_Powell(yr,M)$(ord (M)gt 7 and ord (M) lt 12)-Temp_ThresholdUp)/Slope)/(pi/2))+1)* (-0.5) +1))));
EQ18_obj_LB..                         LB_Obj=e= sum(yr,((arctan((sum(M,Rel_Powell(yr,M))-LB_Threshold)/Slope)/(pi/2))+1)*0.5);
EQ19_obj_Mead..                       Mead_Obj=e= sum(yr, sum(M,(((arctan((Storage_Mead(yr,M)-Obj_Mead)/Slope)/(pi/2))+1)*(-0.5)+1)));
EQ20_obj_MeadLB..                     MeadLB_Obj =e= sum(yr,((arctan((sum(M,Rel_Mead(yr,M))-LB_Mead)/Slope)/(pi/2))+1)*0.5);
EQ21_ALLobj..                         Tot_Obj=e= Temp_Obj+ LB_Obj + Mead_Obj + LB_Mead;
*********************************************************************************************

*Initialization
Storage_Powell.L(yr,M)= 100000;
Storage_Mead.L(yr,M)= 100000;
Rel_Powell.L(yr,M)=10000;
Rel_Mead.L(yr,M)=10000;


Powell_yr1= Storage_Powell.L("y1","M12");
Powell_yr2= Storage_Powell.L("y2","M12");

Mead_yr1= Storage_Mead.L("y1","M12");
Mead_yr2= Storage_Mead.L("y2","M12");

*********************************************************************************************
*********************************************************************************************
MODEL Model1 Only consider the temperature objective of GCD Using NLP/EQ1_Powell_1styr,EQ2_Powell_2ndyr,EQ3_Powell_3rdyr,EQ4_Mead_1styr,EQ5_Mead_2ndyr,EQ6_Mead_3rdyr,EQ7_maxstor_Powell,EQ8_maxstor_Mead,EQ9_minstor_Powell,EQ10_minstor_Mead,EQ11_MaxR_Powell,EQ12_MaxR_Mead,EQ13_MinR_Powell,EQ14_MinR_Mead,EQ15_TotVolPowell,EQ16_TotVolMead,EQ17_obj_temp,EQ18_obj_LB,EQ19_obj_Mead/;


option optcr=0.001;
option NLP= CONOPT;


SOLVE Model1 USING nlp maximize Temp_Obj;
GCD_Temp("S1")= Temp_Obj.L;

loop((Y,Month),

Rstore_Powell("S1",Y,Month)= Rel_Powell.L(yr,M);
Rstore_Mead("S1",Y,Month)= Rel_Mead.L(yr,M);
Sstore_Powell("S1",Y,Month)= Storage_Powell.L(yr,M);
Sstore_Mead("S1",Y,Month)= Storage_Mead.L(yr,M);
Rel_volPowell("S1",Y)= Sum(M,Rel_Powell.L(yr,M));
Rel_volMead("S1",Y)= Sum(M,Rel_Mead.L(yr,M));

ModelResults("S1",Y,Month,"SolStat")=Model1.solvestat;
ModelResults("S1",Y,Month,"ModStat")=Model1.modelstat;
);

option clear=Rel_Powell,clear=Rel_Mead,clear=Storage_Powell,clear=Storage_Mead;
DISPLAY Rstore_Powell,Rstore_Mead,Sstore_Powell,Sstore_Mead,Rel_volPowell,Rel_volMead;

*********************************************************************************************
*********************************************************************************************
MODEL Model2 Only consider the Lower Basin GCD objective Using NLP/EQ1_Powell_1styr,EQ2_Powell_2ndyr,EQ3_Powell_3rdyr,EQ4_Mead_1styr,EQ5_Mead_2ndyr,EQ6_Mead_3rdyr,EQ7_maxstor_Powell,EQ8_maxstor_Mead,EQ9_minstor_Powell,EQ10_minstor_Mead,EQ11_MaxR_Powell,EQ12_MaxR_Mead,EQ13_MinR_Powell,EQ14_MinR_Mead,EQ15_TotVolPowell,EQ16_TotVolMead,EQ17_obj_temp,EQ18_obj_LB,EQ19_obj_Mead/;

option optcr=0.001;
option NLP= CONOPT;


SOLVE Model2 USING nlp maximize LB_Obj;
GCD_LB("S2")=LB_Obj.L;

loop((Y,m),
Rstore_Powell("S2",Y,Month)= Rel_Powell.L(yr,M);
Rstore_Mead("S2",Y,Month)= Rel_Mead.L(yr,M);
Sstore_Powell("S2",Y,Month)= Storage_Powell.L(yr,M);
Sstore_Mead("S2",Y,Month)= Storage_Mead.L(yr,M);
Rel_volPowell("S2",Y)= Sum(M,Rel_Powell.L(yr,M));
Rel_volMead("S2",Y)= Sum(M,Rel_Mead.L(yr,M));

ModelResults("S2",Y,Month,"SolStat")=Model2.solvestat;
ModelResults("S2",Y,Month,"ModStat")=Model2.modelstat;
);

option clear=Rel_Powell,clear=Rel_Mead,clear=Storage_Powell,clear=Storage_Mead;
DISPLAY Rstore_Powell,Rstore_Mead,Sstore_Powell,Sstore_Mead,Rel_volPowell,Rel_volMead;

*********************************************************************************************
*********************************************************************************************
MODEL Model3 Only consider Pearce Ferry objective using NLP/EQ1_Powell_1styr,EQ2_Powell_2ndyr,EQ3_Powell_3rdyr,EQ4_Mead_1styr,EQ5_Mead_2ndyr,EQ6_Mead_3rdyr,EQ7_maxstor_Powell,EQ8_maxstor_Mead,EQ9_minstor_Powell,EQ10_minstor_Mead,EQ11_MaxR_Powell,EQ12_MaxR_Mead,EQ13_MinR_Powell,EQ14_MinR_Mead,EQ15_TotVolPowell,EQ16_TotVolMead,EQ17_obj_temp,EQ18_obj_LB,EQ19_obj_Mead/;


option optcr=0.001;
option NLP= CONOPT;

SOLVE Model3 USING nlp maximize Mead_Obj;
Hoover_Elev("S3")= Mead_Obj.L;

loop((Y,m),

Rstore_Powell("S3",Y,Month)= Rel_Powell.L(yr,M);
Rstore_Mead("S3",Y,Month)= Rel_Mead.L(yr,M);
Sstore_Powell("S3",Y,Month)= Storage_Powell.L(yr,M);
Sstore_Mead("S3",Y,Month)= Storage_Mead.L(yr,M);
Rel_volPowell("S3",Y)= Sum(M,Rel_Powell.L(yr,M));
Rel_volMead("S3",Y)= Sum(M,Rel_Mead.L(yr,M));

ModelResults("S3",Y,Month,"SolStat")=Model3.solvestat;
ModelResults("S3",Y,Month,"ModStat")=Model3.modelstat;
);

option clear=Rel_Powell,clear=Rel_Mead,clear=Storage_Powell,clear=Storage_Mead;
DISPLAY Rstore_Powell,Rstore_Mead,Sstore_Powell,Sstore_Mead,Rel_volPowell,Rel_volMead;

*********************************************************************************************
*********************************************************************************************
MODEL Model4 Only consider the Lower Basin Hoover Dam objective Using NLP/ALL/;


option optcr=0.001;
option NLP= CONOPT;

SOLVE Model4 USING nlp maximize MeadLB_Obj;
Hoover_LB("S4")= MeadLB_Obj.L;

loop((Y,m),

Rstore_Powell("S4",Y,Month)= Rel_Powell.L(yr,M);
Rstore_Mead("S4",Y,Month)= Rel_Mead.L(yr,M);
Sstore_Powell("S4",Y,Month)= Storage_Powell.L(yr,M);
Sstore_Mead("S4",Y,Month)= Storage_Mead.L(yr,M);
Rel_volPowell("S4",Y)= Sum(M,Rel_Powell.L(yr,M));
Rel_volMead("S4",Y)= Sum(M,Rel_Mead.L(yr,M));

ModelResults("S4",Y,Month,"SolStat")=Model4.solvestat;
ModelResults("S4",Y,Month,"ModStat")=Model4.modelstat;
);

option clear=Rel_Powell,clear=Rel_Mead,clear=Storage_Powell,clear=Storage_Mead;
DISPLAY Rstore_Powell,Rstore_Mead,Sstore_Powell,Sstore_Mead,Rel_volPowell,Rel_volMead;


*********************************************************************************************
*********************************************************************************************
MODEL Model5 All objectives using NLP/ALL/;

option optcr=0.001;
option NLP= CONOPT;

SOLVE Model5 USING nlp maximize Tot_Obj;
GCD_Temp("S5")= Temp_Obj.L;
GCD_LB("S5")=LB_Obj.L;
Hoover_Elev("S5")= Mead_Obj.L;
Hoover_LB("S5")= MeadLB_Obj.L;

loop((Y,m),

Rstore_Powell("S5",Y,Month)= Rel_Powell.L(yr,M);
Rstore_Mead("S5",Y,Month)= Rel_Mead.L(yr,M);
Sstore_Powell("S5",Y,Month)= Storage_Powell.L(yr,M);
Sstore_Mead("S5",Y,Month)= Storage_Mead.L(yr,M);
Rel_volPowell("S5",Y)= Sum(M,Rel_Powell.L(yr,M));
Rel_volMead("S5",Y)= Sum(M,Rel_Mead.L(yr,M));

ModelResults("S5",Y,Month,"SolStat")=Model5.solvestat;
ModelResults("S5",Y,Month,"ModStat")=Model5.modelstat;
);

option clear=Rel_Powell,clear=Rel_Mead,clear=Storage_Powell,clear=Storage_Mead;
DISPLAY Rstore_Powell,Rstore_Mead,Sstore_Powell,Sstore_Mead,Rel_volPowell,Rel_volMead;


*------------------------------------------------------------------------------*
* Dump all input data and results to a GAMS gdx file
Execute_Unload "initial_Results.gdx";
* Dump the gdx file to an Excel workbook
Execute "gdx2xls initial_Results.gdx"
