601,100
602,"}tp_create_planning_artifacts"
562,"NULL"
586,
585,
564,
565,"m6wXV`x6xAvvma2TH42nlSC9AI``k82ARF^XM=<cd]]l1;xznpDztG7_W?7vYbX1]M[y1OTUPotisEorvFX3gi:xKY;jyO2Q0Yn8p[SG5G:hlL2FXPOxw7jE^aSyNgRGGDIfchO0Q5ykr0Cn\VngfcN>E9:ZsBQybwmuk@izkutbFfws13;KF6\UETBhlV1udRM;EtuT"
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
560,2
pExecutionId
pControl
561,2
2
2
590,2
pExecutionId,"None"
pControl,"N"
637,2
pExecutionId,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,338


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

#*** lock

#cLockName = 'tp_semaphore';
#Synchronized( cLockName ) ;

#*** Create "everyone" group

cSystemConfigDim = cControlPrefix | 'tp_system_config';
If (DimensionExists(cSystemConfigDim) = 0);
	ProcessError;
EndIf;

cSecurityModeNode = 'IntegratedSecurityMode';
cConfigValueAttr = 'ConfigValue';
vSecurityMode = ATTRS(cSystemConfigDim, cSecurityModeNode, cConfigValueAttr);

cCognosEveryoneGroup = 'CAMID("::Everyone")';
cTpEveryoneGroup = cControlPrefix | 'tp_Everyone';
If (vSecurityMode @= '5');

	If (DIMIX('}Groups', cCognosEveryoneGroup) = 0);
		ProcessError;
	EndIf;

	If (DIMIX('}Groups', cTpEveryoneGroup) <> 0);
		DeleteGroup(cTpEveryoneGroup);
	EndIf;

	cEveryoneGroup = cCognosEveryoneGroup;

Else;

	cEveryoneGroup = cTpEveryoneGroup;

	If (DIMIX('}Groups', cEveryoneGroup) = 0);
		AddGroup(cEveryoneGroup);
	EndIf;

EndIf;


#***create error log objects
cErrorCube = cControlPrefix | 'tp_process_errors';
If (CubeExists(cErrorCube) = 0);
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_setup', 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
EndIf;

#*** Log File Name
cTM1Process = cControlPrefix | 'tp_create_planning_artifacts';
StringGlobalVariable('gPrologLog');
StringGlobalVariable('gEpilogLog');
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_log_file_names',
	'pExecutionId', pExecutionId, 'pProcess', cTM1Process, 'pControl', pControl);
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
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:', pExecutionId, pControl);
EndIf;

cTpPrefix = cControlPrefix | 'tp_';
cTpPrefixLength = LONG(cTpPrefix);

#***

cApplicationsDim = cControlPrefix | 'tp_applications';

cApprovalDimensionAttr = 'ApprovalDimension';
cApprovalSubsetAttr = 'ApprovalSubset';
cIsActiveAttr = 'IsActive';
cStoreIdAttr = 'StoreId';
cSecuritySetAttr = 'SecuritySet';
cVersionAttr = 'Version';
cCubeViewsAttr = 'CubeViews';

If (DimensionExists(cApplicationsDim) = 0);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Create applications dimension');
	EndIf;

	DimensionCreate(cApplicationsDim);
	AttrInsert(cApplicationsDim, '', cApprovalDimensionAttr, 'S');
	AttrInsert(cApplicationsDim, '', cApprovalSubsetAttr, 'S');
	AttrInsert(cApplicationsDim, '', cIsActiveAttr, 'S');
	AttrInsert(cApplicationsDim, '', cStoreIdAttr, 'S');
	AttrInsert(cApplicationsDim, '', cSecuritySetAttr, 'S');
	AttrInsert(cApplicationsDim, '', cVersionAttr, 'S');
	AttrInsert(cApplicationsDim, '', cCubeViewsAttr, 'S');
	SubsetCreate(cApplicationsDim, 'Default');
	SubsetIsAllSet(cApplicationsDim, 'Default', 1);
Else;
	# fix tp_applications when upgraded from 9.5.2 server data.
	cAppAttrDim = '}ElementAttributes_' | cApplicationsDim;

	If (DIMIX(cAppAttrDim, cVersionAttr) = 0);
		AttrInsert(cApplicationsDim, '', cVersionAttr, 'S');
	EndIf;
	If (DIMIX(cAppAttrDim, cCubeViewsAttr) = 0);
		AttrInsert(cApplicationsDim, '', cCubeViewsAttr, 'S');
	EndIf;
EndIf;

#***

cElementSecurityApplicationsCube = '}ElementSecurity_' | cApplicationsDim;

sGroupsDim = '}Groups';

If (CubeExists(cElementSecurityApplicationsCube) = 0);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Create applications element security cube');
	EndIf;

	CubeCreate(cElementSecurityApplicationsCube, cApplicationsDim, sGroupsDim);
	CubeSetLogChanges(cElementSecurityApplicationsCube, 1);

EndIf;

#***

cElementAttributesApplicaitonsDim = '}ElementAttributes_' | cApplicationsDim;
cElementAttributesApplicaitonsCube = cElementAttributesApplicaitonsDim;
If (DimensionExists(cElementAttributesApplicaitonsDim) = 0);
    ProcessError;
EndIf;

If (CubeExists(cElementAttributesApplicaitonsCube) = 0);

    If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Create applications element attributes cube');
	EndIf;
      
    CubeCreate(cElementAttributesApplicaitonsCube, cApplicationsDim, cElementAttributesApplicaitonsDim);
	CubeSetLogChanges(cElementAttributesApplicaitonsCube, 1);
EndIf;

#***

cPermissionsDim = cControlPrefix | 'tp_permissions';

cView = 'VIEW';
cAnnotate = 'ANNOTATE';
cEdit = 'EDIT';
cReject = 'REJECT';
cSubmit = 'SUBMIT';

If (DimensionExists(cPermissionsDim) = 0);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Create permissions dimension');
	EndIf;

	DimensionCreate(cPermissionsDim);
	
	DimensionElementInsert(cPermissionsDim, '',cView,'S');
	DimensionElementInsert(cPermissionsDim, '',cAnnotate,'S');
	DimensionElementInsert(cPermissionsDim, '',cEdit,'S');
	DimensionElementInsert(cPermissionsDim, '',cReject,'S');
	DimensionElementInsert(cPermissionsDim, '',cSubmit,'S');
	
	SubsetCreate(cPermissionsDim, 'Default');
	SubsetIsAllSet(cPermissionsDim, 'Default', 1);

EndIf;

#***

cNodeInfoDim = cControlPrefix | 'tp_node_info';

cState = 'State';
cViewed = 'Viewed';
cSaved = 'Saved';
cReviewed = 'Reviewed';
cBeingEdited = 'BeingEdited';
cCurrentOwner = 'CurrentOwner';
cCurrentOwnerId = 'CurrentOwnerId';
cTakeOwnershipNode = 'TakeOwnershipNode';
cStartEditingDate = 'StartEditingDate';
cStateChangeUser = 'StateChangeUser';
cStateChangeDate = 'StateChangeDate';
cDataChangeUser = 'DataChangeUser';
cDataChangeDate = 'DataChangeDate';

If (DimensionExists(cNodeInfoDim) = 0);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Create node info dimension');
	EndIf;

	DimensionCreate(cNodeInfoDim);
	
	DimensionElementInsert(cNodeInfoDim, '', cState, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cViewed, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cSaved, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cReviewed, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cBeingEdited, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cCurrentOwner, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cCurrentOwnerId, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cTakeOwnershipNode, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cStartEditingDate, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cStateChangeUser, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cStateChangeDate, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cDataChangeUser, 'S');
	DimensionElementInsert(cNodeInfoDim, '', cDataChangeDate, 'S');
Else;
	# fix tp_node_info when upgraded from 9.5.2 server data.
	cTakeOwnershipNode = 'TakeOwnershipNode';
	cStartEditingDate = 'StartEditingDate';
	If (DIMIX(cNodeInfoDim, cTakeOwnershipNode) = 0);
		DimensionElementInsert(cNodeInfoDim, cStartEditingDate, cTakeOwnershipNode, 'S');
	EndIf;
	
	cAnnotationChangeUser = 'AnnotationChangeUser';
	cAnnotationChangeDate = 'AnnotationChangeDate';
	If (DIMIX(cNodeInfoDim, cAnnotationChangeUser) <> 0);
		DimensionElementDelete(cNodeInfoDim, cAnnotationChangeUser);
	EndIf;
	
	If (DIMIX(cNodeInfoDim, cAnnotationChangeDate) <> 0);
		DimensionElementDelete(cNodeInfoDim, cAnnotationChangeDate);
	EndIf;
EndIf;



#*** Create subset for dimension }Groups

cTpDefaultSubset = 'tp_default';
If (SubsetExists('}Groups', cTpDefaultSubset) = 0);
	SubsetCreate('}Groups', cTpDefaultSubset);
	SubsetIsAllSet('}Groups', cTpDefaultSubset, 1);
	SubsetAliasSet('}Groups', cTpDefaultSubset, '}TM1_DefaultDisplayValue');
EndIf;

#*** create applicationCubes cube

cApplicationCubesCube = cControlPrefix | 'tp_application_cubes';

sCubesDim = '}Cubes';

If (CubeExists(cApplicationCubesCube) = 0);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Create application cubes cube');
	EndIf;

	CubeCreate(cApplicationCubesCube, cApplicationsDim, sCubesDim);
	CubeSetLogChanges(cApplicationCubesCube, 1);

EndIf;

#*** create cube to store state of central applications 

cCentralApplicationStateCube = cControlPrefix | 'tp_central_application_state';
If (CubeExists(cCentralApplicationStateCube) = 0);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Create central application state cube');
	EndIf;

	CubeCreate(cCentralApplicationStateCube, cApplicationsDim, cNodeInfoDim);
	CubeSetLogChanges(cCentralApplicationStateCube, 1);

EndIf;


#Grant DataReservation capabilities to the tp_everyone group

cCapabilityCube = '}Capabilities';

cCognosEveryoneGroup = 'CAMID("::Everyone")';
cTpEveryoneGroup = cControlPrefix | 'tp_Everyone';
If (vSecurityMode @= '5');

	If (DIMIX('}Groups', cCognosEveryoneGroup) = 0);
		ProcessError;
	EndIf;
	CellPutS('Grant', cCapabilityCube, 'ManageDataReservation', 'EXECUTE', cCognosEveryoneGroup);
	CellPutS('Grant', cCapabilityCube, 'DataReservationOverride', 'EXECUTE', cCognosEveryoneGroup);
Else;
	If (DIMIX('}Groups', cTpEveryoneGroup) = 0);
		ProcessError;
	EndIf;
	CellPutS('Grant', cCapabilityCube, 'ManageDataReservation', 'EXECUTE', cTpEveryoneGroup);
	CellPutS('Grant', cCapabilityCube, 'DataReservationOverride', 'EXECUTE', cTpEveryoneGroup);
EndIf;

#***


#*** No error

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'The end has been reached.');
EndIf;


573,1

574,1

575,554


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

#*** Check security cubes

sDimensionsDim = '}Dimensions';
sDimensionSecurityCube = '}DimensionSecurity';
If (CubeExists(sDimensionSecurityCube) = 0);

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Create }DimensionSecurity');
EndIf;

CubeCreate(sDimensionSecurityCube, sDimensionsDim, sGroupsDim);
CubeSetLogChanges(sDimensionSecurityCube, 1);
EndIf;

cCurrentCellValue = CellGetS(sDimensionSecurityCube, '}Groups', cEveryoneGroup); 
If ( cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sDimensionSecurityCube, '}Groups', cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT('((}Groups,',vDetail,1);
		vDetail=INSRT(sDimensionSecurityCube,vDetail,1);
		vDetail=INSRT(CellGetS(sDimensionSecurityCube, '}Groups', cEveryoneGroup),vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sDimensionSecurityCube, '}Groups', cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sDimensionSecurityCube, '}ElementAttributes_}Groups', cEveryoneGroup); 
If ( cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sDimensionSecurityCube, '}ElementAttributes_}Groups', cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT('((}ElementAttributes_}Groups,',vDetail,1);
		vDetail=INSRT(sDimensionSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sDimensionSecurityCube, '}ElementAttributes_}Groups', cEveryoneGroup);
EndIf;


sCubesDim = '}Cubes';
sCubeSecurityCube = '}CubeSecurity';
If (CubeExists(sCubeSecurityCube) = 0);

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Create }CubeSecurity');
EndIf;

CubeCreate(sCubeSecurityCube, sCubesDim, sGroupsDim);
CubeSetLogChanges(sCubeSecurityCube, 1);
EndIf;

CellPutS('Read', sCubeSecurityCube, '}ElementAttributes_}Groups', cEveryoneGroup);

sProcessesDim = '}Processes';
sProcessSecurityCube = '}ProcessSecurity';
If (CubeExists(sProcessSecurityCube) = 0);

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Create }ProcessSecurity');
EndIf;

CubeCreate(sProcessSecurityCube, sProcessesDim, sGroupsDim);
CubeSetLogChanges(sProcessSecurityCube, 1);
EndIf;

#*** Add TP processes to everyone group

cEnterNodeProc = cControlPrefix | 'tp_workflow_enter_node';
cLeaveNodeProc = cControlPrefix | 'tp_workflow_leave_node';
cOwnNodeProc = cControlPrefix | 'tp_workflow_own_node';
cRejectNodeProc = cControlPrefix | 'tp_workflow_reject_node';
cSaveNodeProc = cControlPrefix | 'tp_workflow_save_node';
cSubmitNodeProc = cControlPrefix | 'tp_workflow_submit_node';
cSubmitLeafChildrenProc = cControlPrefix | 'tp_workflow_submit_leaf_children';
cUpdateUserNameProc = cControlPrefix | 'tp_workflow_update_user_name';
cInitializeSessionProc = cControlPrefix | 'tp_initialize_session';
cExecuteActionProc = cControlPrefix | 'tp_workflow_execute_action';
cHasNodeBegingEditedProc = cControlPrefix | 'tp_workflow_has_node_being_edited';
cBounceConflictUsersProc = cControlPrefix | 'tp_workflow_bounce_conflict_users';




cCurrentCellValue = CellGetS(sProcessSecurityCube, cEnterNodeProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cEnterNodeProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cEnterNodeProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cEnterNodeProc, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cLeaveNodeProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cLeaveNodeProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cLeaveNodeProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cLeaveNodeProc, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cOwnNodeProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cOwnNodeProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cOwnNodeProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cOwnNodeProc, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cRejectNodeProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cRejectNodeProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cRejectNodeProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sDimensionSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cRejectNodeProc, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cSaveNodeProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cSaveNodeProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cSaveNodeProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cSaveNodeProc, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cSubmitNodeProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cSubmitNodeProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cSubmitNodeProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cSubmitNodeProc, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cSubmitLeafChildrenProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cSubmitLeafChildrenProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cSubmitLeafChildrenProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cSubmitLeafChildrenProc, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cUpdateUserNameProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cUpdateUserNameProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cUpdateUserNameProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cUpdateUserNameProc, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cInitializeSessionProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cInitializeSessionProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cInitializeSessionProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cInitializeSessionProc , cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cExecuteActionProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cExecuteActionProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cExecuteActionProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cExecuteActionProc, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cHasNodeBegingEditedProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cHasNodeBegingEditedProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cHasNodeBegingEditedProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cHasNodeBegingEditedProc, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sProcessSecurityCube, cBounceConflictUsersProc, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sProcessSecurityCube, cBounceConflictUsersProc, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cBounceConflictUsersProc,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sProcessSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sProcessSecurityCube, cBounceConflictUsersProc, cEveryoneGroup);
EndIf;

#***

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Add applications dimension, its attributes dimension and cube to everyone group');
EndIf;

cApplicationsAttributesDim = '}ElementAttributes_' | cApplicationsDim;
cApplicationsAttributesCube = '}ElementAttributes_' | cApplicationsDim;

cCurrentCellValue = CellGetS(sDimensionSecurityCube, cApplicationsDim, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sDimensionSecurityCube, cApplicationsDim, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cApplicationsDim,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sDimensionSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', sProcessSecurityCube,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sDimensionSecurityCube, cApplicationsDim, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sDimensionSecurityCube, cApplicationsAttributesDim, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sDimensionSecurityCube, cApplicationsAttributesDim, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cApplicationsAttributesDim,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sDimensionSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sDimensionSecurityCube, cApplicationsAttributesDim, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sCubeSecurityCube, cApplicationsAttributesCube, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sCubeSecurityCube, cApplicationsAttributesCube, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cApplicationsAttributesCube,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sCubeSecurityCube,vDetail,1);
		vDetail=INSRT(CellGetS(sCubeSecurityCube, cApplicationsAttributesCube, cEveryoneGroup),vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sCubeSecurityCube, cApplicationsAttributesCube, cEveryoneGroup);
EndIf;

#***

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Add permissions dimension to everyone group');
EndIf;

cCurrentCellValue = CellGetS(sDimensionSecurityCube, cPermissionsDim, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sDimensionSecurityCube, cPermissionsDim, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cPermissionsDim,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sDimensionSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sDimensionSecurityCube, cPermissionsDim, cEveryoneGroup);
EndIf;

#***

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Add node info dimension to everyone group');
EndIf;

cCurrentCellValue = CellGetS(sDimensionSecurityCube, cNodeInfoDim, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sDimensionSecurityCube, cNodeInfoDim, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cNodeInfoDim,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sDimensionSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sDimensionSecurityCube, cNodeInfoDim, cEveryoneGroup);
EndIf;

#***

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Set security on error cube');
EndIf;

cErrorCube = cControlPrefix | 'tp_process_errors';
cErrorGuidsDim = cControlPrefix |  'tp_process_guids';
cErrorMeasuresDim = cControlPrefix | 'tp_process_error_measures';
cCentralApplicationStateCube = cControlPrefix | 'tp_central_application_state';

cCurrentCellValue = CellGetS(sDimensionSecurityCube, cErrorGuidsDim, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sDimensionSecurityCube, cErrorGuidsDim, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cErrorGuidsDim,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sDimensionSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sDimensionSecurityCube, cErrorGuidsDim, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sDimensionSecurityCube, cErrorMeasuresDim, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sDimensionSecurityCube, cErrorMeasuresDim, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cErrorMeasuresDim,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sDimensionSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sDimensionSecurityCube, cErrorMeasuresDim, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sCubeSecurityCube, cErrorCube, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sCubeSecurityCube, cErrorCube, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cErrorCube,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sCubeSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sCubeSecurityCube, cErrorCube, cEveryoneGroup);
EndIf;

cCurrentCellValue = CellGetS(sCubeSecurityCube, cCentralApplicationStateCube, cEveryoneGroup); 
If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
	If (CellIsUpdateable(sCubeSecurityCube, cCentralApplicationStateCube, cEveryoneGroup) = 0);
		vDetail=INSRT(cEveryoneGroup,')',1);
		vDetail=INSRT(',',vDetail,1);
		vDetail=INSRT(cCentralApplicationStateCube,vDetail,1);
		vDetail=INSRT('(',vDetail,1);
		vDetail=INSRT(sCubeSecurityCube,vDetail,1);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
		'pGuid', pExecutionId, 
		'pProcess', cTM1Process, 
		'pErrorCode', 'TI_SECURITY_NOT_UPDATEABLE',
		'pErrorDetails', vDetail,
		'pControl', pControl);
		ProcessError;
	EndIf;
	CellPutS('Read', sCubeSecurityCube, cCentralApplicationStateCube, cEveryoneGroup);
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
