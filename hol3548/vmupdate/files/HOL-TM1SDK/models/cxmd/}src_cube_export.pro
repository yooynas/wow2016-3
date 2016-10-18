601,100
602,"}src_cube_export"
562,"NULL"
586,
585,
564,
565,"z<OPR5AxAfO;N4YDC\dWLKhm0OaipY;b0EN6hF51d]OLtZzudV<8EGCLt=6Q84Tyxo__PRLQhFD5_Ocu<fGQNXHpWL_T1<oq?P:3YTGXdeqylzA0Y?5sme9DZVe1@s:ayPF6t[^mzXIrMVU>;j8qWoJS^bUR3DzyH1cMoalpzW9<c9t`IQ\S<D_bJLEJXo=S_K[t:X:f"
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
571,
569,0
592,0
599,1000
560,4
pCubeName
pStructureOnly
pIncludeSecurity
pPath
561,4
2
1
1
2
590,4
pCubeName,""
pStructureOnly,1
pIncludeSecurity,1
pPath,""
637,4
pCubeName,"Name of the Cube to Export"
pStructureOnly,"Do not export data"
pIncludeSecurity,"Include the security of the cube"
pPath,"Path to file"
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,105

#****Begin: Generated Statements***
#****End: Generated Statements****


IF ( CubeExists (pCubeName) = 1 );
  nFill = 1;

  sFileName = pPath;

  DatasourceASCIIQuoteCharacter = '';
  DatasourceASCIIDelimiter = CHAR(9);
  SetOutputCharacterSet( sFileName, 'TM1CS_UTF8'  );

  sSectionName = 'Dimensions:=';
  TEXTOUTPUT(sFileName, sSectionName);
  nCount = 1;
  nDimensionIndex = 0;
  While( TabDim( pCubeName, nCount ) @<> '' );
    sDimension = TabDim( pCubeName, nCount );
    TEXTOUTPUT(sFileName, Fill(' ', nFill) | sDimension);
    nCount = nCount + 1;
  End;
  TEXTOUTPUT(sFileName, '');

  sControlName = '}CubeProperties';
  If( DimensionExists(sControlName) = 1 & CubeExists(sControlName) = 1);
    sSectionName = 'CubeProperties:=';
    TEXTOUTPUT(sFileName, sSectionName);
    nPropCount = DIMSIZ( sControlName );
    p = 1;
    WHILE (p <= nPropCount);
        sProp = DIMNM( sControlName , p);
        If(DTYPE(sControlName, sProp) @= 'S');
          sValue = CellGetS(sControlName, pCubeName, sProp);
        Else;
          sValue = NumberToString(CellGetN(sControlName, pCubeName, sProp));
        EndIf;
        sValue = sProp | ':=' | sValue;
        TEXTOUTPUT(sFileName, Fill(' ', nFill) | sValue);
        p = p + 1;
    END;
    TEXTOUTPUT(sFileName, '');
  EndIf;

  sControlName = '}CubeAttributes';
  If( DimensionExists(sControlName) = 1 & CubeExists(sControlName) = 1);
    sSectionName = 'CubeAttributes:=';
    TEXTOUTPUT(sFileName, sSectionName);
    nPropCount = DIMSIZ( sControlName );
    p = 1;
    WHILE (p <= nPropCount);
        sProp = DIMNM( sControlName , p);
        If(DTYPE(sControlName, sProp) @= 'S');
          sValue = CellGetS(sControlName, pCubeName, sProp);
        Else;
          sValue = NumberToString(CellGetN(sControlName, pCubeName, sProp));
        EndIf;
        sValue = sProp | ':=' | sValue;
        TEXTOUTPUT(sFileName, Fill(' ', nFill) | sValue);
        p = p + 1;
    END;
    TEXTOUTPUT(sFileName, '');
  EndIf;

  sControlName = '}CubeCaptions';
  If( DimensionExists(sControlName) = 1 & CubeExists(sControlName) = 1);
    sSectionName = 'CubeCaptions:=';
    TEXTOUTPUT(sFileName, sSectionName);
    nPropCount = DIMSIZ( sControlName );
    p = 1;
    WHILE (p <= nPropCount);
        sProp = DIMNM( sControlName , p);
        If(DTYPE(sControlName, sProp) @= 'S');
          sValue = CellGetS(sControlName, pCubeName, sProp);
        Else;
          sValue = NumberToString(CellGetN(sControlName, pCubeName, sProp));
        EndIf;
        sValue = sProp | ':=' | sValue;
        TEXTOUTPUT(sFileName, Fill(' ', nFill) | sValue);
        p = p + 1;
    END;
    TEXTOUTPUT(sFileName, '');
  EndIf;

  If(pIncludeSecurity <> 0 );
    sControlName = '}Groups';
    If( DimensionExists(sControlName) = 1 & CubeExists('}CubeSecurity') = 1);
      sSectionName = 'CubeSecurity:=';
      TEXTOUTPUT(sFileName, sSectionName);
      nPropCount = DIMSIZ( sControlName );
      p = 1;
      WHILE (p <= nPropCount);
          sProp = DIMNM( sControlName , p);
          sValue = CellGetS('}CubeSecurity', pCubeName, sProp);
          sValue = sProp | ':=' | sValue;
          TEXTOUTPUT(sFileName, Fill(' ', nFill) | sValue);
          p = p + 1;
      END;
      TEXTOUTPUT(sFileName, '');
    EndIf;
  EndIf;

ENDIF;

573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
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
