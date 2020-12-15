______________________________________________________________________________
RE-OPERATE LAKE POWELL AND LAKE MEAD FOR ECOSYSTEM AND WATER SUPPLY BENEFITS
______________________________________________________________________________

Term Project (Fall 2020)
Course: Water Resources System Analysis (CEE-6410)

Project Description: This model is developed to find a cooridated optimal reservoir operation of Lake Powell and Lake mead to benefit both water supply and Ecosystem objectives.
The model considers water year calender for its calculations.  

Required software: 1. General Algebraic Modeling System (GAMS), which can be freely downloaded from (https://www.gams.com/download/) but need License to run the model.
                   2. R and R studio, which are open source softwares used for the results visualization. R can be downloaded from (https://www.r-project.org/) 
                       and RStudio is available at (https://rstudio.com/).

Authors: Moazzam Ali Rind, Mahmudur Rahman Aveek

Corresponding author. Email: moazzamalirind@gmail.com

December 14,2020

Utah State University 


______________________________________________________________________________
Recommended Citation
______________________________________________________________________________

Moazzam Rind and Mahmudur Aveek (2020). "Re-operate Lake Powell and Lake Mead for ecosystem and water supply benefits". Utah State University, Logan, Utah.
https://github.com/moazzamalirind/Rind

______________________________________________________________________________
Steps to run the Model and reproduce results
______________________________________________________________________________

GAMS Model

1. Download code file ".gms" and input excel file ".xlsx" and save those files in a single folder located at your desired drive loaction. For example, if interested in 
   the 3 years model then download files: " 3_Years Model.gms" and "Input_2018_20WY.xlsx" and save those in a folder at a desired location. Likewise, for 20 years model
   the required files will be: " 20Years Model.gms" and "Input_2000_20WY.xlsx"

2. Run GAMS IDE and create a new project in the same folder where the downloaded files are located.

3. Import the code into the GAMS IDE interface using File and open options.

4. Run the available code by pressing either F9 or the icon given in the GAMS IDE.

5. GAMS will generate number of files including ".xlsx" and ".gdx" in the same folder where project is saved. Those both files contains same results form all the runs  in two different formats.

6.  At this stage you can compare the results of your run (i.e. eitehr .xlsx or .gdx) with the output files provided in the repository.

RScript (Visualization of the Results)

7. Download the RScript.zip 

8. Extract that file in any folder at your deseried drive location.

9. There will be a RScript file " Visualization_GeneralScript". Open that file in RStudio and read the text given in the start of the script. The text defines the origin and need of all the attached .csv files.
   The idea here is to only use some required results from the "3yr.Results.xlxs" file, instead of processing the whole .xlxs file.
   
10. Run the Visualization_GeneralScript.R file in R studio and you will able to generate all the provided plots.


Note: Both the GAMS code and Rscript has specific detailed comments given for any user who is interested to tweak some of the parameters and equations and see the impact on the results.

Also, we always welcome comments and suggestions to improve the applicability of our work.
   


