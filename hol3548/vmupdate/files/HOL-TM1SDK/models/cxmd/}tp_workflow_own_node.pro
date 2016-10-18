601,100
602,"}tp_workflow_own_node"
562,"NULL"
586,
585,
564,
565,"qoopAxxAYh;T20gFkaVi8[HS<0CKg=S=go7yMCL5<O64Sim4XeBsX?2i_TFP_UxPbeaCTD;te17:r=a44PbBn@:5V<nHw[nn0[BUCJ6mY1zxszK_A3GmP4[d1NtRnk6i_3sUWCFmT>VD=rlPbOX0CVlxA7TwGfVMB6JpF;pH<BJj4yqk6x<;rovtDG:juz_2`Rm=f1sI"
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
pNewOwnerID
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
pNewOwnerID,"None"
pControl,"N"
637,6
pExecutionId,
pTime,
pAppId,
pNode,
pNewOwnerID,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,423
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
cTM1Process = cControlPrefix | 'tp_workflow_own_node';
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

cDisplayUserName = ATTRS('}Clients', pNewOwnerID, '}TM1_DefaultDisplayValue');
If (cDisplayUserName @= '');
	cDisplayUserName = pNewOwnerID;
EndIf;
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'Current user is ' | cDisplayUserName);
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

#constant
cLocked = '4';
cWorkInProgress = '2';
cState = 'State';

cCurrentOwner = 'CurrentOwner';
cCurrentOwnerId = 'CurrentOwnerId';
cTakeOwnershipNode = 'TakeOwnershipNode';
cStateChangeUser = 'StateChangeUser';
cStateChangeDate = 'StateChangeDate';

#****

If (gApprovalDim @<> '');
	pNode = DimensionElementPrincipalName(gApprovalDim, pNode);
EndIf;

If (gApprovalDim @= '' % DTYPE(gApprovalDim, pNode) @='N');

	cStateValue = CellGetS(cStateCube, cStateMember, cState);
	vOwnerId = CellGetS(cStateCube, cStateMember, cCurrentOwnerId);

	If (pNewOwnerID @<> vOwnerId % cStateValue @<> cWorkInProgress);

		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Check node state');
		EndIf;

		If (cStateValue @= cLocked);
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
				'pGuid', pExecutionId, 
				'pProcess', cTM1Process, 
				'pErrorCode', 'TI_WRONG_STATE',
				'pErrorDetails', 'Own' | ', ' | pNode | ', ' | cStateValue,
				'pControl', pControl);
			
			ProcessError;
		EndIf;

		#*** 
		If (gApprovalDim @<> '');
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'Check user privilege');
			EndIf;
	
			StringGlobalVariable('gEdit');
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_user_permissions', 
				'pGuid', pExecutionId, 'pApplication', pAppId, 'pNode', pNode, 'pUser', pNewOwnerID, 'pControl', pControl);
			If (vReturnValue <> ProcessExitNormal());
				ProcessError;
			EndIf;
	
			If (gEdit @= 'F');
				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
					'pGuid', pExecutionId, 
					'pProcess', cTM1Process, 
					'pErrorCode', 'TI_NO_PERMISSION',
					'pErrorDetails', 'EDIT' | ', ' | pNode,
					'pControl', pControl);
				
				ProcessError;
			EndIf;
		EndIf;

		#***
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Get current ownerID and ownershipNode');
		EndIf;
		
		vOwnerIdToBounce = CellGetS(cStateCube, cStateMember, cCurrentOwnerId);
		vOwnershipNodeToBounce = CellGetS(cStateCube, cStateMember, cTakeOwnershipNode);
		
		If (gApprovalDim @= '' & vOwnerIdToBounce @<> '');
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'Bounce central owner ' | vOwnerIdToBounce);
			EndIf;
			
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_reserve_slice', 'pExecutionId', pExecutionId, 
					'pAppId', pAppId, 'pNode', pNode, 'pApprovalDim', gApprovalDim, 'pReserve', 'N', 'pUser', vOwnerIdToBounce, 'pControl', pControl);
			If (vReturnValue <> ProcessExitNormal());
				ProcessError;
			EndIf;
		EndIf;
		
		#***
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Reserve owner data slice');
		EndIf;

		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_reserve_slice', 'pExecutionId', pExecutionId, 
				'pAppId', pAppId, 'pNode', pNode, 'pApprovalDim', gApprovalDim, 'pReserve', 'Y', 'pUser', pNewOwnerID, 'pControl', pControl);
		If (vReturnValue <> ProcessExitNormal());
			ProcessError;
		EndIf;

		#*** 
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Set owner');
		EndIf;

		CellPutS(cDisplayUserName, cStateCube, cStateMember, cCurrentOwner);
		CellPutS(pNewOwnerID, cStateCube, cStateMember, cCurrentOwnerId);
		If (gApprovalDim @<> '');
			CellPutS(pNode, cStateCube, cStateMember, cTakeOwnershipNode);
		EndIf;

		#***
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Add being edited');
		EndIf;
		
		#If new owner is not the current user, then it is part of reject action that returns the ownership back
		#to original owner, don't set BeingEdited and StartEditingDate fields for that scenario
		IF (pNewOwnerId @=TM1User);
			cBeingEdited = 'BeingEdited';
			CellPutS('Y', cStateCube, cStateMember, cBeingEdited);

			cStartEditingDate = 'StartEditingDate';
			CellPutS(pTime, cStateCube, cStateMember, cStartEditingDate);
		EndIf;

		#***		
		If (gApprovalDim @= '');
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'Set state');
			EndIf;
			CellPutS(cWorkInProgress, cStateCube, cStateMember, cState);
			CellPutS(cDisplayUserName, cStateCube, cStateMember, cStateChangeUser);
			CellPutS(pTime, cStateCube, cStateMember, cStateChangeDate);
		ElseIf (cStateValue @<> cWorkInProgress);
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'Change state');
			EndIf;
			
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_change_node_state', 'pExecutionId', pExecutionId, 
				'pTime', pTime, 'pAppId', pAppId, 'pNode', pNode, 'pPrivilege', 'EDIT', 'pControl', pControl);
			If (vReturnValue <> ProcessExitNormal());
				ProcessError;
			EndIf;
		Else;
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'Update state change time');
			EndIf;
			CellPutS(pTime, cStateCube, cStateMember, cStateChangeDate);
		EndIf;
		
		If (gApprovalDim @<> '' & vOwnerIdToBounce @<> '' & vOwnershipNodeToBounce @<> '');
		
			#Don't bounce myself on the same leaf node
			If (vOwnerIdToBounce @= pNewOwnerId & vOwnershipNodeToBounce @= pNode);

			Else;
				# Bounce related nodes
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, 'Bounce related nodes');
				EndIf;

				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_bounce_nodes', 'pExecutionId', pExecutionId,'pAppId', pAppId,
					'pOwnerIdToBounce', vOwnerIdToBounce, 'pOwnershipNodeToBounce', vOwnershipNodeToBounce,'pSourceNode', pNode,
 					'pTime', pTime,'pCheckBouncingOnly', 'N','pBouncingMode', '',  'pControl', pControl);

				If (vReturnValue <> ProcessExitNormal());
					ProcessError;
				EndIf;
			EndIf;
		EndIf;
	EndIF;

# Take ownership on consolidation
Else;

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

		# leaf node, not the dummy node
		If (vLeafChild @<> pNode);

			#check permission
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'Check user privilege');
			EndIf;

			StringGlobalVariable('gEdit');
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_user_permissions',
			'pGuid', pExecutionId, 'pApplication', pAppId, 'pNode', vLeafChild, 'pUser', pNewOwnerID, 'pControl', pControl);
			If (vReturnValue <> ProcessExitNormal());
				ProcessError;
			EndIf;

			# must have EDIT privilege to take ownership
			If (gEdit @= 'T');
				cStateValue = CellGetS(cStateCube, vLeafChild, cState);

				# skip submitted node
				If (cStateValue @<> cLocked);
					
					#*****'
					If (cGenerateLog @= 'Y');
						TextOutput(cTM1Log, 'Get current owner and ownership node');
					EndIf;

					vOwnerIdToBounce = CellGetS(cStateCube, vLeafChild, cCurrentOwnerId);
					vOwnershipNodeToBounce = CellGetS(cStateCube,vLeafChild, cTakeOwnershipNode);

					If (vOwnerIdToBounce @<> pNewOwnerID % vOwnershipNodeToBounce @<>pNode);


						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, 'Set new owner');
						EndIf;

						CellPutS(cDisplayUserName, cStateCube, vLeafChild, cCurrentOwner);
						CellPutS(pNewOwnerID, cStateCube, vLeafChild, cCurrentOwnerId);
						CellPutS(pNode, cStateCube, vLeafChild, cTakeOwnershipNode);
						
						#***
						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, 'Add being edited');
						EndIf;
						
						#If new owner is not the current user, then it is part of reject action that returns the ownership back
						#to original owner, don't set BeingEdited and StartEditingDate fields for that scenario		
						IF (pNewOwnerId @=TM1User);
							cBeingEdited = 'BeingEdited';
							CellPutS('Y', cStateCube, vLeafChild, cBeingEdited);
						
							cStartEditingDate = 'StartEditingDate';
							CellPutS(pTime, cStateCube, vLeafChild, cStartEditingDate);
						Endif;
	
						#***
						If (cStateValue @<> cWorkInProgress);
							If (cGenerateLog @= 'Y');
								TextOutput(cTM1Log, 'Change state');
							EndIf;
	
							vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_change_node_state', 'pExecutionId', pExecutionId,
								'pTime', pTime, 'pAppId', pAppId, 'pNode', vLeafChild, 'pPrivilege', 'EDIT', 'pControl', pControl);
							If (vReturnValue <> ProcessExitNormal());
								ProcessError;
							EndIf;
						Else;
							If (cGenerateLog @= 'Y');
								TextOutput(cTM1Log, 'Update state change time');
							EndIf;
							CellPutS(pTime, cStateCube, vLeafChild, cStateChangeDate);
						EndIf;

						#***
						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, 'Bounce related nodes');
						EndIf;

						If (vOwnerIdToBounce @<> '' & vOwnershipNodeToBounce @<> '');

							vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_bounce_nodes', 'pExecutionId', pExecutionId,'pAppId', pAppId,
								'pOwnerIdToBounce', vOwnerIdToBounce, 'pOwnershipNodeToBounce', vOwnershipNodeToBounce,
								'pSourceNode', pNode, 'pTime', pTime, 'pCheckBouncingOnly', 'N','pBouncingMode', '', 'pControl', pControl);
								
							If (vReturnValue <> ProcessExitNormal());
								ProcessError;
							EndIf;
						EndIf;
					EndIf;
				EndIf;
			EndIF;
		EndIf;
	
		looper = looper -1;
	End;
	
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Update consolidated node state change time');
	EndIf;
	CellPutS(pTime, cStateCube, pNode, cStateChangeDate);

	#****
	
	# At last, take care of the consolidated nodes in the package

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_reserve_slice', 'pExecutionId', pExecutionId, 
	'pAppId', pAppId, 'pNode', pNode, 'pApprovalDim', gApprovalDim, 'pReserve', 'Y', 'pUser', pNewOwnerID, 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
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
