601,100
602,"}tp_application_deploy"
562,"NULL"
586,
585,
564,
565,"jOHxv?wk3QaHvYqWUw[]:?6Vc[\`3EPHylmckY@CCeWV\bF7>TW@U;m:W1S_d;fvbT><QKYlGT8@akOQ9YwKwGAr0[GrO^rxHPAv[TVD:kDdC3aomkQvSgCo[1:pCK0y9HWAeKDQUVbcut`5V0VUo41V0o01<4hAMxh6XaD\0LkZQ98T3dn^bwLHZ7GnL\chhda8P4T8"
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
pAppId
pApprovalDim
pApprovalSubset
pCubeViews
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
pAppId,"MyApp"
pApprovalDim,"TestElist"
pApprovalSubset,"TestElist"
pCubeViews,"None"
pControl,"N"
637,6
pExecutionId,
pAppId,
pApprovalDim,
pApprovalSubset,
pCubeViews,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,312


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
cTM1Process = cControlPrefix | 'tp_application_deploy';
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

#*** Get lock

#cLockName = 'tp_semaphore';
#Synchronized( cLockName ) ;

#***
CubeLockOverRide(1);

#*** Log Parameters

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:',
	pExecutionId, pAppId, pApprovalDim, pApprovalSubset, pControl);
EndIf;

#***
If (pApprovalDim @<> '');
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Check approval dimension');
	EndIf;
	
	If (DimensionExists(pApprovalDim) = 0);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
		'pGuid', pExecutionId,
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_DIM_NOT_EXIST',
		'pErrorDetails', pApprovalDim,
		'pControl', pControl);
		
		ProcessError;
	EndIf;
	
	StringGlobalVariable('gDoesDimHaveCubeName');
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_util_does_dim_have_cube_name',
	'pExecutionId', pExecutionId, 'pDim', pApprovalDim, 'pControl',  pControl);
	
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
	
	If (gDoesDimHaveCubeName @= 'Y');
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'There is a cube with the same name as approval dimension');
		EndIf;
	EndIf;

	#***
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Check approval subset');
	EndIf;
	
	If (SubsetExists(pApprovalDim, pApprovalSubset) = 0);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
		'pGuid', pExecutionId,
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_SUBSET_NOT_EXIST',
		'pErrorDetails', pApprovalDim | ', ' | pApprovalSubset,
		'pControl', pControl);
		
		ProcessError;
	EndIf;

	#***

	cPermissionCube = cControlPrefix | 'tp_application_permission}' | pAppId;
	cCellSecurityCube = '}CellSecurity_' | cPermissionCube;
	cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;

	#***
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Check permission dimension');
	EndIf;

	cPermissionsDim = cControlPrefix | 'tp_permissions';
	If (DimensionExists(cPermissionsDim) = 0);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
		'pGuid', pExecutionId,
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_DIM_NOT_EXIST',
		'pErrorDetails', cPermissionsDim,
		'pControl', pControl);
		
		ProcessError;
	EndIf;

	#***

	If (CubeExists(cPermissionCube) = 0);
	
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Create permission cube: ' | cPermissionCube);
		EndIf;
	
		CubeCreate(cPermissionCube, pApprovalDim, cPermissionsDim);
		CubeSetLogChanges(cPermissionCube, 1);
	EndIf;

	#***

	If (CubeExists(cCellSecurityCube) = 0);
	
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Create permission cell security cube: ' | cCellSecurityCube);
		EndIf;
	
		CubeCreate(cCellSecurityCube, pApprovalDim, cPermissionsDim, '}Groups');
		CubeSetLogChanges(cCellSecurityCube, 1);
	EndIf;

	#***
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Check node info dimension');
	EndIf;
	
	cNodeInfoDim = cControlPrefix | 'tp_node_info';
	If (DimensionExists(cNodeInfoDim) = 0);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
		'pGuid', pExecutionId,
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_DIM_NOT_EXIST',
		'pErrorDetails', cNodeInfoDim,
		'pControl', pControl);
		
		ProcessError;
	EndIf;

	#***
	
	cDefaultView = 'Default';
	cAllView = 'All';
	If (CubeExists(cStateCube) = 0);
		
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Create state cube: ' | cStateCube);
		EndIf;
	
		CubeCreate(cStateCube, pApprovalDim, cNodeInfoDim);
		CubeSetLogChanges(cStateCube, 1);
	
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Create default view');
		EndIf;
	
		ViewCreate(cStateCube, cDefaultView);
		ViewColumnDimensionSet(cStateCube, cDefaultView, cNodeInfoDim, 1);
		ViewRowDimensionSet(cStateCube, cDefaultView, pApprovalDim, 1);
		ViewSubsetAssign(cStateCube, cDefaultView, pApprovalDim, pApprovalSubset);
	
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Create All view');
		EndIf;
	
		ViewCreate(cStateCube, cAllView);
		ViewColumnDimensionSet(cStateCube, cAllView, cNodeInfoDim, 1);
		ViewRowDimensionSet(cStateCube, cAllView, pApprovalDim, 1);
	
	
	EndIf;

EndIf;

vIsNewDeployment = 'N';
cApplicationsDim = cControlPrefix | 'tp_applications';
If (DIMIX(cApplicationsDim, pAppId) = 0);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Insert current application id');
	EndIf;

	vIsNewDeployment = 'Y';
	DimensionElementInsert(cApplicationsDim, '', pAppId, 'S');

Else;

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'This application already existed: ' | pAppId);
	EndIf;

EndIf;

#***

vSecuritySet = '';
If (vIsNewDeployment @= 'N');
	vSecuritySet = ATTRS(cApplicationsDim, pAppId, 'SecuritySet');
EndIf;

#***
If (pApprovalDim @<> '');

	If (vIsNewDeployment @= 'N' & vSecuritySet @= 'N');
	
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Reset permission cell security cube if the previous deployment failed');
		EndIf;
	
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_reset_permission_on_failure',
		'pGuid',  pExecutionId, 'pAppId', pAppId, 'pControl',  pControl);
		
		If (vReturnValue <> ProcessExitNormal());
			ProcessError;
		EndIf;
	
	EndIf;

	sGroupsDim = '}Groups';
	cApprovalElementSecurityCube = '}ElementSecurity_' | pApprovalDim;
	If (CubeExists(cApprovalElementSecurityCube) = 0);
	
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Create element security cube for approval hierarchy');
		EndIf;
	
		CubeCreate(cApprovalElementSecurityCube, pApprovalDim, sGroupsDim);
		CubeSetLogChanges(cApprovalElementSecurityCube, 1);
	
	Else;
	
		If (vIsNewDeployment @= 'Y');
		
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Destroy element security cube for approval hierarchy for new deployment');
			EndIf;
	
			CubeDestroy(cApprovalElementSecurityCube);
			CubeCreate(cApprovalElementSecurityCube, pApprovalDim, sGroupsDim);
			CubeSetLogChanges(cApprovalElementSecurityCube, 1);
	
		EndIf;
	
	EndIf;

	#***
	cElementPropertiesCube = '}ElementProperties_' | pApprovalDim;
	cElementPropertiesDim = '}ElementProperties';	
	If (CubeExists(cElementPropertiesCube ) = 0);
	
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Create ElementProperties cube for approval dimension.');
		EndIf;
	
		CubeCreate(cElementPropertiesCube , pApprovalDim,'}ElementProperties');
		CubeSetLogChanges(cElementPropertiesCube, 1);
	Else;
	
		If (vIsNewDeployment @= 'Y');
		
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Destroy element properties cube for approval hierarchy for new deployment');
			EndIf;
	
			CubeDestroy(cElementPropertiesCube);
			CubeCreate(cElementPropertiesCube , pApprovalDim,cElementPropertiesDim);
			CubeSetLogChanges(cElementPropertiesCube, 1);
	
		EndIf;
	EndIf;

EndIf;


#*** No error

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
EndIf;





573,1

574,1

575,280


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

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Insert approval dimension and subset attributes');
EndIf;

cApprovalDimensionAttr = 'ApprovalDimension';
cApprovalSubsetAttr = 'ApprovalSubset';
cIsActiveAttr = 'IsActive';
cCubeViews = 'CubeViews';

AttrPutS(pApprovalDim, cApplicationsDim, pAppId, cApprovalDimensionAttr);
AttrPutS(pApprovalSubset, cApplicationsDim, pAppId, cApprovalSubsetAttr);
AttrPutS('Y', cApplicationsDim, pAppId, cIsActiveAttr);
AttrPutS(pCubeViews, cApplicationsDim, pAppId, cCubeViews);

#***
If (pApprovalDim @<> '');
	
	cApprovalDimSize = DIMSIZ(pApprovalDim);
	
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Set state cube value for state if the node is in the subset');
	EndIf;
	
	vIndex = 1;
	While (vIndex <= cApprovalDimSize);
		vElement = DIMNM(pApprovalDim, vIndex);
		
		vValue = CellGetS(cStateCube, vElement, 'State');
		If (vValue @= '');
			If (CellIsUpdateable(cStateCube, vElement, 'State') = 0);
				vDetail=INSRT('State',')',1);
				vDetail=INSRT(',',vDetail,1);
				vDetail=INSRT(vElement,vDetail,1);
				vDetail=INSRT('(',vDetail,1);
				vDetail=INSRT(cStateCube,vDetail,1);
				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
				'pGuid', pExecutionId, 
				'pProcess', cTM1Process, 
				'pErrorCode', 'TI_APPLICATION_NOT_UPDATEABLE',
				'pErrorDetails', vDetail,
				'pControl', pControl);
				ProcessError;
			EndIf;
			CellPutS('0', cStateCube, vElement, 'State');
		EndIf;
		
		vIndex = vIndex + 1;
	End;

	#***

	StringGlobalVariable('gApprovalSubsetComplementMdx');
	
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_application_attributes',
	'pExecutionId', pExecutionId, 'pAppId', pAppId, 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
	
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'),
		'gApprovalSubsetComplementMdx', gApprovalSubsetComplementMdx);
	EndIf;
	
	#*** Zero out values of nodes that are not in the approval subset.
	
	If (gApprovalSubsetComplementMdx @<> '');
	
		vApprovalSubsetComplement = 'tp_temp_approval_subset_complement_' | pExecutionId;
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'approval subset complement: ' | vApprovalSubsetComplement);
		EndIf;
	
		SubsetDestroy(pApprovalDim, vApprovalSubsetComplement);
		SubsetCreateByMdx(vApprovalSubsetComplement, gApprovalSubsetComplementMdx);
		
		#****State cube
		vComplementView = 'tp_temp_view_' | pExecutionId;
		ViewCreate(cStateCube, vComplementView);
		ViewColumnDimensionSet(cStateCube, vComplementView, cNodeInfoDim, 1);
		ViewRowDimensionSet(cStateCube, vComplementView, pApprovalDim, 1);
		ViewSubsetAssign(cStateCube, vComplementView, pApprovalDim, vApprovalSubsetComplement);
		
		ViewZeroOut(cStateCube, vComplementView);
		ViewDestroy(cStateCube, vComplementView);

		#****ElementProperties cube
		vComplementView = 'tp_temp_view_' | pExecutionId;
		ViewCreate(cElementPropertiesCube, vComplementView);
		ViewColumnDimensionSet(cElementPropertiesCube, vComplementView, cElementPropertiesDim, 1);
		ViewRowDimensionSet(cElementPropertiesCube, vComplementView, pApprovalDim, 1);
		ViewSubsetAssign(cElementPropertiesCube, vComplementView, pApprovalDim, vApprovalSubsetComplement);
		
		ViewZeroOut(cElementPropertiesCube, vComplementView);
		ViewDestroy(cElementPropertiesCube, vComplementView);
	
	
		SubsetDestroy(pApprovalDim, vApprovalSubsetComplement);
	
	EndIf;
	
EndIf;

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

#***

If (pApprovalDim @<> '');

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Give everyone group "Read" right to application artifacts.');
	EndIf;
	
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Make approval dimension readable');
	EndIf;
	
	sDimensionSecurityCube = '}DimensionSecurity';
	If (CubeExists(sDimensionSecurityCube) = 1);
		cCurrentCellValue = CellGetS(sDimensionSecurityCube, pApprovalDim, cEveryoneGroup); 
		If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
			If (CellIsUpdateable(sDimensionSecurityCube, pApprovalDim, cEveryoneGroup) = 0);
				vDetail=INSRT(cEveryoneGroup,')',1);
				vDetail=INSRT(',',vDetail,1);
				vDetail=INSRT(pApprovalDim,vDetail,1);
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
			CellPutS('Read', sDimensionSecurityCube, pApprovalDim, cEveryoneGroup);
		EndIf;
	EndIf;
	
	#*
	
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Make permission cube readable');
	EndIf;
	
	sCubeSecurityCube = '}CubeSecurity';
	If (CubeExists(sCubeSecurityCube) = 1);
		cCurrentCellValue = CellGetS(sCubeSecurityCube, cPermissionCube, cEveryoneGroup); 
		If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
			If (CellIsUpdateable(sCubeSecurityCube, cPermissionCube, cEveryoneGroup) = 0);
				vDetail=INSRT(cEveryoneGroup,')',1);
				vDetail=INSRT(',',vDetail,1);
				vDetail=INSRT(cPermissionCube,vDetail,1);
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
			CellPutS('Read', sCubeSecurityCube, cPermissionCube, cEveryoneGroup);
		EndIf;
		
		cCurrentCellValue = CellGetS(sCubeSecurityCube, cCellSecurityCube, cEveryoneGroup); 
		If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
			If (CellIsUpdateable(sCubeSecurityCube, cCellSecurityCube, cEveryoneGroup) = 0);
				vDetail=INSRT(cEveryoneGroup,')',1);
				vDetail=INSRT(',',vDetail,1);
				vDetail=INSRT(cCellSecurityCube,vDetail,1);
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
			CellPutS('Read', sCubeSecurityCube, cCellSecurityCube, cEveryoneGroup);
		EndIf;
	EndIf;
	
	#*

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Make state cube readable');
	EndIf;
	
	If (CubeExists(sCubeSecurityCube) = 1);
		cCurrentCellValue = CellGetS(sCubeSecurityCube, cStateCube, cEveryoneGroup); 
		If (cCurrentCellValue @= '' % cCurrentCellValue @= 'NONE');
			If (CellIsUpdateable(sCubeSecurityCube, cStateCube, cEveryoneGroup) = 0);
				vDetail=INSRT(cEveryoneGroup,')',1);
				vDetail=INSRT(',',vDetail,1);
				vDetail=INSRT(cStateCube,vDetail,1);
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
			CellPutS('Read', sCubeSecurityCube, cStateCube, cEveryoneGroup);
		EndIf;
	EndIf;
	
	
EndIf;

#***
CubeLockOverRide(0);

#*** No error

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
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
