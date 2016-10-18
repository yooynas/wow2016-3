601,100
602,"}tp_update_ownership"
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
560,3
pGuid
pAppId
pControl
561,3
2
2
2
590,3
pGuid,"None"
pAppId,"MyApp"
pControl,"N"
637,3
pGuid,
pAppId,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,368


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
cTM1Process = cControlPrefix | 'tp_update_ownership';
StringGlobalVariable('gPrologLog');
StringGlobalVariable('gEpilogLog');
vReturnValue = ExecuteProcess( cControlPrefix | 'tp_get_log_file_names', 'pExecutionId', pGuid,
'pProcess', cTM1Process, 'pControl', pControl);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;
cPrologLog = gPrologLog;
cEpilogLog = gEpilogLog;
cTM1Log = cPrologLog;

cGenerateLog = ATTRS(cControlPrefix | 'tp_config', 'Generate TI Log', 'String Value');

#*** Get lock

#cLockName = 'tp_semaphore';
#Synchronized( cLockName ) ;

#***
CubeLockOverride(1);

#*** Log Parameters
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:', pGuid, pAppId,  pControl);
EndIf;

#*** Check application

cApplicationsDim = cControlPrefix |  'tp_applications';

If (DimensionExists(cApplicationsDim) = 0);
	ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pGuid, 
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_DIM_NOT_EXIST',
		'pErrorDetails', cApplicationsDim, 
		'pControl', pControl);
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, cApplicationsDim | ' does not exist.');
	EndIf;
	ProcessError;
EndIf;

If (DIMIX(cApplicationsDim, pAppId) = 0);
	ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pGuid, 
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_NODE_NOT_EXIST',
		'pErrorDetails', pAppId, 
		'pControl', pControl);
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, pAppId | ' does not exist.');
	EndIf;
	ProcessError;
EndIf;

#*** Check State cube
vStateCube = cControlPrefix | 'tp_application_state}' | pAppId;
vNodeInfoDim = cControlPrefix | 'tp_node_info';

If (CubeExists(vStateCube) = 0);
	ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pGuid, 
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_CUBE_NOT_EXIST',
		'pErrorDetails', vStateCube, 
		'pControl', pControl);
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Cube ' | vStateCube | ' does not exist.');
	EndIf;
	ProcessError;
EndIf;

#* Check permission cube
cPermissionCube = cControlPrefix | 'tp_application_permission}' | pAppId;
cCellSecurityCube = '}CellSecurity_' | cPermissionCube;

If (CubeExists(cPermissionCube) = 0);
	ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pGuid, 
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_CUBE_NOT_EXIST',
		'pErrorDetails', cPermissionCube, 
		'pControl', pControl);
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Cube ' | cPermissionCube | ' does not exist.');
	EndIf;
	ProcessError;
EndIf;

If (CubeExists(cCellSecurityCube) = 0);
	ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pGuid, 
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_CUBE_NOT_EXIST',
		'pErrorDetails', cCellSecurityCube, 
		'pControl', pControl);
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Cube ' | cCellSecurityCube | ' does not exist.');
	EndIf;
	ProcessError;
EndIf;

#* Get Approval dimension and subset

#*** declare global variables
StringGlobalVariable('gApprovalDim');
StringGlobalVariable('gApprovalSubset');

vReturnValue = ExecuteProcess( cControlPrefix | 'tp_get_application_attributes', 'pExecutionId', pGuid,
	'pAppId', pAppId, 'pControl',  pControl);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;

cApprovalDim = gApprovalDim;
cApprovalSubset = gApprovalSubset;

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'Approval Dimension: ' | cApprovalDim);
	TextOutput(cTM1Log, 'Approval Subset: ' | cApprovalSubset);
EndIf;

vSubset = 'currentOwner_' | pGuid;

IF (SubsetExists(cApprovalDim, vSubset) =1);
	SubsetDestroy(cApprovalDim, vSubset);
ENDIF;

vDummyNode = DIMNM(cApprovalDim, 1);
#If a mdx returns zero item, SubsetCreateByMdx will throw an error, add the first element as a dummy member
vMDX = '{ FILTER ( [' | cApprovalDim | '].Members, [' | vStateCube | '].( [' | vNodeInfoDim | '].[CurrentOwner] ) <> "" ), [' | cApprovalDim | '].['
	| vDummyNode | ']} ';
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'Mdx to get nodes with current owner: ' | vMDX);
EndIf;
subsetCreateByMdx(vSubset, vMDX);
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_util_convert_dynamic_subset_to_static', 'pExecutionId', pGuid,
'pDim', cApprovalDim, 'pSubset', vSubset);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;

vSubsetSize = SubsetGetSize(cApprovalDim, vSubset);
looper =vSubsetSize;
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'subset Size: ' | NumberToString(vSubsetSize));
EndIf;

vConsolidationOwnershipNodeDim = 'tp_temp_consolidation_ownership_node_' | pGuid;
vConsolidationOwnershipIdDim = 'tp_temp_consolidation_ownership_id_' | pGuid;

vDummyCount =0;
WHILE (looper >=1);
	vOwner = '';
	vNode = '';
	vNode = SubsetGetElementName (cApprovalDim, vSubset, looper);
	
	#***Need to take care of dummy member
	
	IF (vNode @= vDummyNode);
		vDummyCount = vDummyCount +1;
		#***If dummy node shows up more than once, it is also a real one
		IF (vDummyCount >1);
			vOwner = CellGetS(vStateCube, vNode, 'CurrentOwner');
			vCurrentOwnerId = CellGetS(vStateCube, vNode, 'CurrentOwnerId');
		ENDIf;
	
	ELSE;
		vOwner = CellGetS(vStateCube, vNode, 'CurrentOwner');
		vCurrentOwnerId = CellGetS(vStateCube, vNode, 'CurrentOwnerId');
	ENDIF;
	
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'node: ' | vNode);
		TextOutput(cTM1Log, 'Current Owner: ' | vOwner);
	ENDIF;
	
	IF (DIMIX('}Clients', vOwner) = 0);
		#***Node owner doesn't exist in }Clients dimension any more
		#***Reset currentOwner field,
		#***we need a separate TI to take care of ownership whose owner has been deleted
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Current Owner: ' | vOwner | ' does not exist.');
			TextOutput(cTM1Log, 'The current owner field for node ' | vNode | ' get reset.');
		ENDIF;
		If (CellIsUpdateable(vStateCube, vNode, 'State') = 0);
			vDetail=INSRT('State',')',1);
			vDetail=INSRT(',',vDetail,1);
			vDetail=INSRT(vNode,vDetail,1);
			vDetail=INSRT('(',vDetail,1);
			vDetail=INSRT(vStateCube,vDetail,1);
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pGuid, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_APPLICATION_NOT_UPDATEABLE',
			'pErrorDetails', vDetail,
			'pControl', pControl);
			ProcessError;
		EndIf;
		CellPutS('', vStateCube, vNode, 'CurrentOwner');
		
		If (CellIsUpdateable(vStateCube, vNode, 'CurrentOwnerId') = 0);
			vDetail=INSRT('CurrentOwnerId',')',1);
			vDetail=INSRT(',',vDetail,1);
			vDetail=INSRT(vNode,vDetail,1);
			vDetail=INSRT('(',vDetail,1);
			vDetail=INSRT(vStateCube,vDetail,1);
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pGuid, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_APPLICATION_NOT_UPDATEABLE',
			'pErrorDetails', vDetail,
			'pControl', pControl);
			ProcessError;
		EndIf;
		CellPutS('', vStateCube, vNode, 'CurrentOwnerId');
	
	ElseIf (DTYPE(cApprovalDim, vNode) @= 'N');
	
		#***If leaf node: need to revoke ownership as well as clear currentOwer in state cube
	
		StringGlobalVariable('gEdit');
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_user_permissions',
			'pGuid', pGuid, 'pApplication', pAppId, 'pNode', vNode, 'pUser', vOwner, 'pControl', pControl);
		If (vReturnValue <> ProcessExitNormal());
			ProcessError;
		EndIf;
	
		If (gEdit @= 'F');
	
			#*** Clear Reservation approval node slice using TM1 data reservation
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_reserve_slice', 'pExecutionId', pGuid, 
				'pAppId', pAppId, 'pNode', vNode, 'pApprovalDim', cApprovalDim, 'pReserve', 'N', 'pUser', vCurrentOwnerId, 'pControl', pControl);
				
			If (vReturnValue <> ProcessExitNormal());
				ProcessError;
			EndIf;
			If (CellIsUpdateable(vStateCube, vNode, 'CurrentOwner') = 0);
				vDetail=INSRT('CurrentOwner',')',1);
				vDetail=INSRT(',',vDetail,1);
				vDetail=INSRT(vNode,vDetail,1);
				vDetail=INSRT('(',vDetail,1);
				vDetail=INSRT(vStateCube,vDetail,1);
				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
				'pGuid', pGuid, 
				'pProcess', cTM1Process, 
				'pErrorCode', 'TI_APPLICATION_NOT_UPDATEABLE',
				'pErrorDetails', vDetail,
				'pControl', pControl);
				ProcessError;
			EndIf;
			CellPutS('', vStateCube, vNode, 'CurrentOwner');
			
			If (CellIsUpdateable(vStateCube, vNode, 'CurrentOwnerId') = 0);
				vDetail=INSRT('CurrentOwnerId',')',1);
				vDetail=INSRT(',',vDetail,1);
				vDetail=INSRT(vNode,vDetail,1);
				vDetail=INSRT('(',vDetail,1);
				vDetail=INSRT(vStateCube,vDetail,1);
				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
				'pGuid', pGuid, 
				'pProcess', cTM1Process, 
				'pErrorCode', 'TI_APPLICATION_NOT_UPDATEABLE',
				'pErrorDetails', vDetail,
				'pControl', pControl);
				ProcessError;
			EndIf;
			CellPutS('', vStateCube, vNode, 'CurrentOwnerId');
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'No edit permission. The ownership of ' | vNode | ' is revoked from user ' | vOwner);
				TextOutput(cTM1Log, 'The current owner field for node ' | vNode | ' get reset.');
			ENDIF;

			# Put TakeOwnershipNode in temp dimension
			vTakeOwnershipNode = CellGetS(vStateCube, vNode, 'TakeOwnershipNode');
			If (CellIsUpdateable(vStateCube, vNode, 'TakeOwnershipNode') = 0);
				vDetail=INSRT('TakeOwnershipNode',')',1);
				vDetail=INSRT(',',vDetail,1);
				vDetail=INSRT(vNode,vDetail,1);
				vDetail=INSRT('(',vDetail,1);
				vDetail=INSRT(vStateCube,vDetail,1);
				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
				'pGuid', pGuid, 
				'pProcess', cTM1Process, 
				'pErrorCode', 'TI_APPLICATION_NOT_UPDATEABLE',
				'pErrorDetails', vDetail,
				'pControl', pControl);
				ProcessError;
			EndIf;
			CellPutS('', vStateCube, vNode, 'TakeOwnershipNode');
			If (vTakeOwnershipNode @<> vNode);
				If (DTYPE(cApprovalDim, vTakeOwnershipNode) @<> 'C');
					ProcessError;
				EndIf;
				If (DimensionExists(vConsolidationOwnershipNodeDim) = 0);
					DimensionCreate(vConsolidationOwnershipNodeDim);
					DimensionCreate(vConsolidationOwnershipIdDim);
				EndIf;
				If (DIMIX(vConsolidationOwnershipNodeDim, vTakeOwnershipNode) = 0 & vCurrentOwnerId @<> '');
					DimensionElementInsert(vConsolidationOwnershipNodeDim, '', vTakeOwnershipNode, 'S');
					DimensionElementInsert(vConsolidationOwnershipIdDim, '', vTakeOwnershipNode | '}' | vCurrentOwnerId, 'S');
				EndIf;
			EndIf;

		EndIf;
	
	Else;
	
	#***If consolidated node: clear currentOwer in state cube
	StringGlobalVariable('gSubmit');
	vReturnValue = ExecuteProcess('tp_get_user_permissions',
		'pGuid', pGuid, 'pApplication', pAppId, 'pNode', vNode, 'pUser', vOwner, 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
	
	If (gSubmit @= 'F');
		CellPutS('', vStateCube, vNode, 'CurrentOwner');
		CellPutS('', vStateCube, vNode, 'CurrentOwnerId');
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'No submit permission for owner ' | vOwner);
			TextOutput(cTM1Log, 'The current owner field for node ' | vNode | ' get reset.');
		ENDIF;
	EndIf;
	
	EndIf;
	
	looper = looper -1 ;

END;

#***
CubeLockOverride(0);

#*** No error

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
EndIf;


573,1

574,1

575,38
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

If (SubsetExists(cApprovalDim, vSubset) =1);
	SubsetDestroy(cApprovalDim, vSubset);
EndIf;

If (DimensionExists(vConsolidationOwnershipNodeDim) = 1);
	DimensionDestroy(vConsolidationOwnershipNodeDim);
EndIf;

If (DimensionExists(vConsolidationOwnershipIdDim) = 1);
	DimensionDestroy(vConsolidationOwnershipIdDim);
EndIf;

#*** No error
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'The end has been reached.');
EndIf;


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
