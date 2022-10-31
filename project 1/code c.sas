libname proj "/home/u48583412/Biostat 200B/Project1";

proc format;
value MAR 1 = "married or living with oartner"
          0 = "not";
value INC 1 = "under $60000"
          2 = "$60000-$100000"
          3 = "$100000 or more";
value EMP 1 = "employed"
          0 = "not";
value WHI 1 = "white"
          0 = "non-white";
value NEO 1 = "yes"
          0 = "no";
value MAS 1 = "yes"
          0 = "no";
value TXG 1 = "mindfulness intervention"
          0 = "control group";
value SIT 1 = "DF"
          2 = "JH"
          3 = "LA";
run;

/* format
format married MAR.;
format income3 INC.;
format employed EMP.;
format white WHI.;
format neochemo NEO.;
format mastectomy MAS.;
format tx_group TXG.;
format site SIT.;
*/

/*
part a: bmi
part b: site income3
*/

data proj.ptw_project1c;
 set proj.ptw_project1;
 if fsi2 = . then evaluable = 0;
 else evaluable = 1;
run;

proc means data=proj.ptw_project1c n mean std min max maxdec=1;
var cesd1 fsi1 isi1 ageBaseline ageDiagnosis yearsSinceDiagnosis bmi;
class evaluable;
run;

proc sort data=proj.ptw_project1c;
by evaluable;
run;

proc freq data=proj.ptw_project1c;
tables married*evaluable income3*evaluable site*evaluable/ CHISQ nopercent norow;
format married MAR.;
format income3 INC.;
format site SIT.;
run;

proc ttest data=proj.ptw_project1c;
var cesd1 fsi1 isi1 ageBaseline ageDiagnosis yearsSinceDiagnosis bmi;
class evaluable;
run;

proc reg data=proj.ptw_project1c;
 model fsi2 = fsi1 tx_group bmi site income3;
run;

proc means data=proj.ptw_project1c n mean std maxdec=1;
var fsi2;
class tx_group;
run;
