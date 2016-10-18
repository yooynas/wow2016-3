601,100
602,"}src_dim_export_all"
562,"SUBSET"
586,"}Dimensions"
585,"}Dimensions"
564,
565,"p_;sPsOhcnoJ1o^Ya0EEutxs>M\s7HTxS_<\hurq>n=Q;B4d@W?k`5pUs6q<I6WIATeN0Xl;bNpDh=2K<yG2Y>3rwc`WruaPuxy:QoL6f7dgNT=Dt7klz@jsZ?JwF>TSjzP]O_CJoRcsnUhcE]:q7e?lskcU4Z]ZeLWVz\\XTDNuqtvm9]3[TFB:pOzEXTKSGbofx1;L"
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
pIncludeSecurity
pOutputDir
561,3
1
1
2
590,3
pIncludeControlObjects,1
pIncludeSecurity,1
pOutputDir,""
637,3
pIncludeControlObjects,Include the control Objects
pIncludeSecurity,Include security
pOutputDir,Export directory
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
  ExecuteProcess('}src_dim_export', 'pDimName', V1, 'pIncludeSecurity', pIncludeSecurity, 'pOutputDir', pOutputDir);
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
