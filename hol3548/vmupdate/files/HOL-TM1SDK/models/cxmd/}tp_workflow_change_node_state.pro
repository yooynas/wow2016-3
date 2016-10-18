601,100
602,"}tp_workflow_change_node_state"
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
560,6
pExecutionId
pTime
pAppId
pNode
pPrivilege
pControl
561,6
2
2
2
2
2
2
590,6
pExecutionId,"None"
pTime,"0"
pAppId,"MyApp"
pNode,"NA"
pPrivilege,"EDIT"
pControl,"N"
637,6
pExecutionId,
pTime,
pAppId,
pNode,
pPrivilege,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,330


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


#*** Log File Name
cTM1Process = cControlPrefix | 'tp_workflow_change_node_state';
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
	cGenerateLog = ATTRS(cControlPrefix | 'tp_config', 'Generate TI Log', 'String Value');
Else;
	cGenerateLog = 'N';
EndIf;

#*** Log Parameters

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:', pExecutionId, pTime, pAppId, pNode, pPrivilege, pControl);
EndIf;

#***

cDisplayUserName = ATTRS('}Clients', TM1User, '}TM1_DefaultDisplayValue');
If (cDisplayUserName @= '');
	cDisplayUserName = TM1User;
EndIf;

#*** 

cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'Check state cube: ' | cStateCube);
EndIf;

If (CubeExists(cStateCube) = 0);
	ProcessError;
EndIf;

#***
StringGlobalVariable('gApprovalDim');
StringGlobalVariable('gApprovalSubset');

vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_application_attributes', 'pExecutionId', pExecutionId,
	'pAppId', pAppId, 'pControl',  pControl);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'find approval hierarchy', gApprovalDim, gApprovalSubset);
EndIf;

#*** 

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'Make sure node is in approval dimension: ' | pNode);
EndIf;

If (DIMIX(gApprovalDim, pNode) = 0);
	ProcessError;
EndIf;

#*** 

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'Make sure the privilege can change state: ' | pPrivilege);
EndIf;

If ((UPPER(pPrivilege) @<> 'EDIT') & (UPPER(pPrivilege) @<> 'RELEASE') & (UPPER(pPrivilege) @<> 'REJECT') & (UPPER(pPrivilege) @<> 'SUBMIT') & (UPPER(pPrivilege) @<> 'BOUNCE'));
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_NO_PERMISSION',
		'pErrorDetails', pPrivilege | ', ' | pNode,
		'pControl', pControl);

	ProcessError;
EndIf;


#*** State constants

cNotStarted = '0';
cIncomplete = '1';
cWorkInProgress = '2';
cReady = '3';
cLocked = '4';

#*** Change node state

StringGlobalVariable('gParentInSubset');
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_parent_in_subset', 'pExecutionId', pExecutionId,
	'pDim', gApprovalDim, 'pSubset', gApprovalSubset, 'pNode', pNode);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;

cNodeParent = gParentInSubset;

cState= 'State';
If (cNodeParent @= '');
	cNodeParentState = '';
Else;
	cNodeParentState = CellGetS(cStateCube, cNodeParent, cState);
EndIf;

cNodeState = CellGetS(cStateCube, pNode, cState);

vStateChanged = 0;
If (UPPER(pPrivilege) @= 'EDIT');

	If (DTYPE(gApprovalDim, pNode) @<> 'N');
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_NODE_TYPE',
			'pErrorDetails', pPrivilege | ', ' | 'Consolidation',
			'pControl', pControl);
	
		ProcessError;
	EndIf;

	If ((cNodeState @= '') % (cNodeState @= cNotStarted));
		CellPutS(cWorkInProgress, cStateCube, pNode, cState);
		vStateChanged = 1;
	
	ElseIf (cNodeState @= cWorkInProgress);
		# Do nothing
	Else;
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_STATE',
			'pErrorDetails', pPrivilege | ', ' | cNodeState,
			'pControl', pControl);
		
		ProcessError;
	EndIf;
ElseIf (UPPER(pPrivilege) @= 'RELEASE');

	If (DTYPE(gApprovalDim, pNode) @<> 'N');
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_NODE_TYPE',
			'pErrorDetails', pPrivilege | ', ' | 'Consolidation',
			'pControl', pControl);
	
		ProcessError;
	EndIf;

	If (cNodeState @<> cWorkInProgress);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_STATE',
			'pErrorDetails', pPrivilege | ', ' | cNodeState,
			'pControl', pControl);
		
		ProcessError;
	Else;
		CellPutS(cNotStarted, cStateCube, pNode, cState);
		vStateChanged = 1;
	EndIf;
ElseIf (UPPER(pPrivilege) @= 'REJECT');

	If (cNodeParent @= '' & DTYPE(gApprovalDim, pNode) @<> 'N');
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_NO_REJECT_ON_TOP',
			'pErrorDetails', pPrivilege,
			'pControl', pControl);
		
		ProcessError;
	EndIf;

	If (cNodeParentState @= cLocked);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_PARENT_STATE',
			'pErrorDetails', pPrivilege | ', ' | cNodeParentState,
			'pControl', pControl);
		
		ProcessError;
	EndIf;

	If (cNodeState @<> cLocked);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_STATE',
			'pErrorDetails', pPrivilege | ', ' | cNodeState,
			'pControl', pControl);
		
		ProcessError;
	EndIf;

	If (DTYPE(gApprovalDim, pNode) @= 'N');
		CellPutS(cWorkInProgress, cStateCube, pNode, cState);
	Else;
		CellPutS(cReady, cStateCube, pNode, cState);
	EndIf;

	vStateChanged = 1;
ElseIf (UPPER(pPrivilege) @= 'SUBMIT');

	If (cNodeState @= cLocked);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_STATE',
			'pErrorDetails', pPrivilege | ', ' | cNodeState,
			'pControl', pControl);
		
		ProcessError;
	EndIf;

	If (DTYPE(gApprovalDim, pNode) @= 'N');
		CellPutS(cLocked, cStateCube, pNode, cState);
	Else;

		If (cNodeState @<> cReady);
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
				'pGuid', pExecutionId, 
				'pProcess', cTM1Process, 
				'pErrorCode', 'TI_WRONG_STATE',
				'pErrorDetails', pPrivilege | ', ' | cNodeState | ', ' | 'Consolidation',
				'pControl', pControl);
			
			ProcessError;
		EndIf;

		CellPutS(cLocked, cStateCube, pNode, cState);

	EndIf;

	vStateChanged = 1;
ElseIf (UPPER(pPrivilege) @= 'BOUNCE');

	If (DTYPE(gApprovalDim, pNode) @<> 'N');
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
			'pGuid', pExecutionId,
			'pProcess', cTM1Process,
			'pErrorCode', 'TI_WRONG_NODE_TYPE',
			'pErrorDetails', pPrivilege | ', ' | 'Consolidation',
			'pControl', pControl);
		
		ProcessError;
	EndIf;

	If ((cNodeState @= '') % (cNodeState @=cWorkInProgress ));
		CellPutS(cNotStarted, cStateCube, pNode, cState);
		vStateChanged = 1;
	
	Else;
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
			'pGuid', pExecutionId,
			'pProcess', cTM1Process,
			'pErrorCode', 'TI_WRONG_STATE',
			'pErrorDetails', pPrivilege | ', ' | cNodeState,
			'pControl', pControl);
		
		ProcessError;
	EndIf;
EndIf;

#*** If state is changed, set values.
If (vStateChanged = 1);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'State has been changed: ' | pNode);
	EndIf;

	cStateChangeUser = 'StateChangeUser';
	CellPutS(cDisplayUserName, cStateCube, pNode, cStateChangeUser);
	
	cStateChangeDate = 'StateChangeDate';
	CellPutS(pTime, cStateCube, pNode, cStateChangeDate);

EndIf;

#*** For top node, stop here.
If (cNodeParent @= '');
	vStateChanged = 0;
EndIf;

#*** No error
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
EndIf;

573,1

574,1

575,214


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



#*** Log File Name
cTM1Log = cEpilogLog;

#*** 
If (vStateChanged = 1);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Change parent state');
	EndIf;

	cApprovalDimSize = DIMSIZ(gApprovalDim);
	cApprovalSize = SubsetGetSize(gApprovalDim, gApprovalSubset);
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Subset size', gApprovalSubset, NumberToString(cApprovalSize));
	EndIf;

	If (UPPER(pPrivilege) @= 'EDIT');
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Privilege is EDIT');
		EndIf;

		vParent = pNode;
		vIndexI = 1;
		While (vIndexI <= cApprovalDimSize);

			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_parent_in_subset', 'pExecutionId', pExecutionId,
				'pDim', gApprovalDim, 'pSubset', gApprovalSubset, 'pNode', vParent);
			If (vReturnValue <> ProcessExitNormal());
				ProcessError;
			EndIf;

			vParent = gParentInSubset;

			If (vParent @= '');
				
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Loop stopped');
				EndIf;

				vIndexI = cApprovalDimSize + 1;
			EndIf;

			If (vIndexI <= cApprovalDimSize);

				vAllWorkInProgressOrLocked = 1;
				vIndexJ = 1;

				While (vIndexJ <= cApprovalSize);
				
					vElement = SubsetGetElementName(gApprovalDim, gApprovalSubset, vIndexJ);
				
					If (ELISPAR(gApprovalDim, vParent, vElement) = 1);
						
						vSiblingValue = CellGetS(cStateCube, vElement, cState);
						If (vSiblingValue @= cNotStarted % vSiblingValue @= cIncomplete);
							vAllWorkInProgressOrLocked = 0;
							vIndexJ = cApprovalSize;
						EndIf;

					EndIf;

					vIndexJ = vIndexJ + 1;
				End;

				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'State has been changed: ' | vParent);
				EndIf;

				If (vAllWorkInProgressOrLocked = 1);
					CellPutS(cWorkInProgress, cStateCube, vParent, cState);
					CellPutS(cDisplayUserName, cStateCube, vParent, cStateChangeUser);
					CellPutS(pTime, cStateCube, vParent, cStateChangeDate);
				Else;
					CellPutS(cIncomplete, cStateCube, vParent, cState);
					CellPutS(cDisplayUserName, cStateCube, vParent, cStateChangeUser);
					CellPutS(pTime, cStateCube, vParent, cStateChangeDate);
				EndIf;

			EndIf;

			vIndexI = vIndexI + 1;
		End;
	ElseIf ((UPPER(pPrivilege) @= 'BOUNCE') % (UPPER(pPrivilege) @= 'RELEASE'));
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Privilege is BOUNCE or RELEASE');
		EndIf;

		vParent = pNode;
		vIndexI = 1;
		While (vIndexI <= cApprovalDimSize);

			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_parent_in_subset', 'pExecutionId', pExecutionId,
				'pDim', gApprovalDim, 'pSubset', gApprovalSubset, 'pNode', vParent);
			If (vReturnValue <> ProcessExitNormal());
				ProcessError;
			EndIf;

			vParent = gParentInSubset;

			If (vParent @= '');
			
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Loop stopped');
				EndIf;

				vIndexI = cApprovalDimSize + 1;
			EndIf;

			If (vIndexI <= cApprovalDimSize);

				vAllNotStarted = 1;
				vIndexJ = 1;
				
				While (vIndexJ <= cApprovalSize);

					vElement = SubsetGetElementName(gApprovalDim, gApprovalSubset, vIndexJ);

					If (ELISPAR(gApprovalDim, vParent, vElement) = 1);
					
						vSiblingValue = CellGetS(cStateCube, vElement, cState);
						If (vSiblingValue @= cWorkInProgress % vSiblingValue @= cIncomplete % vSiblingValue @=cLocked % vSiblingValue @=cReady);
							vAllNotStarted= 0;
							vIndexJ = cApprovalSize;
						EndIf;

					EndIf;

					vIndexJ = vIndexJ + 1;
				End;

				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'State has been changed: ' | vParent);
				EndIf;

				If (vAllNotStarted = 1);
					CellPutS(cNotStarted, cStateCube, vParent, cState);
					CellPutS(cDisplayUserName, cStateCube, vParent, cStateChangeUser);
					CellPutS(pTime, cStateCube, vParent, cStateChangeDate);
				Else;
					CellPutS(cIncomplete, cStateCube, vParent, cState);
					CellPutS(cDisplayUserName, cStateCube, vParent, cStateChangeUser);
					CellPutS(pTime, cStateCube, vParent, cStateChangeDate);
				EndIf;

			EndIf;

			vIndexI = vIndexI + 1;
		End;
	ElseIf (UPPER(pPrivilege) @= 'REJECT');
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Privilege is REJECT');
		EndIf;

		If (cNodeParentState @= cReady);
			CellPutS(cWorkInProgress, cStateCube, cNodeParent, cState);
			CellPutS(cDisplayUserName, cStateCube, cNodeParent, cStateChangeUser);
			CellPutS(pTime, cStateCube, cNodeParent, cStateChangeDate);
		EndIf;
	ElseIf (UPPER(pPrivilege) @= 'SUBMIT');
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Privilege is SUBMIT');
		EndIf;

		vAllChildrenLocked = 1;
		vIndex = 1;
		
		While (vIndex <= cApprovalSize);

			vElement = SubsetGetElementName(gApprovalDim, gApprovalSubset, vIndex);
			
			If (ELISPAR(gApprovalDim, cNodeParent, vElement) = 1);
			
				vSiblingValue = CellGetS(cStateCube, vElement, cState);
				If (vSiblingValue @<> cLocked);
					vAllChildrenLocked = 0;
					vIndex = cApprovalSize;
				EndIf;
			
			EndIf;

			vIndex = vIndex + 1;
		End;

		If (vAllChildrenLocked = 1 & cNodeParent @<> '');
			CellPutS(cReady, cStateCube, cNodeParent, cState);
			CellPutS(cDisplayUserName, cStateCube, cNodeParent, cStateChangeUser);
			CellPutS(pTime, cStateCube, cNodeParent, cStateChangeDate);
		EndIf;
	EndIf;
EndIf;

#*** No error
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
EndIf;

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
