601,100
602,"}src_dim_export_data_all"
562,"SUBSET"
586,"}Dimensions"
585,"}Dimensions"
564,
565,"ytc=0?Xxq=aZu<O5;BHd9ZX>7aWAs7yATvxJ3q9mq73g`4TjGY>YDVx>oHWv2bY<D7@svnAL5r^nrigx\=G<[9A9I1KgcR1@M^WHrdNXCWN>WCHXr\MGsh_AhxO=y4LX1AgsPQW?<4B@kIB;`1^]8iK@mQLliq8[WvOkp;]N8VK]`p80QBGCiM7hakbrAemYFK6lC1hh"
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
pIncludeControlObjects
pOutputDir
pMaxElements
561,3
1
2
1
590,3
pIncludeControlObjects,1
pOutputDir,""
pMaxElements,50000
637,3
pIncludeControlObjects,Include the control Objects
pOutputDir,Export directory
pMaxElements,Maximum dimension size
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
572,3

#****Begin: Generated Statements***
#****End: Generated Statements****
573,5

#****Begin: Generated Statements***
#****End: Generated Statements****


574,15

#****Begin: Generated Statements***
#****End: Generated Statements****

If( SUBST(V1, 1, 1) @= '}' );
  nIsControl = 1;
Else;
 nIsControl = 0;
EndIf;

If( (nIsControl = 1 & pIncludeControlObjects <> 0) % (nIsControl = 0));
  ExecuteProcess('}src_dim_export_data', 'pDimName', V1, 'pOutputDir', pOutputDir, 'pMaxElements', pMaxElements);
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
