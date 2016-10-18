601,100
602,"Dim.Element.Order.Hierarchy"
562,"SUBSET"
586,"Account Test"
585,"Account Test"
564,
565,"uYv4essYuERUJa<i;O=;9a6ViKeDE`NHafLt?dT\cb01w<IWi:xB1B\B[`yWVEw;BA4^TZ>d[Q1[CI4;WUY^75RdGkYOhiFC]SnCxm75^>zNkV?yk18\dOF0G\lsMBOSto:KVr@Qmkf;0e7_yEoYY7roizlx]s\iPcVlBqf7ljgPhNc_tT0Pg05v4W746\s<N5PjwvpB"
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
V1
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
572,8

#****Begin: Generated Statements***
#****End: Generated Statements****

pDimName = 'Account Test';
pDimSourceName = 'Account';


573,16

#****Begin: Generated Statements***
#****End: Generated Statements****


IF( DTYPE(pDimName, V1) @= 'C' );

  nCount = ELCOMPN(pDimSourceName, v1);
  n = 1;
  WHILE ( n <= nCount );
    sChild = ELCOMP(pDimSourceName, v1, n);
    DimensionElementComponentAdd(pDimName, V1, sChild, ELWEIGHT(pDimSourceName, v1, sChild));
    n = n + 1;
  END; 

ENDIF;
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
