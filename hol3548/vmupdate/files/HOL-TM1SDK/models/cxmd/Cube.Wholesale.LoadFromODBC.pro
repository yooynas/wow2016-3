601,100
602,"Cube.Wholesale.LoadFromODBC"
562,"ODBC"
586,"AdventureWorksDW 64"
585,"AdventureWorksDW 64"
564,"user"
565,"nYJ\E2T\8OHOkEezFBpsa@Np_kUwJwLQ@tBr83BrHCHvjna1[5Q2Q2<3EP]fzXTKSrUpCF=HB>b?9TrH^lFet7hiZtkktQ71FH3gwO`KB\69ZSysW?wAA:fOH;=e9VPLYBt0gCVVumrMTi?Sau_oV?ylaq:0A<qYuKnYZr]LzVNAVa9PHZr2m<>syVenibMv`[7^pN;b"
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
Select FactResellerSales.*, DimDate.*
From FactResellerSales Inner Join
  DimSalesTerritory On FactResellerSales.SalesTerritoryKey =
    DimSalesTerritory.SalesTerritoryKey Left Join
  DimDate On FactResellerSales.OrderDateKey = DimDate.DateKey Left Join
  DimCurrency On FactResellerSales.CurrencyKey = DimCurrency.CurrencyKey
  Left Join
  DimSalesTerritory DimSalesTerritory1 On FactResellerSales.SalesTerritoryKey =
    DimSalesTerritory1.SalesTerritoryKey Left Join
  DimReseller On FactResellerSales.ResellerKey = DimReseller.ResellerKey
  Left Join
  DimPromotion On FactResellerSales.PromotionKey = DimPromotion.PromotionKey
  Left Join
  DimProduct On FactResellerSales.ProductKey = DimProduct.ProductKey Left Join
  DimEmployee On FactResellerSales.EmployeeKey = DimEmployee.EmployeeKey
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
577,33
vProductKey
vOrderDateKey
vDueDateKey
vShipDateKey
vResellerKey
vEmployeeKey
vPromotionKey
vCurrencyKey
vSalesTerritoryKey
vSalesOrderNumber
vSalesOrderLineNumber
vRevisionNumber
vOrderQuantity
vUnitPrice
vExtendedAmount
vUnitPriceDiscountPct
vDiscountAmount
vProductStandardCost
vTotalProductCost
vSalesAmount
vTaxAmt
vFreight
vCarrierTrackingNumber
vCustomerPONumber
vDateKey
vFullDateAlternateKey
vDayNumberOfMonth
vDayNumberOfYear
vEnglishMonthName
vSpanishMonthName
vFrenchMonthName
vMonthNumberOfYear
vCalendarYear
578,33
2
2
1
1
2
2
1
1
2
2
1
1
1
1
1
1
1
1
1
1
1
1
2
2
1
2
1
1
2
2
2
1
1
579,33
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
29
30
31
32
33
580,33
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
0
0
0
0
0
581,33
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
0
0
0
0
0
582,33
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=33€ColType=827€
VarType=32€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
931,1
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
603,0
572,8

#****Begin: Generated Statements***
#****End: Generated Statements****

cCubeName = 'Wholesale';
cVersion = 'Actual';
cCurrency = 'Local';
CubeClearData( cCubeName );
573,16

#****Begin: Generated Statements***
#****End: Generated Statements****

# Remove dot from end of Employee
nProductLength = LONG(vEmployeeKey);
sLastCharacter = SUBST(vEmployeeKey, nProductLength, 1);
If(sLastCharacter @= '.');
  sEmployeeKey = SUBST(vEmployeeKey, 1, nProductLength - 1);
EndIf;

sDim = 'Employee';
IF(DIMIX(sDim, sEmployeeKey)= 0);
  DimensionElementInsert(sDim,'',sEmployeeKey,'N');
  DimensionElementComponentAdd(sDim, 'Wholesale', sEmployeeKey, 1);
ENDIF;
574,93

#****Begin: Generated Statements***
#****End: Generated Statements****

#Version
#Year
#Period
#Currency
#Employee
#Sales Territory
#Reseller
#Promotion
#Product
#Sales Measure

sYear = subst(vOrderDateKey,1,4);

#sPeriod = subst(vOrderDateKey,5,2);
#sPeriod = NumberToString(vMonthNumberOfYear);
sPeriod = NumberToString(INT(RAND * 12) + 1);


# Remove dot from end of Employee
nLength = LONG(vEmployeeKey);
sLastCharacter = SUBST(vEmployeeKey, nLength, 1);
If(sLastCharacter @= '.');
  sEmployeeKey = SUBST(vEmployeeKey, 1, nLength - 1);
EndIf;

# Remove dot from end of Sales Territory
nLength = LONG(vSalesTerritoryKey);
sLastCharacter = SUBST(vSalesTerritoryKey, nLength, 1);
If(sLastCharacter @= '.');
  sRegion = SUBST(vSalesTerritoryKey, 1, nLength - 1);
EndIf;

# Remove dot from end of Reseller
sString = vResellerKey;
nLength = LONG(sString);
sLastCharacter = SUBST(sString, nLength, 1);
If(sLastCharacter @= '.');
  sString = SUBST(sString, 1, nLength - 1);
EndIf;
sResellerKey = sString;

# Remove dot from end of product
sString = vProductKey;
nLength = LONG(sString);
sLastCharacter = SUBST(sString, nLength, 1);
If(sLastCharacter @= '.');
  sString = SUBST(sString, 1, nLength - 1);
EndIf;
sProductKey = sString;

#### WRITE TO CUBE

sMeasure = 'Sales Amount';
nNumber = vSalesAmount;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure);
EndIf;

sMeasure = 'Freight';
nNumber = vFreight;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure);
EndIf;

sMeasure = 'Cost';
nNumber = vProductStandardCost;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure);
EndIf;

sMeasure = 'Discount Amount';
nNumber = vDiscountAmount;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure);
EndIf;

sMeasure = 'Discount Amount';
nNumber = vDiscountAmount;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure);
EndIf;

sMeasure = 'Qty';
nNumber = vOrderQuantity;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, sEmployeeKey, sRegion, sResellerKey, sProductKey, sMeasure);
EndIf;


575,3

#****Begin: Generated Statements***
#****End: Generated Statements****
576,CubeAction=1511€DataAction=1503€CubeLogChanges=0€
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
