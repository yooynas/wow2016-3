601,100
602,"Dim.Element.Order"
562,"SUBSET"
586,"Account"
585,"Account"
564,
565,"cyva>r;]8clt8bl>nXE6Vyj2unw3M[5pBl\POto@imxOaW^wFp7F4<E52j@D6;L?=R0P:QmT]GE@T:LnTAgdK[hM:mYb0GY^?\gXNc1P1IS[9eMm]dh3jLkrs2XZ6uoS^PTW1tSW57>LLZf=g[SbTY<^ZUCCJ9I]A`bbX_s[^?5157sc8cw`a]n:3tCHheMQiumTrw`Q"
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
560,0
561,0
590,0
637,0
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
572,5

#****Begin: Generated Statements***
#****End: Generated Statements****

pDimName = 'Account';
573,24

#****Begin: Generated Statements***
#****End: Generated Statements****


sElementAfter = ATTRS(pDimName, v1, 'Element After');

If( sElementAfter @<> '' & DTYPE( pDimName, v1) @= 'C' );

  TEXTOUTPUT(pDimName | '_Reorder.csv', v1, sElementAfter);
  nCount = ELCOMPN(pDimName, v1);
  n = 1;
  WHILE ( n <= nCount );
    sChild = ELCOMP(pDimName, v1, n);
    TEXTOUTPUT(pDimName | '_Reorder.csv', '  -  ' | sChild);
    n = n + 1;
  END; 

EndIf;





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
