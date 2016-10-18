601,100
602,"Dim.Employee.AddNewEmployee"
562,"NULL"
586,
585,
564,
565,"qY^e3@oPYPFvytWQ\aE_sSiPT<i\gX`OGkhhfAuy_AyY<_Wu]p`[9y@5L0m9e6BMxAMyaXx@>n>044P\Vz2vQwD;mO5T3fm<B?HOTSK>SdK@ETF:<SarLWj;:s28jUxMHpCabb4L>gjRAS\qinwLEwr8:xu49^v2EgK`R0Jwk6fvvg>3IT2zF9y3:zYO\AUL@04K324:"
559,1
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,0
567,","
588,"."
589,
568,""""
570,
571,
569,0
592,0
599,1000
560,7
pID
pName
pDept
pRegion
pMethod
pSalary
pStartDate
561,7
2
2
2
2
2
1
2
590,7
pID,""
pName,""
pDept,""
pRegion,""
pMethod,""
pSalary,0
pStartDate,""
637,7
pID,""
pName,""
pDept,""
pRegion,""
pMethod,""
pSalary,""
pStartDate,""
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,9

#****Begin: Generated Statements***
#****End: Generated Statements****

DimensionElementInsert('Employee','',pID,'N');

DimensionElementComponentAdd('Employee','All Employees',pID,1);


573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,34

#****Begin: Generated Statements***
#****End: Generated Statements****

#Add attributes

sDept=ATTRS('Department',pDept,'Description');
sRegion=ATTRS('Region',pRegion,'Description');

ATTRPUTS(pName,'Employee',pID,'Full Name');
ATTRPUTS(sDept,'Employee',pID,'Department Name');
ATTRPUTS(sRegion,'Employee',pID,'Region');

#Add Start and End Dates
#ATTRPUTS(pStartDate,'Employee',pID,'StartDate');
CellPutS(pStartDate,'Employee','Budget','2016','Year_Enter','Local',pRegion,pDept,pID,'Start Date');
CellPutS('2050-12-31','Employee','Budget','2016','Year_Enter','Local',pRegion,pDept,pID,'End Date');

##############################
#Add data to employee cube
##############################

#Salary
CELLPUTN(pSalary,'Employee','Budget','2016','Year_Enter','Local',pRegion,pDept,pID,'Enter Full Time Base Salary');

#Pay Method
CELLPUTS(pMethod,'Employee','Budget','2016','Year_Enter','Local',pRegion,pDept,pID,'Pay Method');

#FTE
#i=1;
#WHILE(i<=12);
#   CELLPUTN(1,'Employee','Budget','2016',NumberToString(i),'Local',pRegion,pDept,pID,'FTE');
#   i=i+1;
#END;
576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,0
900,
901,
902,
938,0
937,
936,
935,
934,
932,0
933,0
903,
906,
929,
907,
908,
904,0
905,0
909,0
911,
912,
913,
914,
915,
916,
917,0
918,1
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
