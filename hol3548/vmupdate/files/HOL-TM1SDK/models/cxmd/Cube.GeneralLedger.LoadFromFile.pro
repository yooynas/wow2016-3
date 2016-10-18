601,100
602,"Cube.GeneralLedger.LoadFromFile"
562,"CHARACTERDELIMITED"
586,"C:\TM1\cxmd\Data\GLData.csv"
585,"C:\TM1\cxmd\Data\GLData.csv"
564,"user"
565,"cPheF1>ZM1?wPHZokp[1yQ=9gQmG18`FQm90ZKd1bLBkDi1l]DXU1FAaudR6aVcR4aXucInEvw@gGuB5jLr\pkZ7ql]zoQTl477DVh7ITXUeS@|C_FpZWcemE9psC3d`pwc<<[Pz^KJzi^F4VcIn`laPu]yOS2`=IGLRX^fhm3_T0gy_GYjf:0vfs25M3Pqx0wh:gjND"
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
566,15
SELECT CAST(ScenarioKey as TEXT) ScenarioKey,
	SUBSTR(DateKey, 1, 4) Yr,
	SUBSTR(DateKey, 5, 2) Mth,
	CAST(OrganizationKey as TEXT) OrganizationKey,
	CAST(DepartmentGroupKey AS TEXT) DepartmentGroupKey,
	CAST(AccountCodeAlternateKey as TEXT) AccountKey,
	SUM(Amount) Amount
FROM FactFinance a
	INNER JOIN DimAccount b ON a.AccountKey = b.AccountKey
GROUP BY SUBSTR(DateKey, 1, 4),
	SUBSTR(DateKey, 5, 2),
	OrganizationKey,
	DepartmentGroupKey,
	ScenarioKey,
	AccountCodeAlternateKey
567,","
588,"."
589,","
568,""""
570,
571,
569,1
592,0
599,1000
560,1
pVersion
561,1
2
590,1
pVersion,""
637,1
pVersion,""
577,7
vScenarioKey
vYear
vMonth
vOrganizationKey
vDepartmentGroupKey
vAccountKey
vAmount
578,7
2
2
2
2
2
2
1
579,7
1
2
3
4
5
6
7
580,7
0
0
0
0
0
0
0
581,7
0
0
0
0
0
0
0
582,7
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
603,0
572,13

#****Begin: Generated Statements***
#****End: Generated Statements****

sCubeName = 'General Ledger';


#ExecuteProcess('Bedrock.Cube.Data.ZeroOut', 'pCube', sCubeName);

cCurrency = 'Local';

DatasourceNameForServer = 'GLData.csv';
DatasourceNameForClient = 'GLData.csv';
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,30

#****Begin: Generated Statements***
#****End: Generated Statements****

If(StringToNumber(vMonth) > 6);
    vYear = NumberToString(StringToNumber(vYear));
EndIf;

If(vDepartmentGroupKey @= '1');
    vDepartmentGroupKey = '2';
EndIf;

#If( CellIsUpdateable(sCubeName, vScenarioKey, vYear, vMonth, cCurrency, vOrganizationKey, vDepartmentGroupKey, vAccountKey, 'AMOUNT') = 1);
#  CellPutN(vAmount, sCubeName, vScenarioKey, vYear, vMonth, cCurrency, vOrganizationKey, vDepartmentGroupKey, vAccountKey, 'AMOUNT');
#EndIf;



IF(vScenarioKey@<>'1');
itemskip;
endif;

If( CellIsUpdateable(sCubeName, pVersion, vYear, vMonth, cCurrency, vOrganizationKey, vDepartmentGroupKey, vAccountKey, 'AMOUNT') = 1);
IF(pVersion@='Budget');
  CellPutN(vAmount*1.1, sCubeName, pVersion, vYear, vMonth, cCurrency, vOrganizationKey, vDepartmentGroupKey, vAccountKey, 'AMOUNT');
ELSE;
  CellPutN(vAmount, sCubeName, pVersion, vYear, vMonth, cCurrency, vOrganizationKey, vDepartmentGroupKey, vAccountKey, 'AMOUNT');
ENDIF;

EndIf;
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
