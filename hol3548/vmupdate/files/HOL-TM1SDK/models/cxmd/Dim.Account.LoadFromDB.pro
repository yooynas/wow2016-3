601,100
602,"Dim.Account.LoadFromDB"
562,"ODBC"
586,"AdventureWorksDW 64"
585,"AdventureWorksDW 64"
564,
565,"u_t<C6@:V00uyqA__j8KFafKpd6nWz<D37\O>g3h2?6REskHBEO344me0_uYl7hga7>[h4@e7O^`4q3_Jrke>u6Y<qpq`PtyjCTzYtmdVd\;QGGDyH<0EFRyn1^KcPi02hDTH[Xf[1Oy;nhz;[8O\>fVAaGO`4Vqyi?6:X99je;jLKD2x?B@[E2CjNQtAD5ACe??BD^Z"
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
566,7
SELECT CAST(AccountCodeAlternateKey as TEXT) Id, 
	CAST(ParentAccountCodeAlternateKey as TEXT) Parent, 
	AccountDescription Name, 
	AccountType, 
	Operator
FROM DimAccount
ORDER BY CAST(ParentAccountCodeAlternateKey as NUMBER), CAST(AccountCodeAlternateKey as NUMBER)
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
577,5
Id
Parent
Name
AccountType
Operator
578,5
2
2
2
2
2
579,5
1
2
3
4
5
580,5
0
0
0
0
0
581,5
0
0
0
0
0
582,5
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
603,0
572,20

#****Begin: Generated Statements***
#****End: Generated Statements****

# Update the Account dimension

sDimName = 'Account';

If(DimensionExists(sDimName) = 0);
    DimensionCreate(sDimName);
EndIf;

DimensionDeleteAllElements(sDimName);

DimensionSortOrder(sDimName, 'ByName', 'Ascending', 'ByHierarchy', 'Ascending');

AttrInsert(sDimName,'','Description','A');
AttrInsert(sDimName,'','Account Type','S');
AttrInsert(sDimName,'','Operator','S');

573,14

#****Begin: Generated Statements***
#****End: Generated Statements****

DimensionElementInsert(sDimName,'', Id, 'N');
If(Parent @<> '');
    If(Operator @= '-');
        DimensionElementComponentAdd(sDimName, Parent, Id, -1);
    Else;
        DimensionElementComponentAdd(sDimName, Parent, Id, 1);
    EndIf;
EndIf;


574,8

#****Begin: Generated Statements***
#****End: Generated Statements****


AttrPutS(Name, sDimName, Id, 'Description');
AttrPutS(AccountType, sDimName, Id, 'Account Type');
AttrPutS(Operator, sDimName, Id, 'Operator');
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
