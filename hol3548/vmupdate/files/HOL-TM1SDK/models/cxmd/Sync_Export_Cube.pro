601,100
562,"VIEW"
586,"Variables"
585,"Variables"
564,
565,"tkwqJOwiw3SI2uKgkMSXauz38BK_J@yc@dv45k\hRtZkL59gr7TF`iv0PQ<@Fo3K]3r19sjYI>F<e@Dbaip9SkySZIJf=RpCMNUi]_oCeR6mzqkDAi7A5Gm@y0rX1pzCPt@LuHX>pgSBDCrmZt0Ih3[@O\\oX6T<q7;_M5CKhIP7W@LASZz:`m:1aXGBe4l70:Hz2qs]"
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
570,All
571,
569,0
592,0
599,1000
560,3
pCubeName
pViewName
pDropDir
561,3
2
2
2
590,3
pCubeName,""
pViewName,""
pDropDir,"\\T2vic01cog01\Applications\Transfer\TM1 Transfer\Cube"
637,3
pCubeName,Cube Name
pViewName,View Name
pDropDir,Directory to output files
577,34
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
Value
NVALUE
SVALUE
VALUE_IS_STRING
578,34
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
2
1
2
1
579,34
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
0
0
0
580,34
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
0
581,34
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
0
582,31
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
VarType=32ColType=827
572,38

#****Begin: Generated Statements***
#****End: Generated Statements****


sDelim = CHAR(9);
DatasourceASCIIQuoteCharacter = '';
DatasourceASCIIDelimiter = CHAR(9);
sFileName = pDropDir | pCubeName | '.txt';


nDimCount = 0;
While( TabDim( pCubeName, nDimCount + 1 ) @<> '' );
  nDimCount = nDimCount + 1;
End;

cView = pViewName;
sSubset = cView;
sDelimDim = '&';
sDelimElem = '+';

# If specified cube does not exist then terminate process
If( CubeExists(   pCubeName   ) = 0 );
  sMessage = 'Cube: ' | pCubeName | ' does not exist';
  ItemReject( sMessage );
  ProcessQuit();
EndIf;


DataSourceType = 'VIEW';
DatasourceNameForServer = pCubeName;
DatasourceNameForClient = pCubeName;
DatasourceCubeView = cView;


i = 1;


573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,136

#****Begin: Generated Statements***
#****End: Generated Statements****

If( i = 1 );

    sDims = '';
    d = 1;
    While( d <= nDimCount );
      sDimName = TABDIM( pCubeName, d );
      sDims = sDims | sDimName | sDelim;
      d = d + 1;
    End;

    sDims = sDims | 'Value';
    ASCIIOutput(sFileName, sDims);

EndIf;

If( nDimCount = 2 );
    ASCIIOutput(sFileName, V1, V2, V3);
EndIf;

If( nDimCount = 3 );
    ASCIIOutput(sFileName, V1, V2, V3, V4);
EndIf;

If( nDimCount = 4 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5);
EndIf;

If( nDimCount = 5 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6);
EndIf;

If( nDimCount = 6 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7);
EndIf;

If( nDimCount = 7 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8);
EndIf;

If( nDimCount = 8 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9);
EndIf;

If( nDimCount = 9 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10);
EndIf;

If( nDimCount = 10 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11);
EndIf;

If( nDimCount = 11 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12);
EndIf;

If( nDimCount = 12 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13);
EndIf;

If( nDimCount = 13 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14);
EndIf;

If( nDimCount = 14 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15);
EndIf;

If( nDimCount = 15 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16);
EndIf;

If( nDimCount = 16 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17);
EndIf;

If( nDimCount = 17 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18);
EndIf;

If( nDimCount = 18 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19);
EndIf;

If( nDimCount = 19 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20);
EndIf;

If( nDimCount = 20 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21);
EndIf;

If( nDimCount = 21 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22);
EndIf;

If( nDimCount = 22 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23);
EndIf;

If( nDimCount = 23 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24);
EndIf;

If( nDimCount = 24 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25);
EndIf;

If( nDimCount = 25 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25, V26);
EndIf;

If( nDimCount = 26 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25, V26, V2
7);
EndIf;

If( nDimCount = 27 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25, V26, V2
7, V28);
EndIf;

If( nDimCount = 28 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25, V26, V2
7, V28, V29);
EndIf;

If( nDimCount = 29 );
    ASCIIOutput(sFileName, V1, V2, V3, V4, V5, V6, V7, V8, V9, V10, V11, V12, V13, V14, V15, V16, V17, V18, V19, V20, V21, V22, V23, V24, V25, V26, V2
7, V28, V29, V30);
EndIf;

i = i + 1;
575,7

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
