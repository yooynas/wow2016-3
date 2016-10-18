601,100
602,"Sys.DimUpdate"
562,"CHARACTERDELIMITED"
586,"C:\TM1\flightstats\Drop\aircraft.csv"
585,"C:\TM1\flightstats\Drop\aircraft.csv"
564,
565,"q]Gi\F<1Fn8VmCJ^<apXHeNW:baJyO?\suincOV1VnBYVtNbI>x@4pdq3tlbF\fJ^8aTJ_OmT^uLgCZ<FWQpa:OPs1<;M7@`Evno0Y[_6]03Jx[If@kQ6k5Lt[0Kd7Hj:Nj3nF]ec0O`Pis1ErN>i`Z72WfSHzmGXs[dcKIVic]LX^jw[[a>A?;Db[ePTRmTTgC<:bVH"
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
589,","
568,""""
570,
571,
569,0
592,0
599,1000
560,1
pDimName
561,1
2
590,1
pDimName,""
637,1
pDimName,Dimension Name
577,6
V1
V2
V3
V4
V5
V6
578,6
2
2
2
2
2
2
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
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
931,1
0,0,0,0,0,0,
603,0
572,7

#****Begin: Generated Statements***
#****End: Generated Statements****


DatasourceNameForServer = '..\Drop\' | pDimName | '.csv';
DatasourceNameForClient = '..\Drop\' |  pDimName | '.csv';
573,26

#****Begin: Generated Statements***
#****End: Generated Statements****



If( V1 @= 'Attribute' );
    If( V2 @= 'Insert' );
        AttrInsert ( pDimName, '', V3, V4 );
    ElseIf ( V2 @= 'Delete' );
        AttrDelete ( pDimName, V3 );
    EndIf;
ElseIf ( V1 @= 'Element' );
    If( V2 @= 'Add' );
        DimensionElementInsert( pDimName, '', V3, V4 );
    ElseIf ( V2 @= 'Delete' );
        DimensionElementDelete( pDimName, V3 );
    EndIf;
ElseIf ( V1 @= 'Component' );
    If( V2 @= 'Add' );
        DimensionElementComponentAdd( pDimName, V4, V3, StringToNumber(V5) );
    ElseIf ( V2 @= 'Delete' );
        DimensionElementComponentDelete( pDimName, V4, V3 );
    EndIf;
EndIf;

574,17

#****Begin: Generated Statements***
#****End: Generated Statements****


If( V1 @= 'Attribute' );
    If( V2 @= 'PutS' );
        AttrPutS ( V5, pDimName, V3, V4 );
    ElseIf ( V2 @= 'PutN' );
        AttrPutN ( StringToNumber( V5 ), pDimName, V3, V4 );
    EndIf;
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
