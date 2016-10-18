601,100
602,"Sys.CellSecurityCreate"
562,"NULL"
586,
585,
564,
565,"r^3y`\X3F9iK>qh\eRaq5W[g0v6h`bZc6YGsUZz[>;D\t?MZ_>4t21aYNTbXvbf1[JQdaCvTYoMyJG1N?Ftn0ZIbfEQ1h]]0e?=WxngAdaVMdovbEG5H>Ms_`vZiCqB8NBM2P6UtKmmMxU`5XG6dTyYnH9o5g;`8awiyz6kF=rSO8dZ6QDk8L`jz6P:0feYPqdaXCkB;"
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
603,0
572,17

#****Begin: Generated Statements***
#****End: Generated Statements****

sCubeName = 'General Ledger';
If(CubeExists('}CellSecurity_' | sCubeName) = 0);
  nCount = 1;
  sDimList = '';
  While( TabDim( sCubeName, nCount ) @<> '' );
    If(nCount > 1);
      sDimList = sDimList | ':';
    EndIf;
    sDimList = sDimList | '1';
    nCount = nCount + 1;
  End;
  CellSecurityCubeCreate (sCubeName, sDimList);
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
