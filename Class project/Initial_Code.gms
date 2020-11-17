$ontext
Re-operate Lake Powell and Lake Mead for Ecosystem and Water Supply Benefits (3 year model)
###################################
Created By: Moazzam and Mahmudur Rahman Aveek
Email: moazzamalirind@gmail.com

Created : 10/28/2020
Last updated: 11/16/2020

Description: (You can write this or I can write sometime, a breif abstract telling what this model is about and what it produce as output)
This model considers water year calender for its calculations.

######################################
$offtext

****Model code:

Set

             M                  Months in three years /M1*M36/
             P                  Periods in a day /pLow "off-peak period", pHigh "on-peak period"/
            modpar              Saving model parameter for each of the solutions for each of the scenario/ ModStat "Model Statistics", SolStat "Solve Statistics"/
             case               Defining constrainted cases for number of low flow steady days /case1*case4/
;


*Define a second name for the sets
*Alias (Month,Mo)

*======================================
Parameters
*======================================
*Initial storages
Init_Powell                           Initial reservoir storage in Lake Powell i.e. storage on 30th september (acre-ft)/14664000/
Init_Mead                             Initial reservoir storage in Lake Mead i.e. storage on 30th september (acre-ft)/10182000/
*Here  we consider 2018,2019,2020 water years as an example. The values given here were measured at the start of october 2017.

*Inflows to the system
Inflow_Powell(M)                      Monthly average inflows to lake Powell during three years (acre-ft)
Inflow_Paria(M)                       Monthly average inflows from Paria river during three years (acre-ft)
Inflow_LitColorado(M)                 Monthly average inflows from Little Colorado river during three years (acre-ft)
Inflow_KanabCreek(M)                  Monthly average inflows from KanabCreek during three years (acre-ft)
Inflow_Havasu(M)                      Monthly average inflows from Havasu during three years (acre-ft)
Inflow_Diamond(M)                     Monthly average inflows from Diamond during three years (acre-ft)
*Inflow_unknown(M)                     Monthly average inflows from different tributaries.. creeks and groundwater contribution (acre-ft)

* Structural and operational constraints
****************
*Lake Powell
***************
Maxstorage_Powell                     Maximum Reservoir capacity of Lake Powell (acre-ft)/27865918/
*Volume total capacity at maximum storage level of 3710 FT
Minstorage_Powell                     Minimum reservoir storage to generate hydropower(acre-ft)/5892163/
*Volume total capacity at 3470 FT level (Level of Penstocks intake)
*Elevation to storage curve information can be found at; https://www.usbr.gov/lc/region/programs/strategies/FEIS/AppA.pdf

Min_RelPowell                         Minimum Powell release during any time period (cfs)/8000/
Max_RelPowell                         Maximum Powell release during any time period (cfs)/31500/
*Information can be found at: https://ltempeis.anl.gov/documents/docs/LTEMP_ROD.pdf. Look for alternative D

evap_Powell(M)                        Monthly Evaporation during three years from Lake powell (ac-ft)
Demand_Powell                         Lower basin demand from Lake Powell over three years period (ac-ft)/24690000/


**************
*Lake Mead
**************
Maxstorage_Mead                       Maximum Reservoir capacity of Lake Mead (acre-ft)/27767000/
* total capacity at maximum storage level
Minstorage_Mead                       Minimum reservoir storage to generate hydropower(acre-ft)/7683000/
* total capacity at (Level at Penstocks intake)
****Elevation to storage curve information can be found at; (Provide source here)

Min_RelMead                           Minimum Mead release during any time period (cfs)/8000/
Max_RelMead                           Maximum Mead release during any time period (cfs)/49000/
*Information can be found at:
evap_Mead(M)                          Monthly Evaporation during three years from Lake Mead (ac-ft)
Demand_Powell                         Lower basin demand from Lake Powell over three years period (ac-ft)/24690000/

**************************************************

Duration(P)                           Duration of period (hour)/pLow 8, pHigh 16/

Days_Steady(M)                        Number of steady low flow days in a month
Steady_Days1(case)                    Number of steady low flow days in a 31 days month /case1 0, case2 8,case3 15, case4 31/
Steady_Days2(case)                    Number of steady low flow days in a 30 days month /case1 0, case2 8,case3 15, case4 30/
Steady_Days3(case)                    Number of steady low flow days in a 28 days month /case1 0, case2 8,case3 15, case4 28/


*Storing Results
FStore(case)                           Storing objective function value for a number of steady flow scenario (case) over three year period
MStore(case,M)                         Storing objective function value for a number of steady flow scenario (case) on a monthly scale.

RStore_steady(case,M)                  Store Release values during steady flow for a number of steady flow scenario (case) on a monthly scale (cfs)
RStore_unsteady(case,M)                Store Release values during steady flow for a number of steady flow scenario (case) on a monthly scale (cfs)

Sstore_Powell(case,M)                  Store Storage Values of Powell for a number of steady flow scenario (case) on a monthly scale (ac-ft)
Sstore_Mead(case,M)                    Store Storage Values of Mead for a number of steady flow scenario (case) on a monthly scale (ac-ft)
;

*===================================================
* Read data from Excel
*===================================================
$CALL GDXXRW.EXE input=Input_2017-20WY.xlsx output=initial_Results.gdx   par=Inflow_Powell rng=Inflow_powell!A1 Rdim=1  par=Inflow_Paria rng=Inflow_paria!A1 Rdim=1  par=Inflow_LitColorado rng=Inflow_littleColorado!A1 Rdim=1 par=Inflow_unknown rng=Inflow_unknown!A1 Rdim=1 par=evap_Powell rng=evap_powell!A1 Rdim=1 par=evap_Mead rng=evap_mead!A1 Rdim=1

*Write the input Data into a GDX file
$GDXIN initial_Results.gdx

* loading parameters and input data from the GDX file into the model
$LOAD Inflow_Powell
$LOAD Inflow_Paria
$LOAD Inflow_LitColorado
$LOAD Inflow_KanabCreek
$LOAD Inflow_Havasu
$LOAD Inflow_Diamond
$LOAD evap_Mead
$LOAD evap_Powell

*Close the GDX file
$GDXIN

Display Inflow_Powell,Inflow_Paria,Inflow_LitColorado,Inflow_KanabCreek,Inflow_Havasu,Inflow_Diamond,evap_Powell,evap_Mead;
*===============================================

*========================================
Scalar
*========================================
Convert                      conversion factor from cfs to ac-ft per hour (0.0014*60)/0.084/
Ramprate_Powell              Allowable daily ramp rate at lake Powell (cfs)/8000/
Ramprate_Mead                Allowable daily ramp rate at lake Mead (cfs)/8000/
*Please find the number for Lake mead if there is any.

Elev_Powell_Low              Desirable ELevation ( coverted into corresponding reservior storage) of Lake powell to produce favorable downstream release temperature lower end  (ac-ft) /4096000/
Elev_Powell_High             Desirable ELevation (coverted into corresponding reservior storage) of Lake powell to produce favorable downstream release temperature upper end  (ac-ft) /6270000/
Elevation_Mead               Desirable Elevation of Lake Mead for to maintain the Peace ferry rapid (ac-ft)upper end /15120000/
Num_Days1                    Number of days in a 31 days month /31/
Num_Days2                    Number of days in a 30 days month /30/
Num_Days3                    Number of days in a 28 days month /28/

;

Variables

*Mass balance at various locations of the study area

Storage_Powell(M)          Storage in Lake Powell at each time step (ac-ft)
Flow_atParia(M)            Inflows at the confluence point of Paria River (cfs)
Flow_atlitColorado(M)      Inflows at the confluence point of Little colorado River (cfs)
Flow_atDiamond(M)          Inflows at the confluence point of Dimaond creek (cfs)
Storage_Mead(M)            Storage in Lake Mead at each time step (ac-ft)

*Releases
SteadyRel_Powell(M)        Steady release from lake powell (cfs)
UnsteadyRel_Powell(M,P)    Unsteady release from Lake powell (cfs)
UnsteadyRel_Mead(M,P)      Unsteady release from Lake Mead (cfs)

*Volumes
Vol_Powell                 Total volume of water released from lake powell during study period (ac-ft)
Vol_Mead                   Total volume of water released from lake Mead during study period (ac-ft)
*Objective function
Obj_Value                  Objective function value
*Not sure we might need to have variables for each objectives and then add them in the obj_value objective



**************************************************************************************************************************
Equation
EQ1_BalancePowell(M)       Mass balance at Lake powell (ac-ft)
EQ2_BalanceParia(M)        Mass balance at Paria River conflunce (cfs)
EQ3_BalanceLitColorado(M)  Mass balance at Little Colorado river conflunce (cfs)
EQ4_BalanceDiamond(M)      Mass balance at Diamond creek confluence (cfs)
EQ5_BalanceMead(M)         Mass balance at Lake Mead (ac-ft)
EQ6_maxstor_Powell(M)      Powell storage max (ac-ft)
EQ7_maxstor_Mead(M)        Mead storage max (ac-ft)
EQ8_minstor_Powell(M)      The minimum storage equivalent to reservoir level required for hydropower generation at Lake Powell (ac-ft)
EQ9_minstor_Mead(M)        The minimum storage equivalent to reservoir level required for hydropower generation at Lake Mead (ac-ft)
EQ10_MaxR_Powell(M,P)      Max Release during anytime step for Powell(cfs)
EQ11_MaxR_Mead(M,P)        Max Release during anytime step for Mead(cfs)
EQ12_MinR_Powell(M,P)      Minimum Release during anytime step for Powell(cfs)
EQ13_MinR_Mead(M,P)        Minimum Release during anytime step for Mead(cfs)
EQ14_Ramprate_Powell(M,P)  Constraining the daily ramp up rate between the timesteps(cfs)with in same day for Powell
EQ15_Ramprate_Mead(M,P)    Constraining the daily ramp up rate between the timesteps(cfs)with in same day for Mead
EQ16_SteadyRelease(M)      Assuming steady day release equal to off peak unsteady release at Lake Powell (cfs)

$ontext
 What we want to do by this model:
We are thinking of 4 objectives:   1. Meet the annual lower basin demand of 8.23 MAF. Now we not sure how to differentiate three years. Also the model don't have preference for any of the months.
                                      If we are considering the total powell release for three years like Eq 17 is doing then it will be more kind of volume constraint not a objective. Not exactly sure on what basis we should assign weightage to different months or differeniate them.

2. Increase the number of summer months when the storage in lake powell is between Elev_Powell_Low amd Elev_Powell_High.
In other words, we asking model to have such a release volume for other months that in summer it should have storage between low and high so the release temperature will be warm

3. We are trying to maximize the number of months that Lake mead should be blow Elevation_Mead to maintain peace ferry rapid

4. We are observing the impact of steady low flows specifically during summer months. We want to know how much number of steady flow days influences the monthly volumes decision over a year maybe.
Objective 4 is kind of additional and can be removed. That means we will get rid  of periods and the model will be just telling the monthly flow volumes not the hydrograph.


We are struggling to find exact equations and connectivity for these objectives.. So the equations below are just part of brainstroming.



$offtext
*Might be the following two equations are not required
EQ17_TotVolPowell          Total volume of water released from Lake powell during study period (ac-ft)
EQ18_TotVolMead            Total volume of water released from Lake Mead during study period (ac-ft)

*Not sure how to differentiate
EQ19_Obj_LB1               Objective to meet the lower basin demand of 8.23 MAF per year (WY1) (ac-ft)
EQ20_Obj_LB2               Objective to meet the lower basin demand of 8.23 MAF per year (WY2) (ac-ft)
EQ21_Obj_LB3               Objective to meet the lower basin demand of 8.23 MAF per year (WY3) (ac-ft)


EQ22_obj_temp             Objective counting number of summer months we will be releasing water from desirable storage level window
EQ23_obj_Mead             Objective to maximize the number of months when storage at mead is less than peace ferry storage level
EQ24_Totobj               Overall objective of the model consisting of all the objectives



;
*****************************************************************************************************************************


*Equation 1 and 2 thinks that first 21 months are months with 31 days, the following 11 months are 30 days months, and the final three months are 28 days months.
*The assumption made here is not align with the inflows, so not sure how to rewrite this.

EQ1_BalancePowell(M)..          Storage_Powell(M)=e= Init_Powell$(ord(M)eq 1)+ Storage_Powell(M-1)$(ord(M)gt 1)+Inflow_Powell(M)- SteadyRel_Powell(M)*Convert*sum(P,Duration(P))* Num_Days1$(ord(M)le 21)- SteadyRel_Powell(M)*Convert*sum(P,Duration(P))*Num_Days2$(ord(M)gt 21 and le 33)- SteadyRel_Powell(M)*Convert*sum(P,Duration(P))*Num_Days3$(ord(M)gt 33)- sum(P,UnsteadyRel_Powell(M,P)*Convert*Duration(P))* Num_Days1$(ord(M)le 21)- sum(P,UnsteadyRel_Powell(M,P)*Convert*Duration(P))*Num_Days2$(ord(M)gt 21 and le 33)- sum(P,UnsteadyRel_Powell(M,P)*Convert*Duration(P))*Num_Days3$(ord(M)gt 33)- evap_Powell(M);
EQ2_BalanceParia(M)..           Flow_atParia(M)=e= Inflow_Paria(M)+ SteadyRel_Powell(M)*Convert*sum(P,Duration(P))* Num_Days1$(ord(M)le 21)+ SteadyRel_Powell(M)*Convert*sum(P,Duration(P))*Num_Days2$(ord(M)gt 21 and le 33)+ SteadyRel_Powell(M)*Convert*sum(P,Duration(P))*Num_Days3$(ord(M)gt 33)+ sum(P,UnsteadyRel_Powell(M,P)*Convert*Duration(P))* Num_Days1$(ord(M)le 21)+ sum(P,UnsteadyRel_Powell(M,P)*Convert*Duration(P))*Num_Days2$(ord(M)gt 21 and le 33)+ sum(P,UnsteadyRel_Powell(M,P)*Convert*Duration(P))*Num_Days3$(ord(M)gt 33);
****we need to find a equation that will show the contribution of particular river in the downstream temperature. Else there is no need to make sub-reaches.

EQ3_BalanceLitColorado(M)..     Flow_atlitColorado(M)=e= Flow_atParia(M)+ Inflow_LitColorado(M);
EQ4_BalanceDiamond(M)..         Flow_atDiamond(M)=e=  Flow_atlitColorado(M)+ Inflow_KanabCreek(M)+ Inflow_Havasu(M)+Inflow_Diamond(M);
*I am assuming no evaporation from the system with in  the grand canyon. If you want to include that estimate that between the gages and subtract from equations equally.

EQ5_BalanceMead(M)..            Storage_Mead(M)=e= Init_Mead$(ord(M)eq 1)+ Storage_Powell(M-1)$(ord(M)gt 1)+ Flow_atDiamond(M)- sum(P,UnsteadyRel_Mead(M,P)*Convert*Duration(P))* Num_Days1$(ord(M)le 21)- sum(P,UnsteadyRel_Mead(M,P)*Convert*Duration(P))*Num_Days2$(ord(M)gt 21 and le 33)- sum(P,UnsteadyRel_Mead(M,P)*Convert*Duration(P))*Num_Days3$(ord(M)gt 33)- evap_Mead(M);
EQ6_maxstor_Powell(M)..         Storage_Powell(M)=l= Maxstorage_Powell;
EQ7_maxstor_Mead(M)..           Storage_Mead(M)=l= Maxstorage_Mead;
EQ8_minstor_Powell(M)..         Storage_Powell(M)=g= Minstorage_Powell;
EQ9_minstor_Mead(M)..           Storage_Mead(M)=g= Minstorage_Mead;
EQ10_MaxR_Powell(M,P)..         UnsteadyRel_Powell(M,P)=L= Max_RelPowell;
EQ11_MaxR_Mead(M,P)..           UnsteadyRel_Mead(M,P)=L= Max_RelMead;
EQ12_MinR_Powell(M,P)..         UnsteadyRel_Powell(M,P)=g= Min_RelPowell;
EQ13_MinR_Mead(M,P)..           UnsteadyRel_Mead(M,P)=g= Min_RelMead;
EQ14_Ramprate_Powell(M,P)..     UnsteadyRel_Powell(M,"pHigh")- UnsteadyRel_Powell(M,"pLow")=l= Ramprate_Powell;
EQ15_Ramprate_Mead(M,P)..       UnsteadyRel_Mead(M,"pHigh")- UnsteadyRel_Mead(M,"pLow")=l= Ramprate_Mead;
EQ16_SteadyRelease(M)..         SteadyRel_Powell(M)=e= UnsteadyRel_Powell(M,"pLow");

EQ17_TotVolPowell..             Vol_Powell=e= SteadyRel_Powell(M)*Convert*sum(P,Duration(P))* Num_Days1$(ord(M)le 21)+ SteadyRel_Powell(M)*Convert*sum(P,Duration(P))*Num_Days2$(ord(M)gt 21 and le 33)+ SteadyRel_Powell(M)*Convert*sum(P,Duration(P))*Num_Days3$(ord(M)gt 33)+ sum(P,UnsteadyRel_Powell(M,P)*Convert*Duration(P))* Num_Days1$(ord(M)le 21)+ sum(P,UnsteadyRel_Powell(M,P)*Convert*Duration(P))*Num_Days2$(ord(M)gt 21 and le 33)+ sum(P,UnsteadyRel_Powell(M,P)*Convert*Duration(P))*Num_Days3$(ord(M)gt 33);
EQ18_TotVolMead..               Vol_Mead=e= sum(P,UnsteadyRel_Mead(M,P)*Convert*Duration(P))* Num_Days1$(ord(M)le 21)+ sum(P,UnsteadyRel_Mead(M,P)*Convert*Duration(P))*Num_Days2$(ord(M)gt 21 and le 33)+ sum(P,UnsteadyRel_Mead(M,P)*Convert*Duration(P))*Num_Days3$(ord(M)gt 33) ;



EQ19_Obj_LB1..                   Obj1A=e= if ((sum(P,UnsteadyRel_Mead$(ord (M),P)*Convert*Duration(P))* Num_Days1$(ord(M)le 21)





EQ20_obj_temp..                 Obj2=e= sum((M)$(Storage_Powell(M)>Elev_Powell_Low or Storage_Powell(M)<Elev_Powell_High),1);


