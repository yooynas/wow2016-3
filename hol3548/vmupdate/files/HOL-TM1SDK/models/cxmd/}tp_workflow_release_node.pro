601,100
602,"}tp_workflow_release_node"
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
572,302
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
cTM1Process = cControlPrefix | 'tp_workflow_release_node';
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

#***

cDisplayUserName = ATTRS('}Clients', TM1User, '}TM1_DefaultDisplayValue');
If (cDisplayUserName @= '');
	cDisplayUserName = TM1User;
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

if (gApprovalDim @= '');
	cStateCube = cControlPrefix | 'tp_central_application_state';
	cStateMember = pAppId;
Else;

	#* Check node
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Check node: ' | pNode);
	EndIf;
	If (DIMIX(gApprovalDim, pNode) = 0);
		ProcessError;
	EndIf;
	
	cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;
	cStateMember = pNode;
EndIf;

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'Check state cube: ' | cStateCube);
EndIf;

If (CubeExists(cStateCube) = 0);
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_CUBE_NOT_EXIST',
		'pErrorDetails', cStateCube,
		'pControl', pControl);
	
	ProcessError;
EndIf;

#*** 

#constant
cLocked = '4';
cNotStarted = '0';
cWorkInProgress = '2';
cState = 'State';

cCurrentOwner = 'CurrentOwner';
cCurrentOwnerId = 'CurrentOwnerId';
cTakeOwnershipNode = 'TakeOwnershipNode';
cBeingEdited = 'BeingEdited';
cStateChangeUser = 'StateChangeUser';
cStateChangeDate = 'StateChangeDate';

#****
If (gApprovalDim @<> '');
	pNode = DimensionElementPrincipalName(gApprovalDim, pNode);
EndIf;

# If at the leaf level
If (gApprovalDim @= '' % DTYPE(gApprovalDim, pNode) @='N');

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Check node state');
	EndIf;
	vStateValue = CellGetS(cStateCube, cStateMember, cState);

	If (vStateValue @<> cWorkInProgress);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_STATE',
			'pErrorDetails', 'Own' | ', ' | pNode | ', ' | vStateValue,
			'pControl', pControl);
		
		ProcessError;
	EndIf;

	#***
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Get current ownerID and ownershipNode');
	EndIf;
	
	vCurrentOwner = CellGetS(cStateCube, cStateMember, cCurrentOwner);
	vCurrentOwnerId = CellGetS(cStateCube, cStateMember, cCurrentOwnerId);
	vOwnershipNode = CellGetS(cStateCube, cStateMember, cTakeOwnershipNode);
	
	If (TM1User @<> vCurrentOwnerId);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_OWNER',
			'pErrorDetails', 'Save' | ', ' | pNode | ', ' | vCurrentOwner,
			'pControl', pControl);
		
		ProcessError;
	EndIf;
	
	If (gApprovalDim @<> '' & pNode @<> vOwnershipNode);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_OWNER',
			'pErrorDetails', 'Save' | ', ' | pNode | ', ' | vCurrentOwner,
			'pControl', pControl);
		
		ProcessError;
	EndIf;
		
	#***
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Release owner data slice');
	EndIf;

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_reserve_slice', 'pExecutionId', pExecutionId, 
			'pAppId', pAppId, 'pNode', pNode, 'pApprovalDim', gApprovalDim, 'pReserve', 'N', 'pUser', TM1User, 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;

	#*** 
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Clear ownership fields');
	EndIf;

	CellPutS('', cStateCube, cStateMember, cCurrentOwner);
	CellPutS('', cStateCube, cStateMember, cCurrentOwnerId);
	CellPutS('', cStateCube, cStateMember, cTakeOwnershipNode);
	CellPutS('N', cStateCube, cStateMember, cBeingEdited);
	
	If (gApprovalDim @= '');
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Set state');
		EndIf;
		CellPutS(cNotStarted, cStateCube, cStateMember, cState);
		CellPutS(cDisplayUserName, cStateCube, cStateMember, cStateChangeUser);
		CellPutS(pTime, cStateCube, cStateMember, cStateChangeDate);
	Else;
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Change state');
		EndIf;
	
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_change_node_state', 'pExecutionId', pExecutionId, 
			'pTime', pTime, 'pAppId', pAppId, 'pNode', pNode, 'pPrivilege', 'RELEASE', 'pControl', pControl);
		If (vReturnValue <> ProcessExitNormal());
			ProcessError;
		EndIf;
	EndIf;

# Else at a consolidation
Else;

	#remove DR on consolidated node
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_reserve_slice', 'pExecutionId', pExecutionId, 
		'pAppId', pAppId, 'pNode', pNode, 'pApprovalDim', gApprovalDim, 'pReserve', 'N', 'pUser', TM1User, 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;

	# Take care of the leaf nodes in the package
	vMDX = '{INTERSECT(TM1FILTERBYLEVEL({DESCENDANTS([' | gApprovalDim | '].[' | pNode | ']) }, 0), TM1SUBSETTOSET([' | gApprovalDim | '],"' | gApprovalSubset | '")), ['
		| gApprovalDim | '].[' | pNode | ']}';
	vSubsetLeafChildren = 'takeOwnership_onConsolidation_' | pExecutionId;
	If (SubsetExists(gApprovalDim, vSubsetLeafChildren) <>0);
		SubsetDestroy(gApprovalDim, vSubsetLeafChildren);
	EndIf;
	SubsetCreateByMdx(vSubsetLeafChildren, vMDX);
	SubsetElementInsert(gApprovalDim, vSubsetLeafChildren, pNode, 0);
	vSize = SubsetGetSize(gApprovalDim, vSubsetLeafChildren);

	looper = vSize;
	While (looper >=1);
		vLeafChild = SubsetGetElementName(gApprovalDim, vSubsetLeafChildren, looper);

		#leaf node, not the dummy node
		IF (vLeafChild @<> pNode);

			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'Check status for leaf node: ' | vLeafChild);
			EndIf;
			vStateValue = CellGetS(cStateCube, vLeafChild, cState);
			vCurrentOwnerId = CellGetS(cStateCube, vLeafChild, cCurrentOwnerId);
			vOwnershipNode = CellGetS(cStateCube, vLeafChild, cTakeOwnershipNode);
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'Status for leaf node: ' | vLeafChild | ' State=' | vStateValue | ' OwnerId=' | vCurrentOwnerId | ' OwnershipNode=' | vOwnershipNode);
			EndIf;

			# If the current user is the owner of this node take at the consolidation we can release it
			If ((vStateValue @= cWorkInProgress) & (TM1User @= vCurrentOwnerId) & (pNode @= vOwnershipNode));


				#*** 
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, 'Clear leaf node ownership fields');
				EndIf;
			
				CellPutS('', cStateCube, vLeafChild, cCurrentOwner);
				CellPutS('', cStateCube, vLeafChild, cCurrentOwnerId);
				CellPutS('', cStateCube, vLeafChild, cTakeOwnershipNode);
				CellPutS('N', cStateCube, vLeafChild, cBeingEdited);
						
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, 'Change leaf node state');
				EndIf;
				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_change_node_state', 'pExecutionId', pExecutionId, 
					'pTime', pTime, 'pAppId', pAppId, 'pNode', vLeafChild, 'pPrivilege', 'RELEASE', 'pControl', pControl);
				If (vReturnValue <> ProcessExitNormal());
					ProcessError;
				EndIf;
			EndIF;
		EndIf;
	
		looper = looper -1;
	End;
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Finished checking for leaf nodes');
	EndIf;
	
EndIf;

573,1

574,1

575,20


#################################################################
## IBM Confidential
##
## OCO Source Materials
##
## BI and PM: pmpsvc
##
## (C) Copyright IBM Corp. 2008, 2009
##
## The source code for this program is not published or otherwise
## divested of its trade secrets, irrespective of what has been
## deposited with the U.S. Copyright Office.
#################################################################


IF (SubsetExists(gApprovalDim, vSubsetLeafChildren) <>0);
	SubsetDestroy(gApprovalDim, vSubsetLeafChildren);
ENDIF;
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
