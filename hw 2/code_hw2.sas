libname HW "/home/u48583412/Biostat 200B/HW";

*Q2;
proc means data=hw.spirometry;
var age height;
run;

data hw.spirometry1;
set hw.spirometry;
age_year = age/12;
age_mean = age-53.5305493;
height_inches = height*0.393701;
height_mean = height-104.6197183;
run;

proc reg data=hw.spirometry1;
model height = age;
run;

proc reg data=hw.spirometry1;
model height = age_year;
run;

proc reg data=hw.spirometry1;
model height = age_mean;
run;

proc reg data=hw.spirometry1;
model height_inches = age;
run;

proc reg data=hw.spirometry1;
model height_mean = age;
run;




*Q3;
PROC IMPORT OUT= HW.SENIC
            DATAFILE= "/home/u48583412/Biostat 200B/HW/senic.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

proc univariate data=hw.senic;
var risk nurses length svcs;
histogram;
run;

/*1*/
proc reg data=hw.senic;
model risk = nurses;
run;

proc loess data=hw.senic;
model risk = nurses / smooth=0.3 0.4 0.6 0.7;
run;

/*2*/
proc reg data=hw.senic;
model risk = length;
run;

proc loess data=hw.senic;
model risk = length/ smooth=0.3 0.4 0.6 0.7;
run;

data hw.senic2;
set hw.senic;
length1 = -1/length;
run;

proc loess data=hw.senic2;
model risk = length1/ smooth=0.3 0.4 0.6 0.7;
run;

/*3*/
proc reg data=hw.senic;
model nurses = svcs;
run;

proc loess data=hw.senic;
model nurses = svcs / smooth=0.3 0.4 0.6 0.7;
run;

data hw.senic3;
set hw.senic;
lognurses = log(nurses);
run;

proc loess data=hw.senic3;
model lognurses = svcs / smooth=0.3 0.4 0.6 0.7;
run;


