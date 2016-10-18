601,100
602,"Cube.Wholesale.LoadFromFile"
562,"CHARACTERDELIMITED"
586,"C:\TM1data\cxmd\Data\Wholesale.csv"
585,"C:\TM1data\cxmd\Data\Wholesale.csv"
564,"user"
565,"c=NeRV;1gsa8QmSV>nO>pZ2bECw4@u\uX1`jW`j=3Rp]hbAop6nO@0zLEzZmGbghy04|cQHEiYpn:AwZ4FJ^Lo@MxQ>lwP175z2B`cx`cirF<b~SZ=bn2fDPHLji@5dbh:nv5CSV[=TeYh_\m5t0lsFtRenG;NbZF:CDqXA=f`FwtGYzEkhm8s5a9fFfHfDv0\pYiofS"
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
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=33ColType=827
603,0
572,12

#****Begin: Generated Statements***
#****End: Generated Statements****

cCubeName = 'Wholesale';
cVersion = 'Actual';
cCurrency = 'Local';

#ExecuteProcess('Bedrock.Cube.Data.ZeroOut', 'pCube', cCubeName);

DatasourceNameForServer = 'Wholesale.csv';
DatasourceNameForClient = 'Wholesale.csv';
573,9

#****Begin: Generated Statements***
#****End: Generated Statements****

#sDim = 'Employee';
#IF(DIMIX(sDim, vEmployeeKey)= 0);
#  DimensionElementInsert(sDim,'',vEmployeeKey,'N');
#  DimensionElementComponentAdd(sDim, 'Wholesale', vEmployeeKey, 1);
#ENDIF;
574,69

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


#### WRITE TO CUBE


sMeasure = 'Sales Amount';
nNumber = vSalesAmount;

IF(cVersion@='Budget');
      nNumber=nNumber+nNumber*RAND/5;
ENDIF;

If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure);
EndIf;

sMeasure = 'Freight';
nNumber = vFreight;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure);
EndIf;

sMeasure = 'Cost';
nNumber = vProductStandardCost;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure);
EndIf;

sMeasure = 'Discount Amount';
nNumber = vDiscountAmount;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure);
EndIf;

sMeasure = 'Discount Amount';
nNumber = vDiscountAmount;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure);
EndIf;

sMeasure = 'Qty';
nNumber = vOrderQuantity;
If(CellIsUpdateable(cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure)= 1);
  CellPutN(nNumber, cCubeName, cVersion, sYear, sPeriod, cCurrency, vEmployeeKey, vSalesTerritoryKey, vResellerKey, vProductKey, sMeasure);

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
