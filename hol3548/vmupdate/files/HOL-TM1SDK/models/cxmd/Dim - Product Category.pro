601,100
602,"Dim - Product Category"
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
select * from dimProductSubCategory
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
577,6
ProductSubcategoryKey
ProductSubcategoryAlternateKey
EnglishProductSubcategoryName
SpanishProductSubcategoryName
FrenchProductSubcategoryName
ProductCategoryKey
578,6
1
1
2
2
2
1
579,6
1
2
3
4
5
6
580,6
0
0
0
0
0
0
581,6
0
0
0
0
0
0
582,6
VarType=33ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
931,1
0,0,0,0,0,0,
603,0
572,11

#****Begin: Generated Statements***
#****End: Generated Statements****

vDimName = 'Product Sub Category';

DimensionCreate(vDimName);

DimensionSortOrder (vDimName, 'ByName', 'Ascending', 'ByLevel', 'Ascending');

DimensionElementInsert(vDimName, '', 'Total Product Sub Categories', 'N');
573,6

#****Begin: Generated Statements***
#****End: Generated Statements****

DimensionElementComponentAdd(vDimName, 'Total Product Sub Categories', EnglishProductSubcategoryName, 1);

574,7

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
