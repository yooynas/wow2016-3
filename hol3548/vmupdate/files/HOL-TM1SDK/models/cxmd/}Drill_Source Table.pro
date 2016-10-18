601,100
602,"}Drill_Source Table"
562,"ODBC"
586,"AdventureWorksDW"
585,"AdventureWorksDW"
564,
565,"zyyw[4D3fF0yQ8sL_woiCBD^LvauGKQpTf`4dI?Llw[QyB8>9Zm[ork[EOLJfTmpJSiq[Enos^kAsR5q1T;]?N>H]zfIYj_etZkOJkdX5DtzTD^>IyzA\CBH7DTNl4NS_yM32Bv1@q<l]B8pP=Cp12>N76d7:nB;`4VqSyIhQ\h]6;3<m;7965>?62IpjuNfYoat3liz"
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
566,16
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
LIMIT 200
567,","
588,"."
589,
568,""""
570,
571,
569,0
592,0
599,1000
560,9
cubename
Version
Year
Period
Currency
Region
Department
Account
General Ledger Measure
561,9
2
2
2
2
2
2
2
2
2
590,9
cubename,"General Ledger"
Version,"1"
Year,"2006"
Period,"Year"
Currency,"Local"
Region,"1"
Department,"1"
Account,"1"
General Ledger Measure,"Planning Measures"
637,9
cubename,""
Version,""
Year,""
Period,""
Currency,""
Region,""
Department,""
Account,""
General Ledger Measure,""
577,0
578,0
579,0
580,0
581,0
582,7
IgnoredInputVarName=ScenarioKeyVarType=32ColType=1165
IgnoredInputVarName=YrVarType=32ColType=1165
IgnoredInputVarName=MthVarType=32ColType=1165
IgnoredInputVarName=OrganizationKeyVarType=32ColType=1165
IgnoredInputVarName=DepartmentGroupKeyVarType=32ColType=1165
IgnoredInputVarName=AccountKeyVarType=32ColType=1165
IgnoredInputVarName=AmountVarType=33ColType=1165
603,0
572,2
#****Begin: Generated Statements***
#****End: Generated Statements****
573,2
#****Begin: Generated Statements***
#****End: Generated Statements****
574,2
#****Begin: Generated Statements***
#****End: Generated Statements****
575,3
#****Begin: Generated Statements***
RETURNSQLTABLEHANDLE;
#****End: Generated Statements****
576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,1
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
