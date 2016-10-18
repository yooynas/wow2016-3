601,100
602,"Sys.CubDump"
562,"VIEW"
586,"Variables"
585,"Variables"
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
589,
568,""""
570,All
571,
569,0
592,0
599,1000
560,2
pCubeName
pFilter
561,2
2
2
590,2
pCubeName,""
pFilter,""
637,2
pCubeName,Cube Name
pFilter,Filter: Year+2000&Month+01
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
32
33
34
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
931,1
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
603,0
572,123

#****Begin: Generated Statements***
#****End: Generated Statements****


sDelim = CHAR(9);
DatasourceASCIIQuoteCharacter = '';
DatasourceASCIIDelimiter = CHAR(9);
sFileName = pCubeName | '.cubx';


nDimCount = 0;
While( TabDim( pCubeName, nDimCount + 1 ) @<> '' );
  nDimCount = nDimCount + 1;
End;

cView = '}Export.' | NumberToString( ROUND( RAND( ) *100000 ) );
cSubset = cView;
sDelimDim = '&';
sDelimElem = '+';

# If specified cube does not exist then terminate process
If( CubeExists(   pCubeName   ) = 0 );
  sMessage = 'Cube: ' | pCubeName | ' does not exist';
  ItemReject( sMessage );
  ProcessQuit();
EndIf;


### Create View ###

If( ViewExists( pCubeName, cView ) = 1 );
ViewDestroy( pCubeName, cView );
EndIf;
ViewCreate( pCubeName, cView );
ViewExtractSkipCalcsSet( pCubeName, cView, 1 );
ViewExtractSkipZeroesSet( pCubeName, cView, 1 );
ViewExtractSkipRuleValuesSet( pCubeName, cView, 1 );


### Split filter and create subsets ###

sFilter = pFilter;
nDelimDimIndex = 1;

# Split filter into seperate dimensions
While( nDelimDimIndex <> 0 & Long( sFilter ) > 0 );

  nDelimDimIndex = Scan( sDelimDim, sFilter );
  If( nDelimDimIndex <> 0 );
    sArgument = Trim( SubSt( sFilter, 1, nDelimDimIndex - 1 ) );
    sFilter = Trim( SubSt( sFilter, nDelimDimIndex + Long( sDelimDim ), Long( sFilter ) ) );
  Else;
    sArgument = Trim( sFilter );
  EndIf;

  # Split argument into dimension and elements
  nDelimElemIndex = Scan( sDelimElem, sArgument );
  If( nDelimElemIndex = 0 );
    # Argument does not contain at least one delimiter (the first delimiter seperates the dimension name from the elements)
    nErrors = 1;
    sMessage = 'Filter not specified correctly: ' | sArgument;
    ItemReject( sMessage );
  EndIf;

  sDimension = Trim( SubSt( sArgument, 1, nDelimElemIndex - 1 ) );
  sElements = Trim( SubSt( sArgument, nDelimElemIndex + 1, Long( sArgument ) ) );

  # Check that dimension exists in the cube
  If( DimensionExists( sDimension ) = 1 );
    # Step 3: Create subset and assign to view

    If( SubsetExists( sDimension, cSubset ) = 1 );
        SubsetDeleteAllElements( sDimension, cSubset );
    Else;
      SubsetCreate( sDimension, cSubset );
    EndIf;


    ### Insert elements ###

    nSubsetIndex = 1;
    nDelimIndex = 1;

    # Split filter into seperate dimensions
    While( nDelimIndex <> 0 & Long( sElements ) > 0 );

      nDelimIndex = Scan( sDelimDim, sElements );
      If( nDelimIndex <> 0 );
        sElement = Trim( SubSt( sElements, 1, nDelimIndex - 1 ) );
        sElements = Trim( SubSt( sElements, nDelimIndex + Long( sDelimDim ), Long( sElements ) ) );
      Else;
        sElement = Trim( sElements );
      EndIf;

      If( DimIx( sDimension, sElement ) <> 0 );
          IF(ELLEV( sDimension, sElement) > 0);
            nErrors = 1;
            sMessage = 'Only leaf elements can be filtered: ' | sElement;
            ItemReject( sMessage );
          ELSE;
            SubsetElementInsert( sDimension, cSubset, sElement, nSubsetIndex );
          ENDIF;
        nSubsetIndex = nSubsetIndex + 1;
      EndIf;
    End;

    ViewSubsetAssign(pCubeName, cView, sDimension, cSubset);

  EndIf;

End;


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
575,19

#****Begin: Generated Statements***
#****End: Generated Statements****

ViewDestroy(pCubeName, cView);

# Clean up subsets
nDimCount = 0;
i = 1;
sDimName = TabDim( pCubeName, i );
While( sDimName @<> '' );
  If( SubsetExists (sDimName, cSubset) = 1 );
     SubsetDestroy( sDimName, cSubset );
  EndIf;
  sDimName = TabDim( pCubeName, i );
  i = i + 1;
End;


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
