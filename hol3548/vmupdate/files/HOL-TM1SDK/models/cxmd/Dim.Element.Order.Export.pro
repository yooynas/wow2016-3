601,100
602,"Dim.Element.Order.Export"
562,"SUBSET"
586,"Account Test"
585,"Account Test"
564,
565,"x`85q=tF6V@g2O8TE:2JeaEVaijv3GWXxz0>[?26>XWfF]Fpvl<NQFpQF>QmdjX0BSG^lrv>3=T9W^8F;uaZ:o:_<CqjnwA06n3=q]RkXkWuuDhFu`1xbg@J:6r]A9nP9LsZ=86vXBthOjPsb0ZwboaDJ=XHs72@^VQ4P_q_Z>]bTxE8uN<SqZsIw9GZqp@RQsIA4]XI"
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
560,1
pDimName
561,1
2
590,1
pDimName,"Account Test"
637,1
pDimName,Dimension Name
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
572,14

#****Begin: Generated Statements***
#****End: Generated Statements****



DatasourceNameForServer = pDimName;
DatasourceNameForClient = pDimName;
DataSourceType = 'SUBSET';
DatasourceDimensionSubset = 'All';




573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,29

#****Begin: Generated Statements***
#****End: Generated Statements****


sSortOrder = ATTRS(pDimName, v1, 'Order');

IF ( DTYPE ( pDimName, v1) @= 'C' );

  nCount = ELCOMPN(pDimName, v1);

  IF ( nCount > 0 );

    n = 1;
    WHILE ( n <= nCount );
      sChild = ELCOMP(pDimName, v1, n);
      sChildSortOrder = ATTRS(pDimName, sChild, 'Order');
      TEXTOUTPUT(pDimName | '_Order.csv', sChildSortOrder, sChild, DTYPE(pDimName, sChild), v1, NumberToString(ELWEIGHT(pDimName, v1, sChild)));
      n = n + 1;
    END; 

  ELSE;

    TEXTOUTPUT(pDimName | '_Order.csv', sSortOrder, v1, DTYPE(pDimName, v1), '', '1');

  ENDIF;

ENDIf;

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
