601,100
602,"Email.BurstData"
562,"VIEW"
586,"General Ledger"
585,"General Ledger"
564,
565,"bWaGUXyzPKUqr4tL6[hVY82UdT=604e<c@5mj=4f<z?r7YpekBGilDGZO=q?[FIf4S0@k\xOvcFDsnt6b?nfWk9V<ziv8wh^X=P4;?M?\8KgjZSGHnz<sAO_HRpts]zshwkyhuQCcR9c4CKH9tNMx[hQE6sgOTyMlgjPaQnW`m>;;sBOUHMw[ez0T>6MZm1KZP=GWyQL"
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
570,P&L
571,
569,0
592,0
599,1000
560,3
pRegion
pYear
pMonth
561,3
2
2
2
590,3
pRegion,"Scandinavia"
pYear,"2012"
pMonth,"Sep"
637,3
pRegion,"Region"
pYear,"Year"
pMonth,"Month"
577,12
vVersion
vYear
vMonth
vCurrency
vRegion
vDepartment
vAccount
vPeriod
Value
NVALUE
SVALUE
VALUE_IS_STRING
578,12
2
2
2
2
2
2
2
2
1
1
2
1
579,12
1
2
8
4
5
6
7
3
9
0
0
0
580,12
0
0
0
0
0
0
0
0
0
0
0
0
581,12
0
0
0
0
0
0
0
0
0
0
0
0
582,9
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
603,0
572,24

#****Begin: Generated Statements***
#****End: Generated Statements****

DatasourceASCIIQuoteCharacter = '';
DatasourceASCIIDelimiter = Char(9);

sFileName = 'C:\TM1\Tools\' | pRegion | '.txt';
sCubeName = 'General Ledger';
sViewName = '}Export';
sFilter = 'Year: ' | pYear | ' & Period: ' | pMonth | ' & Version: Actual';
sFilter = sFilter | ' & Region: ' | pRegion;
sFilter = sFilter | ' & Department: Executive General and Administration + Inventory Management + Manufacturing + Quality Assurance + Research and Development + Sales and Marketing';
sFilter = sFilter | ' & Account: Operating Profit & Currency: Local & General Ledger Measure: Amount';

ExecuteProcess('Bedrock.Cube.View.Create', 'pCube', sCubeName, 'pView', sViewName, 'pFilter', sFilter, 'pSuppressConsol', 0, 'pSuppressRules', 0);


DataSourceType = 'VIEW';
DatasourceNameForServer = sCubeName;
DatasourceNameForClient = sCubeName;
DatasourceCubeView = sViewName;

i = 1;
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,16

#****Begin: Generated Statements***
#****End: Generated Statements****

If( i = 1);
  TEXTOUTPUT(sFileName, 'Items ->');
EndIf;

sOperatingExpenses = NumberToString(CellGetN(sCubeName, vVersion, vYear, vPeriod, vCurrency, vRegion, vDepartment, 'Operating Expenses', 'Amount'));
sTotalCostofSales = NumberToString(CellGetN(sCubeName, vVersion, vYear, vPeriod, vCurrency, vRegion, vDepartment, 'Total Cost of Sales', 'Amount'));
sNetSales = NumberToString(CellGetN(sCubeName, vVersion, vYear, vPeriod, vCurrency, vRegion, vDepartment, 'Net Sales', 'Amount'));
sGrossMargin = NumberToString(CellGetN(sCubeName, vVersion, vYear, vPeriod, vCurrency, vRegion, vDepartment, 'Gross Margin', 'Amount'));

TEXTOUTPUT(sFileName, ATTRS('Department', vDepartment, 'Description'), sOperatingExpenses, sTotalCostofSales, sNetSales, sGrossMargin, NumberToString(Value));

i = i + 1;
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
