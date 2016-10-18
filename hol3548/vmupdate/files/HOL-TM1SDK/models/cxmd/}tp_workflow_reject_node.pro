601,100
602,"}tp_workflow_reject_node"
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
560,5
pExecutionId
pTime
pAppId
pNode
pControl
561,5
2
2
2
2
2
590,5
pExecutionId,"None"
pTime,"0"
pAppId,"MyApp"
pNode,"NA"
pControl,"N"
637,5
pExecutionId,
pTime,
pAppId,
pNode,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,217


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
cTM1Process = cControlPrefix | 'tp_workflow_reject_node';
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

#*** Log Parameters

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:', pExecutionId, pTime, pAppId, pNode, pControl);
EndIf;

#*** Check state cube

cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Check state cube: ' | cStateCube);
EndIf;

If(CubeExists(cStateCube) = 0);
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pExecutionId, 
'pProcess', cTM1Process, 
'pErrorCode', 'TI_CUBE_NOT_EXIST',
'pErrorDetails', cStateCube,
'pControl', pControl);

ProcessError;
EndIf;

#***

StringGlobalVariable('gApprovalDim');
StringGlobalVariable('gApprovalSubset');
StringGlobalVariable('gIsActive');

vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_application_attributes', 'pExecutionId', pExecutionId,
'pAppId', pAppId, 'pControl',  pControl);
If (vReturnValue <> ProcessExitNormal());
ProcessError;
EndIf;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'get application attributes', gApprovalDim, gApprovalSubset, gIsActive);
EndIf;


If (gIsActive @<> 'Y');
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pExecutionId, 
'pProcess', cTM1Process, 
'pErrorCode', 'TI_APP_NOT_ACTIVE',
'pErrorDetails', pAppId,
'pControl', pControl);

ProcessError;
EndIf;

#***

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Check node: ' | pNode);
EndIf;

If (DIMIX(gApprovalDim, pNode) = 0);
ProcessError;
EndIf;

#*** Check user  privilege
StringGlobalVariable('gReject');
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_user_permissions', 
'pGuid', pExecutionId, 'pApplication', pAppId, 'pNode', pNode, 'pUser', TM1User, 'pControl', pControl);
If (vReturnValue <> ProcessExitNormal());
ProcessError;
EndIf;

If (gReject @= 'F');
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pExecutionId, 
'pProcess', cTM1Process, 
'pErrorCode', 'TI_NO_PERMISSION',
'pErrorDetails', 'REJECT' | ', ' | pNode,
'pControl', pControl);

ProcessError;
EndIf;

#*** Check node state

cLocked = '4';
cState = 'State';
vValue = CellGetS(cStateCube, pNode, cState);
If (vValue @<> cLocked);
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pExecutionId, 
'pProcess', cTM1Process, 
'pErrorCode', 'TI_WRONG_STATE',
'pErrorDetails', 'REJECT' | ', ' | pNode | ', ' | vValue,
'pControl', pControl);

ProcessError;
EndIf;

#*** Change state
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_change_node_state', 'pExecutionId', pExecutionId,
'pTime', pTime, 'pAppId', pAppId, 'pNode', pNode, 'pPrivilege', 'REJECT', 'pControl',
pControl);
If (vReturnValue <> ProcessExitNormal());
ProcessError;
EndIf;


#*** Bounce all users who has edit conflict with this user on the node (if it is leaf)
cCurrentOwnerId = 'CurrentOwnerId';
cTakeOwnershipNode = 'TakeOwnershipNode';
cOwnerId = CellGetS(cStateCube, pNode, cCurrentOwnerId);
cOwnershipNode = CellGetS(cStateCube, pNode,cTakeOwnershipNode);

IF (DTYPE(gApprovalDim, pNode) @= 'N');
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_bounce_conflict_users', 'pExecutionId', 
pExecutionId, 'pAppId', pAppId, 'pNode', pNode, 'pApprovalDim', gApprovalDim, 'pTime',pTime,
'pNewOwnerID', cOwnerId, 'pCheckBouncingOnly', 'N','pBouncingMode', '', 'pControl', pControl);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;
ENDIF;

#***
If (cOwnerId @<> '');

If (DIMIX('}Clients', cOwnerId) <> 0 & DTYPE(gApprovalDim, pNode) @= 'N');

#tentatively set node state to available and empty owner so that ownership can be taken
cAvailable = '0';
CellPutS(cAvailable, cStateCube, pNode, cState);
CellPutS('', cStateCube, pNode, cCurrentOwnerId);

#return ownership back to original owner on cOwnershipNode level
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_own_node', 'pExecutionId', pExecutionId, 'pTime', pTime,
		'pAppId', pAppId, 'pNode', cOwnershipNode, 'pNewOwnerID', cOwnerId, 'pControl', pControl);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;

EndIf;
EndIf;

#***Unlock the node
cApplicationCubesCube = '}tp_application_cubes';
totalCubes = DIMSIZ('}Cubes');
indexCube = 1;

While (indexCube <= totalCubes);
	cCubeName = DIMNM('}Cubes', indexCube);
	cIsAppCube = CellGetS(cApplicationCubesCube, pAppId, cCubeName);
	If (cIsAppCube @<> '');
		cOverlayCube = '}SecurityOverlayGlobal_' | cCubeName;
		IF (CubeExists(cOverlayCube)>0);
			SecurityOverlayGlobalLockNode(0,cCubeName,pNode);
		Endif;
		If (cGenerateLog @= 'Y');
			cLogCubeText = 'unlock cube: ' | cCubeName | ' on node: ' | pNode;
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
		EndIf;
	EndIf;
	indexCube = indexCube +1;
End;


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
