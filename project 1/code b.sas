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

data proj.ptw_project1b;
set proj.ptw_project1;
keep fsi1 ageBaseline white income3 married site isi1 cesd1;
run;

data proj.ptw_project1b;
set proj.ptw_project1b;
if nmiss(of _numeric_)> 0 then delete;
run;

proc reg data = proj.ptw_project1b;
  model fsi1 = ageBaseline;
run;


proc reg data = proj.ptw_project1b;
  model fsi1 = white;
run;

data proj.ptw_project1b; set proj.ptw_project1b;
    if income3=2 then income10=1; else income10=0;
    if income3=3 then income_more=1; else income_more=0;
run;

proc reg data = proj.ptw_project1b;
  model fsi1 = income10 income_more;
run;

proc reg data = proj.ptw_project1b;
  model fsi1 = income3;
run;

proc reg data = proj.ptw_project1b;
  model fsi1 = married;
run;

data proj.ptw_project1b; set proj.ptw_project1b;
    if site=2 then site_jh=1; else site_jh=0;
    if site=3 then site_la=1; else site_la=0;
run;

proc reg data = proj.ptw_project1b_s;
  model fsi1 = site_jh site_la;
run;

proc reg data = proj.ptw_project1b;
  model fsi1 = isi1;
run;

proc reg data = proj.ptw_project1b;
  model fsi1 = cesd1;
run;

proc reg data = proj.ptw_project1b;
  model fsi1 = ageBaseline white income10 income_more married site_jh site_la isi1 cesd1;
  test_income: test income10, income_more;
  test_site: test site_jh, site_la;
run;


