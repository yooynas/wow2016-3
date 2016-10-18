601,100
562,"SUBSET"
586,"Accounts"
585,"Accounts"
564,
565,"w<c83Ly8Rl]M4liJHs]sL<BaE;xeGv93i8L2:s6?E8EDYaPmxUa>eFG_nfEL5??6Pqe8hYqkzGoL8?7IKsC2\w9q;9]A3;juE8:SAJ`us=PsoQQ;MK`h=C]]VTmz4UacKfX8[9;pf47s8Rylx63m5B3Z74AXNzPA\5Sys231@MF\616]p1U@=_`I8A7g\J30gKf\Bh:A"
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
560,2
pDimName
pFilePath
561,2
2
2
590,2
pDimName,""
pFilePath,""
637,2
pDimName,The name of the dimension
pFilePath,The path to export the file to
577,1
vElement
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
572,33

#****Begin: Generated Statements***
#****End: Generated Statements****

DatasourceASCIIQuoteCharacter = '';
DatasourceASCIIDelimiter = CHAR(9);

If ( TRIM( pFilePath ) @= '' );
  sElFileName = pDimName | '.dimx';
Else;
  sElFileName = pFilePath;
EndIf;


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

i = 1;


573,72

#****Begin: Generated Statements***
#****End: Generated Statements****

DatasourceASCIIQuoteCharacter = '';
DatasourceASCIIDelimiter = CHAR(9);

If( i = 1);

    sAttrDimName = '}ElementAttributes_' | pDimName;
    sAttributes = 'Attributes:=';
    ASCIIOutput(sElFileName, sAttributes);
    sAttrTypes = '';
    nAttrCount = DIMSIZ( sAttrDimName );
    a = 1;
    WHILE (a <= nAttrCount);
        sAttr = DIMNM( sAttrDimName , a);
        sAttr = sAttr | ':= ' | SUBST( DTYPE( sAttrDimName, sAttr ), 2, 1 );
        ASCIIOutput(sElFileName, Fill(' ', 2) | sAttr);
        a = a + 1;
    END;

    ASCIIOutput(sElFileName, '');

EndIf;

sEl = vElement;
If( SCAN (':=', sEl) > 0);
    ItemReject('Element ' | sEl | ' cannot contain :=');
EndIf;
ASCIIOutput(sElFileName, sEl | ':=');




# Type
sType = DTYPE(pDimName, sEl);
ASCIIOutput(sElFileName, Fill(' ', 2) | 'Type:= ' | sType);


sAttributes = Fill(' ', 2) | 'Attributes:=';
ASCIIOutput(sElFileName, sAttributes);
nAttrCount = DIMSIZ( sAttrDimName );
a = 1;
WHILE (a <= nAttrCount);
    sAttr = DIMNM( sAttrDimName , a);
    sAttrType = SUBST( DTYPE( sAttrDimName, sAttr ), 2, 1 );
    If( sAttrType @= 'N' );
        sAttrVal = NumberToString(ATTRN(pDimName, sEl, sAttr));
    Else;
        sAttrVal = ATTRS(pDimName, sEl, sAttr);
    EndIf;
    ASCIIOutput(sElFileName, Fill(' ', 4) | sAttr | ':= ' | sAttrVal );
    a = a + 1;
END;

# Loop through all of the parents
sParents = Fill(' ', 2) | 'Parents:=';
ASCIIOutput(sElFileName, sParents);
nParentCount = ELPARN(pDimName, sEl);
p = 1;
WHILE (p <= nParentCount);
    sPar = ELPAR(pDimName,  sEl, p);
    ASCIIOutput(sElFileName, Fill(' ', 4) | sPar | ':= ' | NumberToString(ELWEIGHT(pDimName, sPar, sEl)) );
    p = p + 1;
END;


ASCIIOutput(sElFileName, '');

i = i + 1;

574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,3

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
