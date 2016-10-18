601,100
602,"}tp_error_update_error_cube"
562,"NULL"
586,
585,
564,
565,"tABGqxo9IEg2gLtY`0i6agdoespM]Y2ptTKkFeOZ_LqyR7<FUO5s]EwAA17:>JRb[U=l@M3EfYxNGLRirWoUP86kerF;ZMotnbi]4u_S>Bh53ynr;tTU82kYw`nBNz51aKq2<x^]FenJV_cw4AFLDF[0`\KkL22bQOy1xzSf?fIOxvQNgu]tRqS;S\zv@w9NLWS=9h:@"
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
560,9
pGuid
pProcess
pStartTime
pEndTime
pErrorCode
pStatus
pClientStartTime
pErrorDetails
pControl
561,9
2
2
2
2
2
2
2
2
2
590,9
pGuid,"None"
pProcess,"None"
pStartTime,"None"
pEndTime,"None"
pErrorCode,"None"
pStatus,"None"
pClientStartTime,"None"
pErrorDetails,"None"
pControl,"None"
637,9
pGuid,
pProcess,
pStartTime,
pEndTime,
pErrorCode,
pStatus,
pClientStartTime,
pErrorDetails,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,92
#################################################################
## IBM Confidential
##
## OCO Source Materials
##
## BI and PM: pmpsvc
##
## (C) Copyright IBM Corp. 2008, 2009, 2010
##
## The source code for this program is not published or otherwise
## divested of its trade secrets, irrespective of what has been
## deposited with the U.S. Copyright Office.
#################################################################




cControlPrefix = '';
If (pControl @= 'Y');
cControlPrefix = '}';
EndIf;


#*** Get lock

#cLockName = 'tp_semaphore';
#Synchronized( cLockName ) ;

#***

vCube =cControlPrefix | 'tp_process_errors';

IF ( CubeExists ( vCube ) = 0 );
  ProcessError;
ENDIF;


#*** add guid to the guid dimension
ExecuteProcess(cControlPrefix | 'tp_error_add_guid', 'pGUID', pGuid, 'pControl', pControl);

CellPutS(TM1User, vCube, pGuid, 'UserName');

IF (pProcess @<>'');
CellPutS(pProcess, vCube, pGuid, 'SourceProcess');
ENDIF;

IF ( pStartTime @<> '' );
  CellPutS( pStartTime, vCube, pGuid, 'StartTime');
ENDIF;

IF ( pEndTime @<> '' );
  CellPutS( pEndTime, vCube, pGuid, 'EndTime');
ENDIF;

vFileName= pProcess | '_' | pGuid | '_prolog.log';
if (FileExists(vFileName)=1);
  CellPutS( vFileName, vCube, pGuid, 'PrologFile');
ENDIF;

vFileName= pProcess | '_' | pGuid | '_metadata.log';
if (FileExists(vFileName)=1);
  CellPutS( vFileName, vCube, pGuid, 'MetadataFile');
ENDIF;

vFileName= pProcess | '_' | pGuid | '_data.log';
if (FileExists(vFileName)=1);
  CellPutS( vFileName, vCube, pGuid, 'DataFile');
ENDIF;

vFileName= pProcess | '_' | pGuid | '_epilog.log';
if (FileExists(vFileName)=1);
  CellPutS( vFileName, vCube, pGuid, 'EpilogFile');
ENDIF;

IF ( pErrorCode @<> '' );
  CellPutS( pErrorCode, vCube, pGuid, 'ErrorCode');
ENDIF;

IF ( pStatus @<> '' );
  CellPutS( pStatus, vCube, pGuid, 'Status');
ENDIF;

IF ( pClientStartTime @<> '' );
  CellPutS( pClientStartTime, vCube, pGuid, 'ClientStartTime');
ENDIF;


IF ( pErrorDetails @<> '' );
  CellPutS( pErrorDetails, vCube, pGuid, 'ErrorDetails');
ENDIF;


573,1

574,1

575,1

576,
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
