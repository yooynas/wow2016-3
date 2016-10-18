601,100
602,"Sys.CubUpdate"
562,"CHARACTERDELIMITED"
586,"C:\TM1\flightstats\Drop\Source.txt  "
585,"C:\TM1\flightstats\Drop\Source.txt  "
564,
565,"n9x=0hy<E]a>1ha3vfEP;7[jKMwqHBnHkFhq3]hP5><OdFr[VQ37dow2;mLws243VEbdJ5v\GMY`_p<]AjRxSA:eXRU0^t8]aAT7vFL:w5EKtj`XUayGU4g_[vgR=JqDaNyY0w@?ZuJaK1N81fk=O;2OxmBnvv=d;wosi`dyqiiA2ydr7nnp1oLbRengliyP`^]=f7rH"
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
567,"	"
588,"."
589,","
568,""""
570,
571,
569,1
592,0
599,1000
560,1
pCubeName
561,1
2
590,1
pCubeName,""
637,1
pCubeName,"Cube Name"
577,30
V1
V2
V3
V4
V5
V6
V7
V8
V9
V10
V11
V12
V13
V14
V15
V16
V17
V18
V19
V20
V21
V22
V23
V24
V25
V26
V27
V28
V29
V30
578,30
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
2
2
2
2
2
2
579,30
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
580,30
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
581,30
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
582,30
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
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
931,1
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
603,0
572,15

#****Begin: Generated Statements***
#****End: Generated Statements****

DatasourceNameForServer = 'test\';
DatasourceNameForClient = 'test\';

nDimCount = 0;
While( TabDim( pCubeName, nDimCount + 1 ) @<> '' );
  nDimCount = nDimCount + 1;
End;


sMeasureDim = TabDim(  pCubeName, nDimCount );

573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,272

#****Begin: Generated Statements***
#****End: Generated Statements****

If( nDimCount = 2 );
    sType = DTYPE( sMeasureDim, V2 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V3), pCubeName, V1, V2);
    ElseIf ( sType @= 'S' );
        CellPutS(V3, pCubeName, V1, V2);
    EndIf;
EndIf;

If( nDimCount = 3 );
    sType = DTYPE( sMeasureDim, V3 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V4), pCubeName, V1, V2, V3);
    ElseIf ( sType @= 'S' );
        CellPutS(V4, pCubeName, V1, V2, V3);
    EndIf;
EndIf;

If( nDimCount = 4 );
    sType = DTYPE( sMeasureDim, V4 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V5), pCubeName, V1, V2, V3, V4);
    ElseIf ( sType @= 'S' );
        CellPutS(V5, pCubeName, V1, V2, V3, V4);
    EndIf;
EndIf;

If( nDimCount = 5 );
    sType = DTYPE( sMeasureDim, V5 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V6), pCubeName, V1, V2, V3, V4, V5);
    ElseIf ( sType @= 'S' );
        CellPutS(V6, pCubeName, V1, V2, V3, V4, V5);
    EndIf;
EndIf;

If( nDimCount = 6 );
    sType = DTYPE( sMeasureDim, V6 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V7), pCubeName, V1, V2, V3, V4, V5, V6);
    ElseIf ( sType @= 'S' );
        CellPutS(V7, pCubeName, V1, V2, V3, V4, V5, V6);
    EndIf;
EndIf;

If( nDimCount = 7 );
    sType = DTYPE( sMeasureDim, V7 );
    Textoutput('Test.txt', sType);
    If( sType @= 'N' );
         Textoutput('Test.txt', V8, pCubeName, V1, V2, V3, V4, V5, V6, V7);
        CellPutN(StringToNumber(V8), pCubeName, V1, V2, V3, V4, V5, V6, V7);
    ElseIf ( sType @= 'S' );
        CellPutS(V8, pCubeName, V1, V2, V3, V4, V5, V6, V7);
    EndIf;
EndIf;

If( nDimCount = 8 );
    sType = DTYPE( sMeasureDim, V8 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V9), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8);
    ElseIf ( sType @= 'S' );
        CellPutS(V9, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8);
    EndIf;
EndIf;

If( nDimCount = 9 );
    sType = DTYPE( sMeasureDim, V9 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V10), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9);
    ElseIf ( sType @= 'S' );
        CellPutS(V10, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9);
    EndIf;
EndIf;

If( nDimCount = 10 );
    sType = DTYPE( sMeasureDim, V10 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V11), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10);
    ElseIf ( sType @= 'S' );
        CellPutS(V11, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10);
    EndIf;
EndIf;

If( nDimCount = 11 );
    sType = DTYPE( sMeasureDim, V11 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V12), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11);
    ElseIf ( sType @= 'S' );
        CellPutS(V12, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11);
    EndIf;
EndIf;

If( nDimCount = 12 );
    sType = DTYPE( sMeasureDim, V12 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V13), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12);
    ElseIf ( sType @= 'S' );
        CellPutS(V13, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12);
    EndIf;
EndIf;

If( nDimCount = 13 );
    sType = DTYPE( sMeasureDim, V13 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V14), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13);
    ElseIf ( sType @= 'S' );
        CellPutS(V14, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13);
    EndIf;
EndIf;

If( nDimCount = 14 );
    sType = DTYPE( sMeasureDim, V14 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V15), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14);
    ElseIf ( sType @= 'S' );
        CellPutS(V15, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14);
    EndIf;
EndIf;

If( nDimCount = 15 );
    sType = DTYPE( sMeasureDim, V15 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V16), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15);
    ElseIf ( sType @= 'S' );
        CellPutS(V16, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15);
    EndIf;
EndIf;

If( nDimCount = 16 );
    sType = DTYPE( sMeasureDim, V16 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V17), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16);
    ElseIf ( sType @= 'S' );
        CellPutS(V17, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16);
    EndIf;
EndIf;

If( nDimCount = 17 );
    sType = DTYPE( sMeasureDim, V17 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V18), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17);
    ElseIf ( sType @= 'S' );
        CellPutS(V18, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17);
    EndIf;
EndIf;

If( nDimCount = 18 );
    sType = DTYPE( sMeasureDim, V18 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V19), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18);
    ElseIf ( sType @= 'S' );
        CellPutS(V19, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18);
    EndIf;
EndIf;

If( nDimCount = 19 );
    sType = DTYPE( sMeasureDim, V19 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V20), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19);
    ElseIf ( sType @= 'S' );
        CellPutS(V20, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19);
    EndIf;
EndIf;

If( nDimCount = 20 );
    sType = DTYPE( sMeasureDim, V20 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V21), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20);
    ElseIf ( sType @= 'S' );
        CellPutS(V21, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20);
    EndIf;
EndIf;

If( nDimCount = 21 );
    sType = DTYPE( sMeasureDim, V21 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V22), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21);
    ElseIf ( sType @= 'S' );
        CellPutS(V22, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21);
    EndIf;
EndIf;

If( nDimCount = 22 );
    sType = DTYPE( sMeasureDim, V22 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V23), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22);
    ElseIf ( sType @= 'S' );
        CellPutS(V23, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22);
    EndIf;
EndIf;

If( nDimCount = 23 );
    sType = DTYPE( sMeasureDim, V23 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V24), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22,
V23);
    ElseIf ( sType @= 'S' );
        CellPutS(V24, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23);
    EndIf;
EndIf;

If( nDimCount = 24 );
    sType = DTYPE( sMeasureDim, V24 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V25), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22,
V23, V24);
    ElseIf ( sType @= 'S' );
        CellPutS(V25, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24);
    EndIf;
EndIf;

If( nDimCount = 25 );
    sType = DTYPE( sMeasureDim, V25 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V26), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22,
V23, V24, V25);
    ElseIf ( sType @= 'S' );
        CellPutS(V26, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25);
    EndIf;
EndIf;

If( nDimCount = 26 );
    sType = DTYPE( sMeasureDim, V26 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V27), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22,
V23, V24, V25, V26);
    ElseIf ( sType @= 'S' );
        CellPutS(V27, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25, V
26);
    EndIf;
EndIf;

If( nDimCount = 27 );
    sType = DTYPE( sMeasureDim, V27 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V28), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22,
V23, V24, V25, V26, V27);
    ElseIf ( sType @= 'S' );
        CellPutS(V28, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25, V
26, V27);
    EndIf;
EndIf;

If( nDimCount = 28 );
    sType = DTYPE( sMeasureDim, V28 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V29), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22,
V23, V24, V25, V26, V27, V28);
    ElseIf ( sType @= 'S' );
        CellPutS(V29, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25, V
26, V27, V28);
    EndIf;
EndIf;

If( nDimCount = 29 );
    sType = DTYPE( sMeasureDim, V29 );
    If( sType @= 'N' );
        CellPutN(StringToNumber(V30), pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22,
V23, V24, V25, V26, V27, V28, V29);
    ElseIf ( sType @= 'S' );
        CellPutS(V30, pCubeName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25, V
26, V27, V28, V29);
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
