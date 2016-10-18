601,100
562,"ODBC"
586,"AdventureWorksDW 64"
585,"AdventureWorksDW 64"
564,"user"
565,"iD96i^\Z3eN2F^\:KiGL_MGszO6?\kt7>]6kX>zQ__EVddQhgoI3pB0Bgcy[6\cXbM4{cSJBwgh6`<4\bC:W\aE9zRD;q5TdaWZ^?vmdN=NvVet3LCC5YoC8TGO@3:TJ]z^\O_?k?h>b3IF7PSWvKDmU]WKTvqYQsrByawgge6a4\B_w:=xqCBt_ra59@z?y@m5dGbIl"
559,0
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
Select
  DimProduct.ProductKey, DimProduct.EnglishProductName, DimProduct.Class,
  DimProduct.Style, DimProduct.ModelName,
  DimProductSubcategory.EnglishProductSubcategoryName,
  DimProductCategory.EnglishProductCategoryName,
  DimProduct.WeightUnitMeasureCode, DimProduct.SizeUnitMeasureCode,
  DimProduct.SpanishProductName, DimProduct.FrenchProductName,
  DimProduct.StandardCost, DimProduct.Color, DimProduct.SafetyStockLevel,
  DimProduct.ReorderPoint, DimProduct.Weight, DimProduct.DaysToManufacture,
  DimProduct.ProductLine, DimProduct.DealerPrice, DimProduct.StartDate,
  DimProduct.Status, DimProduct.ListPrice, DimProduct.Size ,DimProduct.SizeRange
From DimProduct Inner Join
  DimProductSubcategory On DimProduct.ProductSubcategoryKey =
  DimProductSubcategory.ProductSubcategoryKey Inner Join
  DimProductCategory On DimProductSubcategory.ProductCategoryKey =
  DimProductCategory.ProductCategoryKey
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
577,24
vProductKey
EnglishProductName
Class
Style
ModelName
EnglishProductSubcategoryName
EnglishProductCategoryName
WeightUnitMeasureCode
SizeUnitMeasureCode
SpanishProductName
FrenchProductName
StandardCost
Color
SafetyStockLevel
ReorderPoint
Weight
DaysToManufacture
ProductLine
DealerPrice
StartDate
Status
ListPrice
Size
SizeRange
578,24
1
2
2
2
2
2
2
2
2
2
2
1
2
1
1
1
1
2
2
2
2
1
2
2
579,24
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
580,24
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
581,24
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
582,24
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
572,15

#****Begin: Generated Statements***
#****End: Generated Statements****

sCubeName = 'Product';
CubeClearData( sCubeName );


cCurrency = 'Local';
cRegion = '3';
cVersion = 'Actual';
cYear = '2012';


# Test
573,4

#****Begin: Generated Statements***
#****End: Generated Statements****

574,9

#****Begin: Generated Statements***
#****End: Generated Statements****

sProduct = NumberToString(vProductKey);

CellPutN(StandardCost, sCubeName, cVersion, cYear, cCurrency, cRegion, sProduct,'Standard Cost');
CellPutN(ListPrice, sCubeName, cVersion, cYear, cCurrency, cRegion, sProduct, 'List Price');

575,4

#****Begin: Generated Statements***
#****End: Generated Statements****

576,CubeAction=1511DataAction=1503CubeLogChanges=0
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
