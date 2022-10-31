libname proj "/home/u48583412/Biostat 200B/Project 2";

proc sort data = proj.covid_immune out= proj2;
 by id daysPSO;
 run;

/*Some participants were measured more than one time. Use only the FIRST measurement 
for each participant, that is, lowest days post symptom onset. This ensures that our 
observations are independent, and focuses the analysis on early disease.*/

/* cause troble: some patients have same daysPSO with different observations
 proc sql;
 create table proj2a as
 select id, age, peakDiseaseSeverity, gender, log(spikeigg) as logSpikeIgG, SpikeIgG, daysPSO 
 from (
   select id as idd, min(daysPSO) as daysPSO1
   from proj2 group by id) as p 
 inner join proj2 on p.idd = proj2.id and p.daysPSO1 = proj2.daysPSO;*/
 
 /*Not working code*/
 /*
 proc sql;
 create table proj2a as
 select id, peakDiseaseSeverity, gender, log(spikeigg) as logSpikeIgG, daysPSO 
 from proj2
 where daysPSO = (
 select min(daysPSO)
 from proj2 as p where p.id = proj2.id)
 ;
 */



/*Determine the sample that has non-missing values for all variables of interest.*/
data proj2a;
 set proj2;
 by id daysPSO;
 if first.id;
 drop spikeIgA no race ethnicity;
 run;

data proj2b;
 set proj2a;
 if nmiss(of _numeric_)> 0 then delete;
 logSpikeIgG = log(SpikeIgG);
 run;

/*Check distributions of variables for outliers*/
proc univariate data=proj2b plot;
 var SpikeIgG daysPSO;
 histogram SpikeIgG daysPSO;
 run;

proc univariate data=proj2b plot;
 class peakDiseaseSeverity;
 var logSpikeIgG daysPSO;
 histogram logSpikeIgG daysPSO;
 run;

proc sgplot data = proj2b;
 vbar gender / group= peakDiseaseSeverity;
 run;

/**Table 1**/
proc contents data=proj2b;
run;

proc means data=proj2b n mean std min max maxdec=1;
var age SpikeIgG daysPSO;
class peakDiseaseSeverity;
run;

proc means data=proj2b n mean std min max maxdec=1;
var age SpikeIgG daysPSO;
run;

proc sort data=proj2b;
by peakDiseaseSeverity;
run;

proc freq data=proj2b;
tables gender*peakDiseaseSeverity/ CHISQ fisher nopercent norow;
run;

proc anova data=proj2b;
 class peakDiseaseSeverity;
 model age = peakDiseaseSeverity;
 run;

proc npar1way data=proj2b;
 class peakDiseaseSeverity;
 var SpikeIgG;
 run; 

proc anova data=proj2b;
 class peakDiseaseSeverity;
 model daysPSO = peakDiseaseSeverity;
 run; 

/*Trying to fit ANCOVA*/

proc glm data=proj2b;
      class peakDiseaseSeverity;
      model logSpikeIgG = peakDiseaseSeverity / solution ;
	  estimate "mu1" intercept 1 peakDiseaseSeverity 1 0 0;
	  estimate "mu2" intercept 1 peakDiseaseSeverity 0 1 0;
	  estimate "mu3" intercept 1 peakDiseaseSeverity 0 0 1;
	  contrast "tau1 - tau2" peakDiseaseSeverity 1 -1 0;
	  contrast "tau2 - tau3" peakDiseaseSeverity 0 1 -1;
	  contrast "tau1 - tau3" peakDiseaseSeverity 1 0 -1;
run;

proc corr data=proj2b;
var logSpikeIgG daysPSO ;
run;

data proj2c;
 set proj2b;
 peakDiseaseSeverity_new = put(peakDiseaseSeverity,3.);
 drop peakDiseaseSeverity;
 rename peakDiseaseSeverity_new = peakDiseaseSeverity;
 if peakDiseaseSeverity = 1 then peakDiseaseSeveritynew = "A";
 if peakDiseaseSeverity = 2 then peakDiseaseSeveritynew = "B";
 if peakDiseaseSeverity = 3 then peakDiseaseSeveritynew = "C";
 run;

proc sgplot data=proj2c;
    reg y=logSpikeIgG x=daysPSO / group = peakDiseaseSeveritynew;
run;

 proc glm data=proj2b;
      class peakDiseaseSeverity gender;
      model logSpikeIgG = peakDiseaseSeverity|daysPSO gender|daysPSO / solution;
   run;

/*The main result should be based on a two-way ANCOVA model, with peak disease severity 
and gender as the factors and days since symptom onset (daysPSO) as a covariate. 
Comparison among the levels of peak disease severity should use adjusted means 
(LSMEANS in SAS) and test for differences among the disease severity categories using a 
multiple comparison method such as Tukey HSD.*/

proc glm data=proj2b;
	class peakDiseaseSeverity gender;
	model logSpikeIgG = peakDiseaseSeverity gender peakDiseaseSeverity*gender daysPSO daysPSO*peakDiseaseSeverity daysPSO*gender/ solution;
	lsmeans peakDiseaseSeverity / stderr pdiff adjust=tukey;
run;

/*When fitting ANOVA/ANCOVA models, check for interactions. Drop interactions if they appear 
to be unimportant. daysPSO*gender p = .101*/

proc glm data=proj2b;
	class peakDiseaseSeverity gender;
	model logSpikeIgG = peakDiseaseSeverity gender daysPSO / solution;
	means peakDiseaseSeverity;
	lsmeans peakDiseaseSeverity / stderr pdiff cl adjust=tukey;
run;


proc glm data=proj2b;
	class peakDiseaseSeverity gender;
	model logSpikeIgG = peakDiseaseSeverity gender daysPSO peakDiseaseSeverity*gender/ solution;
	means peakDiseaseSeverity*gender / tukey;
	lsmeans peakDiseaseSeverity*gender / stderr pdiff cl adjust=tukey;
run;


/*Conduct model diagnostics to check that model assumptions are reasonably met and check 
for outliers.*/

proc glm data=proj2b;
 class peakDiseaseSeverity gender;
 model logSpikeIgG = peakDiseaseSeverity gender daysPSO/ solution;
 lsmeans peakDiseaseSeverity / stderr pdiff cl adjust=tukey;
 OUTPUT OUT = pred p=ybar r=resid;
 run;

/*
Let's do some diagnostic plots:
*/

PROC GPLOT data=pred;
 PLOT resid*ybar/vref=0;    /* Residuals Plotted vs. Fitted Values */
 PLOT resid*peakDiseaseSeverity/vref=0;   /* Residuals Plotted for each peakDiseaseSeverity Level */
 PLOT resid*gender/vref=0;   /* Residuals Plotted for gender */
run;

PROC UNIVARIATE noprint data=pred;
  QQPLOT resid / normal;    /* Normal Q-Q Plot of Residuals */
run;

PROC UNIVARIATE data=pred normal normaltest;
  var resid;    /* Normal Q-Q Plot of Residuals */
run;

