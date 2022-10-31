libname HW "/home/u48583412/Biostat 200B/HW";

PROC IMPORT OUT= HW.SENIC
            DATAFILE= "/home/u48583412/Biostat 200B/HW/senic.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

proc reg data= hw.senic;
 model risk = beds;
run;

proc reg data= hw.senic;
 model risk = svcs;
run;

proc reg data= hw.senic;
 model nurses = age;
run;

data hw.senic1;
 set hw.senic;
 med = msch;
 if med = 2 then med = 0;
run;

proc reg data= hw.senic1;
 model nurses = med;
run;
