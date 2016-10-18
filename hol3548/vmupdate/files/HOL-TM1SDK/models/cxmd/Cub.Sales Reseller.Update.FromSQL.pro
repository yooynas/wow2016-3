601,100
602,"Cub.Sales Reseller.Update.FromSQL"
562,"ODBC"
586,"AdventureWorksDW 64"
585,"AdventureWorksDW 64"
564,
565,"nYJ\E2T\8OHOkEazFBpsa@Np_kUwJwLQ@tBr83BrHCHvjnj1[5Q2Q2<3EP]fzXTKSrU`NF=HB>b?9TrH^lFet7hiZtkktQ71FH3gwO`KB\69ZS9uW?wAA:fOH;=e9VPLYBt0gCVVumrMTi?Sau_oV?ylaq:0A<qYuKnYZr]LzVNAVa9PHZr2m<>syVenibM6o[7^pN;b"
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
566,24
Select FactResellerSales.OrderQuantity, FactResellerSales.DiscountAmount,
  FactResellerSales.TotalProductCost, FactResellerSales.SalesAmount,
  FactResellerSales.TaxAmt, FactResellerSales.Freight,
  DimSalesTerritory.SalesTerritoryRegion, FactResellerSales.OrderDateKey,
  DimDate.FiscalYear, DimDate.EnglishMonthName, FactResellerSales.UnitPrice,
  DimDate.DayNumberOfMonth, DimCurrency.CurrencyName,
  DimReseller.ResellerName,
  DimPromotion.EnglishPromotionName, DimProduct.EnglishProductName,
  DimProduct.ProductKey, FactResellerSales.ExtendedAmount,
  FactResellerSales.UnitPriceDiscountPct, FactResellerSales.ProductStandardCost,
  FactResellerSales.SalesOrderNumber
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
  DimProduct On FactResellerSales.ProductKey = DimProduct.ProductKey
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
577,21
vOrderquantity
vDiscountamount
vTotalproductcost
vSalesamount
vTaxamt
vFreight
vSalesterritoryregion
vOrderdatekey
vFiscalyear
vEnglishmonthname
vUnitprice
vDaynumberofmonth
vCurrencyname
vResellername
vEnglishpromotionname
vEnglishproductname
vProductkey
vExtendedamount
vUnitpricediscountpct
vProductstandardcost
vSalesordernumber
578,21
1
1
2
2
2
2
2
1
1
2
2
1
2
2
2
2
1
2
1
2
2
579,21
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
580,21
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
581,21
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
582,21
VarType=33ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
931,1
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
603,0
572,20

#****Begin: Generated Statements***
#****End: Generated Statements****


## This Process Uploads Sales Dats into the 'Sales Reseller' cube ##
cCubeName = 'Sales Reseller';
cVersion = 'Actual';
cCurrency = 'Local';




## Clear all Data from the Cube Prior to Uploading ##
## This function only works on TM1 Version 9.4 and above ##

CubeClearData( cCubeName );



573,4

#****Begin: Generated Statements***
#****End: Generated Statements****

574,54

#****Begin: Generated Statements***
#****End: Generated Statements****


## CLEAN SOURCE VARIABLES ###

sYear = NumberToString(vFiscalYear);
nCost = NUMBR(vTotalproductcost);
nSalesAmt = NUMBR(vSalesamount);
nTax = NUMBR(vTaxamt);
nFreight = NUMBR(vFreight);
sMonth = vEnglishmonthname;
sProduct = NumberToString(vProductKey);


## Upload Data into Sales Cube ##
sMeasure = 'Qty';
nValueGet = CellGetN(cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;
CellPutN ( vOrderquantity + nValueGet , cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;

sMeasure = 'Sales Amount';
nValueGet = CellGetN(cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;
CellPutN ( nSalesAmt + nValueGet , cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;

sMeasure = 'Cost';
nValueGet = CellGetN(cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;
CellPutN ( nCost + nValueGet , cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;

sMeasure = 'Tax Amount';
nValueGet = CellGetN(cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;
CellPutN ( nTax + nValueGet , cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;

sMeasure = 'Freight';
nValueGet = CellGetN(cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;
CellPutN ( nFreight + nValueGet , cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;

sMeasure = 'Discount Amount';
nValueGet = CellGetN(cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;
CellPutN ( vDiscountamount + nValueGet , cCubeName,cVersion,sYear,sMonth,cCurrency,vSalesterritoryregion,
  vResellername,vEnglishpromotionname,sProduct,sMeasure ) ;


575,4

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
