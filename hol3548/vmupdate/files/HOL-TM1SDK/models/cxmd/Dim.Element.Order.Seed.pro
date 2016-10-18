601,100
602,"Dim.Element.Order.Seed"
562,"SUBSET"
586,"Account"
585,"Account"
564,
565,"opwJqHWMKLTWsyka2wcm1vya[120V5Oh>X_wkrwE1c48V:=\aM2A`M`h[4xc>[]Y2<p:B=[_iY^\]m:L0QMWY9R8I7\Fp[U^LtQM<0ZLF<lhx=\]Hu7Iu5PhZtc9\\wVvO\2s1HPzHhuf1V<ju3EhS^xI85t@\_QbELTlWiy5]KLoLAO_LCJy:6;KVY]r]qNm?eQ34^7"
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
570,
571,Default
569,0
592,0
599,1000
560,2
pDimName
pNAlpha
561,2
2
1
590,2
pDimName,"Account Test"
pNAlpha,1
637,2
pDimName,Dimension Name
pNAlpha,Sort N elements in alpha order
577,1
v1
578,1
2
579,1
1
580,1
0
581,1
0
582,1
VarType=32ColType=827
603,0
572,22

#****Begin: Generated Statements***
#****End: Generated Statements****

pNAlpha = 1;
sAttribute = 'Order Seed';
sSubName = 'HSort';
If( SubsetExists( pDimName, sSubName) = 1);
  SubsetDestroy( pDimName, sSubName);
EndIf;
SubsetCreateByMDX( sSubName, '{ HIERARCHIZE( {TM1SUBSETALL( [' | pDimName | '] )} ) }');


AttrInsert(pDimName, '', sAttribute, 'N');
AttrInsert(pDimName, '', 'Order Adj', 'N');

DatasourceNameForServer = pDimName;
DatasourceNameForClient = pDimName;
DataSourceType = 'SUBSET';
DatasourceDimensionSubset = sSubName;

n = 1;
573,17

#****Begin: Generated Statements***
#****End: Generated Statements****


sN = NumberToString(n);

nVal = StringToNumber(sN | '000');

AttrPutN(nVal, pDimName, v1, sAttribute);

n = n +1;





574,19

#****Begin: Generated Statements***
#****End: Generated Statements****


nSeed = ATTRN(pDimName, v1,  'Order Seed');
nAdj = ATTRN(pDimName, v1,  'Order Adj');

nVal = nSeed + nAdj;
sVal = '00000000000' | NumberToString(nVal);
sVal = SUBST(sVal, LONG(sVal) - 11, 12);
if( pNAlpha = 1 & DTYPE(pDimName, v1) @<> 'C');
  sVal = '100000000000';
EndIf;


AttrPutS(sVal, pDimName, v1, 'Order');


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
