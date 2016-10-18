601,100
602,"}src_export"
562,"NULL"
586,
585,
564,
565,"bkarJp34NugpeleUrwF@u^gW`5s:;GZPoerZy>tgj1Qdm8oioqhPxHM0?IyhuB=igjnf>TK:zrR]Qrm@J6?yf9X0RLhxQrN4iOPEYwCHWRXVejMgx>lQAr=R?c21<T^Q:[L4bXw7L^A@l17Sy8R]@5tZSjmtdxZXCCSZNuhw88BwY2RuDQCaM6QpqVun:b72zjSj`9bq"
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
560,1
pOutputDir
561,1
2
590,1
pOutputDir,""
637,1
pOutputDir,Directory to output files
577,0
578,0
579,0
580,0
581,0
582,0
572,21

#****Begin: Generated Statements***
#****End: Generated Statements****

IF(FileExists(pOutputDir) = 0);
  ItemReject('The path has not been found: ' | pOutputDir);
ENDIF;

ExecuteProcess('}src_cube_export_all', 'pIncludeControlObjects', 1, 'pIncludeSecurity', 1, 'pOutputDir', pOutputDir);
ExecuteProcess('}src_dim_export_all', 'pIncludeControlObjects', 1, 'pIncludeSecurity', 1, 'pOutputDir', pOutputDir);
ExecuteProcess('}src_stats_export', 'pOutputDir', pOutputDir);
ExecuteProcess('}src_clients_export', 'pOutputDir', pOutputDir);









573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,5

#****Begin: Generated Statements***
#****End: Generated Statements****

TEXTOUTPUT(pOutputDir | 'Done', TODAY(1) | TIME);
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
