601,100
602,"}tp_workflow_execute_action"
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
560,8
pExecutionId
pTime
pAppId
pNode
pAction
pAnnotationBody
pAnnotationTitle
pControl
561,8
2
2
2
2
2
2
2
2
590,8
pExecutionId,"None"
pTime,"0"
pAppId,"MyApp"
pNode,"NA"
pAction,"NA"
pAnnotationBody,"NA"
pAnnotationTitle,"NA"
pControl,"Y"
637,8
pExecutionId,
pTime,
pAppId,
pNode,
pAction,
pAnnotationBody,
pAnnotationTitle,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,152

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

#*** Log File Name
cTM1Process = GetProcessName();
StringGlobalVariable('gPrologLog');
StringGlobalVariable('gEpilogLog');
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_log_file_names', 'pExecutionId', pExecutionId,
'pProcess', cTM1Process, 'pControl', pControl);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;
cPrologLog = gPrologLog;
cEpilogLog = gEpilogLog;
cTM1Log = cPrologLog;

cConfigDim = cControlPrefix | 'tp_config';
If (DimensionExists(cConfigDim) = 1);
	cGenerateLog = ATTRS(cConfigDim, 'Generate TI Log', 'String Value');
Else;
	cGenerateLog = 'N';
EndIf;

#*** Get lock

#cLockName = 'tp_semaphore';
#Synchronized( cLockName ) ;

#***
CubeLockOverride(1);

#*** Log Parameters

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:', pExecutionId, pTime, pAppId, pNode, pAction, pAnnotationBody, pAnnotationTitle, pControl);
EndIf;

#***
actionAllowAnnotate = 'F';
IF (pAction @= 'Own');

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_own_node',
	'pExecutionId', pExecutionId,'pTime', pTime,  'pAppId', pAppId, 'pNode', pNode, 'pNewOwnerID', TM1User(), 'pControl',  pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
	
ELSEIF (pAction @= 'Release');

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_release_node',
	'pExecutionId', pExecutionId,'pTime', pTime,  'pAppId', pAppId, 'pNode', pNode, 'pControl',  pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
	
	actionAllowAnnotate = 'T';

ELSEIF (pAction @= 'SubmitChildren');

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_submit_leaf_children',
	'pExecutionId', pExecutionId,'pTime', pTime,  'pAppId', pAppId, 'pNode', pNode, 'pControl',  pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;

	actionAllowAnnotate = 'T';

ELSEIF (pAction @= 'Submit');

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_submit_node',
	'pExecutionId', pExecutionId,'pTime', pTime,  'pAppId', pAppId, 'pNode', pNode, 'pControl',  pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;

	actionAllowAnnotate = 'T';

ELSEIF (pAction @= 'Reject');

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_reject_node',
	'pExecutionId', pExecutionId,'pTime', pTime,  'pAppId', pAppId, 'pNode', pNode, 'pControl',  pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
	
	actionAllowAnnotate = 'T';

ELSEIF (pAction @= 'Enter');

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_enter_node',
	'pExecutionId', pExecutionId,'pTime', pTime,  'pAppId', pAppId, 'pNode', pNode, 'pControl',  pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;

ELSEIF (pAction @= 'Save');

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_save_node',
	'pExecutionId', pExecutionId,'pTime', pTime,  'pAppId', pAppId, 'pNode', pNode, 'pControl',  pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;


ELSEIF (pAction @= 'Leave');

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_leave_node',
	'pExecutionId', pExecutionId,'pTime', pTime,  'pAppId', pAppId, 'pNode', pNode, 'pControl',  pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;

ELSEIF (pAction @= 'Annotate');
	actionAllowAnnotate = 'T';

ENDIF;

#***
CubeLockOverride(0);

#*** No error

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
EndIf;









573,1

574,1

575,1

576,
930,0
638,1
804,0
1217,1
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
