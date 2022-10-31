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
proc data=proj.ptw_project1 ;
format married MAR.;
format income3 INC.;
format employed EMP.;
format white WHI.;
format neochemo NEO.;
format mastectomy MAS.;
format tx_group TXG.;
format site SIT.;
run;

proc contents data=proj.ptw_project1;
run;

proc means data=proj.ptw_project1 n mean std min max maxdec=1;
var cesd1 fsi1 isi1 ageBaseline ageDiagnosis yearsSinceDiagnosis bmi;
class tx_group;
format tx_group TXG.;
run;

proc means data=proj.ptw_project1 n mean std min max maxdec=1;
var cesd1 fsi1 isi1 ageBaseline ageDiagnosis yearsSinceDiagnosis bmi;
run;

proc sort data=proj.ptw_project1;
by tx_group;
run;

proc freq data=proj.ptw_project1;
tables married*tx_group income3*tx_group site*tx_group/ CHISQ nopercent norow;
format married MAR.;
format income3 INC.;
format site SIT.;
format tx_group TXG.;
run;

proc freq data=proj.ptw_project1;
tables married income3 site;
format married MAR.;
format income3 INC.;
format site SIT.;
run;

proc ttest data=proj.ptw_project1;
var cesd1 fsi1 isi1 ageBaseline ageDiagnosis yearsSinceDiagnosis bmi;
class tx_group;
format tx_group TXG.;
run;


