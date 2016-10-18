601,100
602,"Dim DepartmentGroup"
562,"ODBC"
586,"AdventureWorksDW 64"
585,"AdventureWorksDW 64"
564,
565,"u[Q0UHV1[3SAcKtxLsSSraAtMHCtEG`5M@;Kfw`RynRA@_nLUpSQJ5yqNT^2mapuKK_v?gka`yNoZ6:z5`sU8uxbYE\YQX;H6ULQT2M[`yl^?r4]:vrIXKf1Fd8e?y=UTenbnF=rAd?lUrJ^q:YCefMSaO?9eCwj[U8AP>Z=3W@I<775d?qb?9?:kOAFycm9Qevmru13"
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
566,5
SELECT CAST(DepartmentGroupKey as TEXT) Id, 
	CAST(ParentDepartmentGroupKey as TEXT) Parent, 
	DepartmentGroupName Name
FROM DimDepartmentGroup
ORDER BY CAST(ParentDepartmentGroupKey as NUMBER), CAST(DepartmentGroupKey as NUMBER)
567,","
588,"."
589,
568,""""
570,
571,
569,0
592,0
599,1000
560,0
561,0
590,0
637,0
577,3
Id
Parent
Name
578,3
2
2
2
579,3
1
2
3
580,3
0
0
0
581,3
0
0
0
582,3
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
931,1
0,0,0,
603,0
572,15

#****Begin: Generated Statements***
#****End: Generated Statements****

sDimName = 'Department Group';

If(DimensionExists(sDimName) = 0);
    DimensionCreate(sDimName);
EndIf;

DimensionSortOrder(sDimName, 'ByName', 'Ascending', 'ByHierarchy', 'Ascending');

AttrInsert(sDimName,'','Description','A');


573,10

#****Begin: Generated Statements***
#****End: Generated Statements****

DimensionElementInsert(sDimName,'', Id, 'N');
If(Parent @<> '');
    DimensionElementComponentAdd(sDimName, Parent, Id, 1);
EndIf;


574,7

#****Begin: Generated Statements***
#****End: Generated Statements****


AttrPutS(Name, sDimName, Id, 'Description');

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
