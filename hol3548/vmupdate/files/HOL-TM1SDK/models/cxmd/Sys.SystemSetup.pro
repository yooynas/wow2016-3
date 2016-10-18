601,100
602,"Sys.SystemSetup"
562,"NULL"
586,
585,
564,
565,"i`\hl^[yba?[4Me89[[Oi5zu[IUiBhhj:kLq][aEXd5<9a5PEWY1dd6jmNZrXS<P@NQCJS;n0p7:QehwfirWba2_V5frwj6cgea1t<HbaTP@uXXn;IpTpxGWu2=0;YK?\8j7T15>W8C^7RDpOXp<14@a7oL=e]s<LkK_8zJmi]Fp:Q`9ngaeTYy:mxDleqZEpHlV@iO9"
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
560,0
561,0
590,0
637,0
577,0
578,0
579,0
580,0
581,0
582,0
931,1

603,0
572,24

#****Begin: Generated Statements***
#****End: Generated Statements****



sCubeName = '}SysControlCube';
sMeasureName = '}SysControlCubeMeasure';

If (DimensionExists(sMeasureName) = 0);
    DimensionCreate(sMeasureName);
    DimensionElementInsert(sMeasureName, '', 'Monitor', 'S');
EndIf;

If (CubeExists(sCubeName) = 0);
    CubeCreate(sCubeName, '}Cubes', sMeasureName);
EndIf;

sCubeName = '}SysControlDimension';
If (CubeExists(sCubeName) = 0);
    CubeCreate(sCubeName, '}Dimensions', sMeasureName);
EndIf;


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
