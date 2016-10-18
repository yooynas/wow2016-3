601,100
602,"Dim - Sales Territory"
562,"ODBC"
586,"Adventure Works x64"
585,"Adventure Works x64"
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
566,1
select * from dimSalesTerritory
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
SalesTerritoryRegion
SalesTerritoryCountry
SalesTerritoryGroup
578,3
2
2
2
579,3
3
4
5
580,3
0
0
0
581,3
0
0
0
582,5
IgnoredInputVarName=SalesTerritoryKeyVarType=33ColType=1165
IgnoredInputVarName=SalesTerritoryAlternateKeyVarType=33ColType=1165
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
931,1
0,0,0,0,0,
603,0
572,15

#****Begin: Generated Statements***
#****End: Generated Statements****

vDimName = 'Sales Territory';

#DimensionCreate(vDimName);

AttrInsert(vDimName, '', 'Sales Territory Country', 'S');

AttrInsert(vDimName, '', 'Sales Territory Group', 'S');

DimensionSortOrder (vDimName, 'ByName', 'Ascending', 'ByLevel', 'Ascending');

DimensionElementInsert(vDimName, '', 'Total Sales Territory', 'S');
573,16

#****Begin: Generated Statements***
#****End: Generated Statements****

DimensionElementComponentAdd(vDimName, 'Total Sales Territory', SalesTerritoryGroup, 1);

IF (SalesTerritoryGroup@<>SalesTerritoryCountry);
   DimensionElementComponentAdd(vDimName, SalesTerritoryGroup, SalesTerritoryCountry, 1);
ENDIF;

IF (SalesTerritoryCountry@<>SalesTerritoryRegion);
   DimensionElementComponentAdd(vDimName, SalesTerritoryCountry, SalesTerritoryRegion, 1);
ENDIF;



574,7

#****Begin: Generated Statements***
#****End: Generated Statements****

AttrPutS(SalesTerritoryCountry, vDimName, SalesTerritoryRegion, 'Sales Territory Country');

AttrPutS(SalesTerritoryGroup, vDimName, SalesTerritoryRegion, 'Sales Territory Group');
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
