601,100
602,"Dim.Account.LoadFromFile"
562,"CHARACTERDELIMITED"
586,"C:\TM1\cxmd\Data\Account1.csv"
585,"C:\TM1\cxmd\Data\Account.csv"
564,
565,"lX>G:OR:[es:arwgsI_DkSUnc[MrEFw>w]f^]XM1xoEhn8vURHme1Axx[2[CM\S?VBzj7JwzQf86_dnvZc6]@rWh6?H`6ES7A0j?h01K0OB;rzJO3nQ2^gXvQj>tJh1k:Ql[J59Ghn5fJ4hM@vJMZQ@6ZQXZm6CRvWf^sC=mpdu@OjT_aEsxj@2ljVY38;L1oGqZbvS9"
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
589,","
568,""""
570,
571,
569,1
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
572,22

#****Begin: Generated Statements***
#****End: Generated Statements****


DatasourceNameForServer = 'Account.csv';
DatasourceNameForClient = 'Account.csv';

sDimName = 'Account';

If(DimensionExists(sDimName) = 0);
    DimensionCreate(sDimName);
EndIf;

DimensionDeleteAllElements(sDimName);

#DimensionSortOrder(sDimName, 'ByName', 'Ascending', 'ByHierarchy', 'Ascending');

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
575,6

#****Begin: Generated Statements***
#****End: Generated Statements****


#ExecuteProcess('Bedrock.Dim.Sub.Create.All', 'pDimension', sDimName, 'pSubset', 'All Elements');
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
