601,100
562,"ODBC"
586,"AdventureWorksDW 64"
585,"AdventureWorksDW 64"
564,
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
566,8
Select DimPromotion.EnglishPromotionName, DimPromotion.SpanishPromotionName,
  DimPromotion.FrenchPromotionName, DimPromotion.DiscountPct,
  DimPromotion.EnglishPromotionType, DimPromotion.SpanishPromotionType,
  DimPromotion.FrenchPromotionType, DimPromotion.EnglishPromotionCategory,
  DimPromotion.SpanishPromotionCategory, DimPromotion.FrenchPromotionCategory,
  DimPromotion.StartDate, DimPromotion.EndDate, DimPromotion.MinQty,
  DimPromotion.MaxQty
From DimPromotion
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
577,14
vEnglishpromotionname
vSpanishpromotionname
vFrenchpromotionname
vDiscountpct
vEnglishpromotiontype
vSpanishpromotiontype
vFrenchpromotiontype
vEnglishpromotioncategory
vSpanishpromotioncategory
vFrenchpromotioncategory
vStartdate
vEnddate
vMinqty
vMaxqty
578,14
2
2
2
1
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
579,14
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
580,14
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
581,14
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
582,14
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
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
572,60

#****Begin: Generated Statements***
#****End: Generated Statements****

### This Process Builds the Reseller Dimension ###

## CONSTANTS ##
cDimName = 'Promotion';
cTopNode1 = 'All Promotions By Category';


## Create Dimension if it does not exist ##
If ( DimensionExists (cDimName ) = 0 ) ;
  DimensionCreate(cDimName);
ENDIF;

DimensionSortOrder(cDimName,'ByName','Ascending','ByHierarchy','Ascending');


## Insert Top Node of Consolidations ##
DimensionElementInsert(cDimName,'',cTopNode1,'C');

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
cAttr1 = 'Discount Pct';
cAttr2 = 'French Description';
cAttr3 = 'Spanish Description';
cAttr4 = 'Start Date';
cAttr5 = 'End Date';
cAttr6 = 'Min Qty';
cAttr7 = 'Max Qty';



AttrInsert(cDimName,'',cAttr1,'N');
AttrInsert(cDimName,'',cAttr2,'A');
AttrInsert(cDimName,'',cAttr3,'A');
AttrInsert(cDimName,'',cAttr4,'S');
AttrInsert(cDimName,'',cAttr5,'S');
AttrInsert(cDimName,'',cAttr6,'N');
AttrInsert(cDimName,'',cAttr7,'N');
573,26

#****Begin: Generated Statements***
#****End: Generated Statements****

## CLEAN METADATA ##
sPromo = Trim(vEnglishpromotionname);
sPromoType = Trim(vEnglishpromotiontype);
sPromoCat = Trim(vEnglishpromotioncategory);

## Insert N Level elements ##
DimensionElementInsert(cDimName,'',sPromo,'N');

# Roll the 'No Discount' Promotion directly into the Top Node #
If ( sPromo @= 'No Discount'  );
  DimensionElementComponentAdd(cDimName,cTopNode1 , sPromoCat , 1  );
ELSE;
  ## Insert C Level elements ##
  DimensionElementInsert(cDimName,'',sPromotype,'C');
  DimensionElementInsert(cDimName,'',sPromoCat,'C');

  ## Assign Parent Child Relationship ##
  DimensionElementComponentAdd(cDimName,sPromoType , sPromo , 1  );
  DimensionElementComponentAdd(cDimName,sPromoCat , sPromoType , 1  );
  DimensionElementComponentAdd(cDimName,cTopNode1 , sPromoCat , 1  );
  
ENDIF;
574,58

#****Begin: Generated Statements***
#****End: Generated Statements****

## CLEAN METADATA ##
sPromo = Trim(vEnglishpromotionname);
sPromoType = Trim(vEnglishpromotiontype);
sPromoCat = Trim(vEnglishpromotioncategory);

## Insert Attributes ##

# 1. French Alias #
cAttr = 'French Description';
sValue = Trim(vFrenchpromotionname)  ;
AttrPutS(sValue,cDimName,sPromo,cAttr);

cAttr = 'French Description';
sValue = Trim(vFrenchpromotiontype)  ;
AttrPutS(sValue,cDimName,sPromotype,cAttr);

cAttr = 'French Description';
sValue = Trim(vFrenchpromotioncategory)  ;
AttrPutS(sValue,cDimName,sPromoCat,cAttr);

# 2. Spanish Alias #
cAttr = 'Spanish Description';
sValue = Trim(vSpanishpromotionname)  ;
AttrPutS(sValue,cDimName,sPromo,cAttr);

cAttr = 'Spanish Description';
sValue = Trim(vSpanishpromotiontype)  ;
AttrPutS(sValue,cDimName,sPromotype,cAttr);

cAttr = 'Spanish Description';
sValue = Trim(vSpanishpromotioncategory)  ;
AttrPutS(sValue,cDimName,sPromoCat,cAttr);

# 3. Other Attributes #
cAttr = 'Discount Pct';
nValue =  vDiscountpct ;
AttrPutN(nValue,cDimName,sPromo,cAttr);

cAttr = 'Start Date';
sValue = vStartdate  ;
AttrPutS(sValue,cDimName,sPromo,cAttr);

cAttr = 'End Date';
sValue = vEnddate  ;
AttrPutS(sValue,cDimName,sPromo,cAttr);

cAttr = 'Min Qty';
nValue = vMinQty  ;
AttrPutN(nValue,cDimName,sPromo,cAttr);

cAttr = 'Max Qty';
nValue = vMaxQty  ;
AttrPutN(nValue,cDimName,sPromo,cAttr);

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
