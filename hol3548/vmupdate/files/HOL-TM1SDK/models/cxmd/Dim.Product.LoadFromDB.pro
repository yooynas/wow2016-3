601,100
562,"ODBC"
586,"AdventureWorksDW 64"
585,"AdventureWorksDW 64"
564,"sa"
565,"d=wsaP?rhiT3_MJ6<IeN0n0_Er88luLfs;iyAGlRL:wo9p<Sqo\6G:nCNK8nDxS_Y3u:8a5@ITMxnJTty=PzQeF0ETwdjPrjC2TP=97_BYzFjemwEinEGG[Md4BSPcT<=5XsFGlZj2g3vTrtFPCMf>DcfxPBY:;y_;uVW[abZ_s6DUesyK`87bZavph<>2>9v?I]e^JE"
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
566,19
Select DimProduct.ProductKey, DimProduct.EnglishProductName, DimProduct.Class,
  DimProduct.Style, DimProduct.ModelName,
  DimProductSubcategory.EnglishProductSubcategoryName,
  DimProductCategory.EnglishProductCategoryName,
  DimProduct.WeightUnitMeasureCode, DimProduct.SizeUnitMeasureCode,
  DimProduct.SpanishProductName, DimProduct.FrenchProductName,
  DimProduct.StandardCost, DimProduct.Color, DimProduct.SafetyStockLevel,
  DimProduct.ReorderPoint, DimProduct.Weight, DimProduct.DaysToManufacture,
  DimProduct.ProductLine, DimProduct.DealerPrice, DimProduct.StartDate,
  DimProduct.Status, DimProduct.ListPrice, DimProduct.Size,
  DimProduct.SizeRange, DimProductSubcategory.SpanishProductSubcategoryName,
  DimProductSubcategory.FrenchProductSubcategoryName,
  DimProductCategory.SpanishProductCategoryName,
  DimProductCategory.FrenchProductCategoryName
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
577,28
vProductkey
vEnglishproductname
vClass
vStyle
vModelname
vEnglishproductsubcategoryname
vEnglishproductcategoryname
vWeightunitmeasurecode
vSizeunitmeasurecode
vSpanishproductname
vFrenchproductname
vStandardcost
vColor
vSafetystocklevel
vReorderpoint
vWeight
vDaystomanufacture
vProductline
vDealerprice
vStartdate
vStatus
vListprice
vSize
vSizerange
vSpanishproductsubcategoryname
vFrenchproductsubcategoryname
vSpanishproductcategoryname
vFrenchproductcategoryname
578,28
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
2
2
1
1
1
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
2
579,28
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
25
26
27
28
580,28
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
0
0
0
0
581,28
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
0
0
0
0
582,28
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
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
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
VarType=32ColType=827
572,60

#****Begin: Generated Statements***
#****End: Generated Statements****

## This Process builds the Product Dimension and its consolidations from SQL DW ##

## CONSTANTS ##
cDimName = 'Product';
cTopNode1 = 'All Products by Category';
cTopNode2 = 'All Products';

## Create Dimension if it does not exist ##
If ( DimensionExists (cDimName ) = 0 ) ;
  DimensionCreate(cDimName);
ENDIF;

DimensionSortOrder(cDimName,'ByName','Ascending','ByHierarchy','Ascending');


## Insert Top Node of Consolidations ##
DimensionElementInsert(cDimName,'',cTopNode1,'C');
DimensionElementInsert(cDimName,'',cTopNode2,'C');

## Unwind Dimension ##
# Iterate through dimensions and for each consolidated element, disconnect its components
nElementCount = DIMSIZ ( cDimName );
iCount = 1;

WHILE ( iCount <= nElementCount );
  sElement = DIMNM ( cDimName, iCount );
  IF ( DTYPE ( cDimName, sElement ) @= 'C' );
    nChildren = ELCOMPN ( cDimName, sElement );
    iChild = nChildren;
    WHILE ( iChild > 0 );
      sChild = ELCOMP ( cDimName, sElement, iChild );
      DimensionElementComponentDelete ( cDimName, sElement, sChild );
      iChild = iChild - 1;
    END;
  ENDIF;
  iCount = iCount + 1;
END;






## Insert Attributes ##
cAttr1 = 'Code&Description';
cAttr2 = 'French Description';
cattr3 = 'Spanish Description';

AttrInsert(cDimName,'',cAttr1,'A');
AttrInsert(cDimName,'',cAttr2,'A');
AttrInsert(cDimName,'',cAttr3,'A');





573,37

#****Begin: Generated Statements***
#****End: Generated Statements****

## CLEAN METADATA ##
sProduct = NumberToString(vProductKey);
sSubCategory = Trim(vEnglishproductsubcategoryname);
sCategory = Trim(vEnglishproductcategoryname);


#### Consolidation 1 ####
## Insert N Level elements ##
DimensionElementInsert(cDimName,'',sProduct,'N');

## Insert Sub-Category ##
DimensionElementInsert(cDimName,'',sSubCategory,'C');

## Insert Category ##
DimensionElementInsert(cDimName,'',sCategory,'C');

## Assign Parent Child Relationship ##
DimensionElementComponentAdd(cDimName,sSubCategory,sProduct,1);
DimensionElementComponentAdd(cDimName,sCategory,sSubCategory,1);
DimensionElementComponentAdd(cDimName,cTopNode1,sCategory,1);

## Consolidation 2 ##
DimensionElementComponentAdd(cDimName,cTopNode2,sProduct,1);










574,45

#****Begin: Generated Statements***
#****End: Generated Statements****


## CLEAN METADATA ##
sProduct = NumberToString(vProductKey);
sSubCategory = Trim(vEnglishproductsubcategoryname);
sCategory = Trim(vEnglishproductcategoryname);
sProdDesc = Trim(vEnglishproductname);

## Insert Attributes ##

# 1. Product alias #
cAttr = 'Code&Description';
sValue = sProduct | ' - '  | sProdDesc ;
AttrPutS(sValue,cDimName,sProduct,cAttr);

# 2. French Description
cAttr = 'French Description';
sValue = sProduct | ' ' | vFrenchproductname;
AttrPutS(sValue,cDimName,sProduct,cAttr);

cAttr = 'French Description';
sValue = sSubCategory | ' ' | vFrenchproductsubcategoryname;
AttrPutS(sValue,cDimName,sSubCategory,cAttr);

cAttr = 'French Description';
sValue = sCategory | ' ' | vFrenchproductcategoryname;
AttrPutS(sValue,cDimName,sCategory,cAttr);

# 3. Spanish Description
cAttr = 'Spanish Description';
sValue = sProduct | ' ' | vSpanishproductname;
AttrPutS(sValue,cDimName,sProduct,cAttr);

cAttr = 'Spanish Description';
sValue = sSubCategory | ' ' | vSpanishproductsubcategoryname;
AttrPutS(sValue,cDimName,sSubCategory,cAttr);

cAttr = 'Spanish Description';
sValue = sCategory | ' ' | vSpanishproductcategoryname;
AttrPutS(sValue,cDimName,sCategory,cAttr);


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
