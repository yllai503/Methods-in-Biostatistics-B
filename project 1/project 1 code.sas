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

data proj.ptw_project1b;
set proj.ptw_project1;
keep fsi1 ageBaseline white income3 married site isi1 cesd1;
run;

data proj.ptw_project1b;
set proj.ptw_project1b;
if nmiss(of _numeric_)> 0 then delete;
run;

proc reg data = proj.ptw_project1b;
  model isi1 = ageBaseline;
run;


proc reg data = proj.ptw_project1b;
  model isi1 = white;
run;

data proj.ptw_project1b; set proj.ptw_project1b;
    if income3=2 then income10=1; else income10=0;
    if income3=3 then income_more=1; else income_more=0;
run;

proc reg data = proj.ptw_project1b;
  model isi1 = income10 income_more;
run;

proc reg data = proj.ptw_project1b;
  model isi1 = income3;
run;

proc reg data = proj.ptw_project1b;
  model isi1 = married;
run;

data proj.ptw_project1b; set proj.ptw_project1b;
    if site=2 then site_jh=1; else site_jh=0;
    if site=3 then site_la=1; else site_la=0;
run;

proc reg data = proj.ptw_project1b_s;
  model isi1 = site_jh site_la;
run;

proc reg data = proj.ptw_project1b;
  model isi1 = fsi1;
run;

proc reg data = proj.ptw_project1b;
  model isi1 = cesd1;
run;

proc reg data = proj.ptw_project1b;
  model isi1 = ageBaseline white income10 income_more married site_jh site_la fsi1 cesd1;
  test_income: test income10, income_more;
  test_site: test site_jh, site_la;
run;

/*
part a: bmi
part b: site income3
*/

data proj.ptw_project1c;
 set proj.ptw_project1;
 if isi2 = . then evaluable = 0;
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

proc freq data=proj.ptw_project1c;
tables site*evaluable/ fisher;
format site SIT.;
run;

proc reg data=proj.ptw_project1c;
 model isi2 = isi1 tx_group bmi site income3;
run;

proc means data=proj.ptw_project1c n mean std maxdec=1;
var isi2;
class tx_group;
run;

