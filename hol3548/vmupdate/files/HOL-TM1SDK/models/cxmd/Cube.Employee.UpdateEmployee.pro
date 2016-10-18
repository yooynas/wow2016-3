601,100
602,"Cube.Employee.UpdateEmployee"
562,"NULL"
586,
585,
564,
565,"laLFY@1V[mL^a7I]zKM6QpktvKtGaJwJ]sfJ<8wQuklMKSEU7]sPOXjh_6yioGb6E9=yBqlKLp8gAShuP=WwM[eam^ow3CnrAh@7^[KLQAfk>N2dLABVDGUQu?eu9hiQLHq2k?s4phO5UeOf]BOUnKpl]>mumQNpE=<uSTMI6bq:6Gqa9fJbxz<@pEiNdtU1JJr`vlTL"
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
560,3
pID
pRegion
pDept
561,3
2
2
2
590,3
pID,"767955365"
pRegion,"poland"
pDept,"sales and marketing"
637,3
pID,""
pRegion,""
pDept,""
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,61

#****Begin: Generated Statements***
#****End: Generated Statements****


bRegion=0;
bDept=0;

pDept=ATTRS('Department',pDept,'Description');
pRegion=ATTRS('Region',pRegion,'Description');

#Current department and region
sCurrentRegion=ATTRS('Employee',pID,'Region');
sCurrentDept=ATTRS('Employee',pID,'Department Name');

sTargetRegion=sCurrentRegion;
sTargetDept=sCurrentDept;

#current salary
#nCurrentSalary=CellGetN('Employee','Budget','2016','Year','Local',sCurrentRegion,sCurrentDept,pID,'Full Time Base Salary');

#Update salary
#IF(nCurrentSalary<>pSalary);
#    CellPutN(pSalary,'Employee','Budget','2016','Year_Enter','Local',sCurrentRegion,sCurrentDept,pID,'Enter Full Time Base Salary');
#ENDIF;

#Update Pay Method
#IF(pMethod@<>'');
#     CellPutS(pMethod,'Employee','Budget','2016','Year_Enter','Local',sCurrentRegion,sCurrentDept,pID,'Pay Method');
#ENDIF;

#Update full name if changed
#IF(pName@<>ATTRS('Employee',pID,'Full Name') & pName@<>'');
#     ATTRPUTS(pName,'Employee',pID,'Full Name');
#ENDIF;

#update department
IF(pDept@<>ATTRS('Employee',pID,'Department Name') & pDept@<>'');
   ATTRPUTS(pDept,'Employee',pID,'Department Name');
   sTargetDept=pDept;   
   bDept=1;
ENDIF;

#update region
IF(pRegion@<>ATTRS('Employee',pID,'Region') & pRegion@<>'');
   ATTRPUTS(pRegion,'Employee',pID,'Region');
   sTargetRegion=pRegion;
   bRegion=1;
ENDIF;

IF(bRegion=1 % bDept=1);
 ExecuteProcess('Cube.Employee.MoveData',
'pID',pID,
'pDeptSrc',sCurrentDept,
'pRegionSrc',sCurrentRegion,
'pDeptTgt',sTargetDept,
'pRegionTgt',sTargetRegion);

ENDIF;


573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,3

#****Begin: Generated Statements***
#****End: Generated Statements****
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
