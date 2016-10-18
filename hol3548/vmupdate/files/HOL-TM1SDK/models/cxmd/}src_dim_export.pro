601,100
602,"}src_dim_export"
562,"NULL"
586,
585,
564,
565,"pSn9eZleTviH1C3ba6K3L<gi5T068n=]LV[j6mt8E<TeWPatkMQfHQ5t5wIho`clJ6?AZqLlQfwGy:1J]vcrIw@U1ArJZzg^@iEPq:1tr@`dETQS>FBTImK@ExcuZ7y=h_jF_W[xuX;\X2@^h`HSijfS]vTMv0\S=Xfxs<O`o08yLT5io9I@@_7y8PJ7u_DKyrv``se5"
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
571,All
569,0
592,0
599,1000
560,3
pDimName
pIncludeSecurity
pPath
561,3
2
1
2
590,3
pDimName,""
pIncludeSecurity,1
pPath,""
637,3
pDimName,"The name of the dimension"
pIncludeSecurity,"Include the security on the dimension"
pPath,"Path to file"
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,156

#****Begin: Generated Statements***
#****End: Generated Statements****

IF ( DimensionExists(pDimName) = 1 );

  nFill = 1;

  sStructureFileName = pPath;
  DatasourceASCIIQuoteCharacter = '';
  DatasourceASCIIDelimiter = CHAR(9);
  SetOutputCharacterSet( sStructureFileName, 'TM1CS_UTF8'  );


  sSubset = '}Export.All';
  If( SubsetExists( pDimName, sSubset ) = 1 );
    SubsetDeleteAllElements(  pDimName, sSubset );
  Else;
    SubsetCreate(  pDimName, sSubset );
  EndIf;
  SubsetIsAllSet(  pDimName, sSubset, 1 );


  ### Assign Data Source ###

  DatasourceNameForServer =  pDimName;
  DatasourceNameForClient =  pDimName;
  DataSourceType = 'SUBSET';
  DatasourceDimensionSubset = sSubset;

  SetOutputCharacterSet( sStructureFileName, 'TM1CS_UTF8'  );
  sAttrDimName = '}ElementAttributes_' | pDimName;
  nAttrCount = DIMSIZ( sAttrDimName );
  sSectionName = 'ElementAttributes:=';
  TEXTOUTPUT(sStructureFileName, sSectionName);
  sAttrTypes = '';
  a = 1;
  WHILE (a <= nAttrCount);
      sAttr = DIMNM( sAttrDimName , a);
      sAttrTypeOr = DTYPE( sAttrDimName, sAttr );
      nAttrTypeSize = LONG (sAttrTypeOr);

      IF (nAttrTypeSize > 1);
          sAttr = sAttr | ':=' | SUBST(  sAttrTypeOr , 2, 1 );
      ELSE;
            sAttr = sAttr | ':=' |   sAttrTypeOr ;
      ENDIF;
      TEXTOUTPUT(sStructureFileName, Fill(' ', nFill) | sAttr);
      a = a + 1;
  END;

  TEXTOUTPUT(sStructureFileName, '');

  sControlName = '}DimensionProperties';
  If( DimensionExists(sControlName) = 1 & CubeExists(sControlName) = 1);
    sSectionName = 'DimensionProperties:=';
    TEXTOUTPUT(sStructureFileName, sSectionName);
    nPropCount = DIMSIZ( sControlName );
    p = 1;
    WHILE (p <= nPropCount);
        sProp = DIMNM( sControlName , p);
        If( SCAN('TIME', sProp) = 0 & SCAN('STATUS', sProp) = 0 );
          If(DTYPE(sControlName, sProp) @= 'S');
            sValue = sProp | ':=' | CellGetS(sControlName, pDimName, sProp);
          Else;
            sValue = sProp | ':=' | NumberToString(CellGetN(sControlName, pDimName, sProp));
          EndIf;
          TEXTOUTPUT(sStructureFileName, Fill(' ', nFill) | sValue);
        EndIf;
        p = p + 1;
    END;
    TEXTOUTPUT(sStructureFileName, '');
  EndIf;

  sControlName = '}DimensionAttributes';
  If( DimensionExists(sControlName) = 1 & CubeExists(sControlName) = 1);
    sSectionName = 'DimensionAttributes:=';
    TEXTOUTPUT(sStructureFileName, sSectionName);
    nPropCount = DIMSIZ( sControlName );
    p = 1;
    WHILE (p <= nPropCount);
        sProp = DIMNM( sControlName , p);
        If( SCAN('TIME', sProp) = 0 & SCAN('STATUS', sProp) = 0 );
          If(DTYPE(sControlName, sProp) @= 'S');
            sValue = sProp | ':=' | CellGetS(sControlName, pDimName, sProp);
          Else;
            sValue = sProp | ':=' | NumberToString(CellGetN(sControlName, pDimName, sProp));
          EndIf;
          TEXTOUTPUT(sStructureFileName, Fill(' ', nFill) | sValue);
        EndIf;
        p = p + 1;
    END;
    TEXTOUTPUT(sStructureFileName, '');
  EndIf;

  sControlName = '}DimensionCaptions';
  If( DimensionExists(sControlName) = 1 & CubeExists(sControlName) = 1);
    sSectionName = 'DimensionCaptions:=';
    TEXTOUTPUT(sStructureFileName, sSectionName);
    nPropCount = DIMSIZ( sControlName );
    p = 1;
    WHILE (p <= nPropCount);
        sProp = DIMNM( sControlName , p);
        If( SCAN('TIME', sProp) = 0 & SCAN('STATUS', sProp) = 0 );
          If(DTYPE(sControlName, sProp) @= 'S');
            sValue = sProp | ':=' | CellGetS(sControlName, pDimName, sProp);
          Else;
            sValue = sProp | ':=' | NumberToString(CellGetN(sControlName, pDimName, sProp));
          EndIf;
          TEXTOUTPUT(sStructureFileName, Fill(' ', nFill) | sValue);
        EndIf;
        p = p + 1;
    END;
    TEXTOUTPUT(sStructureFileName, '');
  EndIf;

  sControlName = '}HierarchyProperties';
  If( DimensionExists(sControlName) = 1 & CubeExists(sControlName) = 1);
    sSectionName = 'HierarchyProperties:=';
    TEXTOUTPUT(sStructureFileName, sSectionName);
    nPropCount = DIMSIZ( sControlName );
    p = 1;
    WHILE (p <= nPropCount);
        sProp = DIMNM( sControlName , p);
        If(DTYPE(sControlName, sProp) @= 'S');
          sValue = sProp | ':=' | CellGetS(sControlName, pDimName, 'hierarchy0', sProp);
        Else;
          sValue = sProp | ':=' | NumberToString(CellGetN(sControlName, pDimName, 'hierarchy0', sProp));
        EndIf;
        TEXTOUTPUT(sStructureFileName, Fill(' ', nFill) | sValue);
        p = p + 1;
    END;
    TEXTOUTPUT(sStructureFileName, '');
  EndIf;

  If( pIncludeSecurity = 1);
    sControlName = '}Groups';
    If( DimensionExists(sControlName) = 1 & CubeExists('}DimensionSecurity') = 1);
      sSectionName = 'DimensionSecurity:=';
      TEXTOUTPUT(sStructureFileName, sSectionName);
      nPropCount = DIMSIZ( sControlName );
      p = 1;
      WHILE (p <= nPropCount);
          sProp = DIMNM( sControlName , p);
          sValue = sProp | ':=' | CellGetS('}DimensionSecurity', pDimName, sProp);
          TEXTOUTPUT(sStructureFileName, Fill(' ', nFill) | sValue);
          p = p + 1;
      END;
    EndIf;
    TEXTOUTPUT(sStructureFileName, '');
  EndIf; 

  TEXTOUTPUT(sStructureFileName, '---');
  TEXTOUTPUT(sStructureFileName, '');

ENDIF;
573,5

#****Begin: Generated Statements***
#****End: Generated Statements****


574,6

#****Begin: Generated Statements***
#****End: Generated Statements****



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
