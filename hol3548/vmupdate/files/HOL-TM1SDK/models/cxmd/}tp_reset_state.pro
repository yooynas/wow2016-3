601,100
602,"}tp_reset_state"
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
560,4
pExecutionId
pTime
pAppId
pControl
561,4
2
2
2
2
590,4
pExecutionId,"None"
pTime,"0"
pAppId,"MyApp"
pControl,"N"
637,4
pExecutionId,
pTime,
pAppId,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,397

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
CubeLockOverride(1);
#*** Log File Name
cTM1Process = cControlPrefix | 'tp_reset_state';
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
	TextOutput(cTM1Log, 'Parameters:', TIMST(NOW, '\Y-\m-\d \h:\i:\s'), pExecutionId, pAppId, pControl);
EndIf;

#***
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Check application dimension');
EndIf;

cApplicationsDim = cControlPrefix | 'tp_applications';

If (DimensionExists(cApplicationsDim) = 0);
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
		'pGuid', pExecutionId,
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_DIM_NOT_EXIST',
		'pErrorDetails', cApplicationsDim,
		'pControl', pControl);
	
	ProcessError;
EndIf;

#***
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Check application id', pAppId);
EndIf;

If (DIMIX(cApplicationsDim, pAppId) = 0);
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
		'pGuid', pExecutionId,
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_NODE_NOT_EXIST',
		'pErrorDetails', cApplicationsDim | ', ' | pAppId,
		'pControl', pControl);
	
	ProcessError;
EndIf;

#***
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Get Approval dimension and subset');
EndIf;

StringGlobalVariable('gApprovalDim');
StringGlobalVariable('gApprovalSubset');
StringGlobalVariable('gApprovalSubsetComplementMdx');

vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_application_attributes',
	'pExecutionId', pExecutionId, 'pAppId', pAppId, 'pControl',  pControl);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;

cApprovalDim = gApprovalDim;
cApprovalSubset = gApprovalSubset;

#***
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Check state cube');
EndIf;

If (cApprovalDim @= '');
	cStateCube = cControlPrefix | 'tp_central_application_state';
Else;
	cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;
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

cState = 'State';
cStateChangeUser = 'StateChangeUser';
cStateChangeDate = 'StateChangeDate';
cCurrentOwner = 'CurrentOwner';
cWorkInProgress = '2';

cNodeInfoDim = cControlPrefix | 'tp_node_info';
	
# remove existing reservations for the application
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Revoke all owners');
EndIf;
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_reserve_release_all', 'pExecutionId', pExecutionId, 
		'pAppId', pAppId, 'pControl', pControl);
		
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;
	
If (cApprovalDim @= '');
	
	cApplicationsDim = cControlPrefix | 'tp_applications';
	cApplicationSubset = 'tp_temp_reset_application_subset_' | pExecutionId;
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Application reset subset : ' | cApplicationSubset);
	EndIf;
	
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Zero out application values on State cube');
	EndIf;
	
	If (SubsetExists(cApplicationsDim, cApplicationSubset) = 1);
		SubsetDestroy(cApplicationsDim, cApplicationSubset);
	EndIf;	
	SubsetCreate(cApplicationsDim, cApplicationSubset);
	SubsetElementInsert(cApplicationsDim, cApplicationSubset, pAppId, 0);
		
	cApplicationView = 'tp_temp_reset_application_view_' | pExecutionId;
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Application reset view : ' | cApplicationView);
	EndIf;
	If (ViewExists(cStateCube, cApplicationView) = 1);
		ViewDestroy(cStateCube, cApplicationView);	
	EndIf;	
	ViewCreate(cStateCube, cApplicationView);
	ViewColumnDimensionSet(cStateCube, cApplicationView, cNodeInfoDim, 1);
	ViewRowDimensionSet(cStateCube, cApplicationView, cApplicationsDim, 1);
	ViewSubsetAssign(cStateCube, cApplicationView, cApplicationsDim, cApplicationSubset);	
	ViewZeroOut(cStateCube, cApplicationView);
	ViewDestroy(cStateCube, cApplicationView);	
	SubsetDestroy(cApplicationsDim, cApplicationSubset);
Else;
	
	#*** 
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Check all view');
	EndIf;
	
	cAllView = 'All';
	If (ViewExists(cStateCube, cAllView) = 0);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_VIEW_NOT_EXIST',
			'pErrorDetails', cStateCube | ': ' | cAllView,
			'pControl', pControl);
		
		ProcessError;
	EndIf;

	#***
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Zero out all view on ElementProperties cube');
	EndIf;

	cAllView = 'All';
	cElementPropertiesCube = '}ElementProperties_' | gApprovalDim;
	cElementPropertiesDim = '}ElementProperties';

	If (ViewExists(cElementPropertiesCube, cAllView) = 1);
		ViewDestroy(cElementPropertiesCube, cAllView);
	EndIf;
	ViewCreate(cElementPropertiesCube, cAllView);
	ViewColumnDimensionSet(cElementPropertiesCube, cAllView, cElementPropertiesDim, 1);
	ViewRowDimensionSet(cElementPropertiesCube, cAllView, gApprovalDim, 1);
	ViewZeroOut(cElementPropertiesCube, cAllView);

#***
	cApplicationCubesCube = cControlPrefix | 'tp_application_cubes';
	
	totalCubes = DIMSIZ('}Cubes');
	indexCube = totalCubes;
	
	#ZeroOut Global overlay cubes
	While (indexCube >= 1);
		cCubeName = DIMNM('}Cubes', indexCube);
	
		cIsAppCube = CellGetS(cApplicationCubesCube, pAppId, cCubeName);
		cOverlayCube = '}SecurityOverlayGlobal_' | cCubeName;
		cOverlayMeasureDim = '}SecurityOverlay';
		If (cIsAppCube @= 'A' & CubeExists(cOverlayCube) >0);

			cAllView = 'All';
			If (ViewExists(cOverlayCube, cAllView) = 1);
				ViewDestroy(cOverlayCube, cAllView);
			EndIf;
			ViewCreate(cOverlayCube, cAllView);
			ViewColumnDimensionSet(cOverlayCube, cAllView, cOverlayMeasureDim, 1);
			ViewRowDimensionSet(cOverlayCube, cAllView, gApprovalDim, 1);
			ViewZeroOut(cOverlayCube, cAllView);
		EndIf;
		
		indexCube = indexCube - 1;
	End;
	
	#***
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Zero out all view on State cube');
	EndIf;
	
	ViewZeroOut(cStateCube, cAllView);

	#***
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Set node state to Not Started if the node is in the subset');
	EndIf;
	
	#***
	
	cApprovalDimSize = DIMSIZ(cApprovalDim);
	
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Set state cube value for state if the node is in the subset');
	EndIf;
	
	cDisplayUserName = ATTRS('}Clients', TM1User, '}TM1_DefaultDisplayValue');
	If (cDisplayUserName @= '');
		cDisplayUserName = TM1User;
	EndIf;
		
	vIndex = 1;
	While (vIndex <= cApprovalDimSize);
		vElement = DIMNM(cApprovalDim, vIndex);
		
		vValue = CellGetS(cStateCube, vElement, 'State');
		If (vValue @= '');
			If (CellIsUpdateable(cStateCube, vElement, cState) = 0);
				vDetail=INSRT(cState,')',1);
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
			CellPutS('0', cStateCube, vElement, cState);
			If (CellIsUpdateable(cStateCube, vElement, cStateChangeUser) = 0);
				vDetail=INSRT(cStateChangeUser,')',1);
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
			CellPutS(cDisplayUserName, cStateCube, vElement, cStateChangeDate);
			If (CellIsUpdateable(cStateCube, vElement, cStateChangeDate) = 0);
				vDetail=INSRT(cStateChangeDate,')',1);
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
			CellPutS(pTime, cStateCube, vElement, cStateChangeDate);
		EndIf;
		
		vIndex = vIndex + 1;
	End;
	
	#***
	
	If (gApprovalSubsetComplementMdx @<> '');
	
		vApprovalSubsetComplement = 'tp_temp_approval_subset_complement_' | pExecutionId;
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'approval subset complement: ' | vApprovalSubsetComplement);
		EndIf;
	
		SubsetDestroy(cApprovalDim, vApprovalSubsetComplement);
		SubsetCreateByMdx(vApprovalSubsetComplement, gApprovalSubsetComplementMdx);
		
		vComplementView = 'tp_temp_view_' | pExecutionId;
		ViewCreate(cStateCube, vComplementView);
		ViewColumnDimensionSet(cStateCube, vComplementView, cNodeInfoDim, 1);
		ViewRowDimensionSet(cStateCube, vComplementView, cApprovalDim, 1);
		ViewSubsetAssign(cStateCube, vComplementView, cApprovalDim, vApprovalSubsetComplement);
	
		ViewZeroOut(cStateCube, vComplementView);
		ViewDestroy(cStateCube, vComplementView);
		
		SubsetDestroy(cApprovalDim, vApprovalSubsetComplement);
	
	EndIf;
EndIf;

#****Delete all DRs

cApplicationCubesCube = cControlPrefix | 'tp_application_cubes';
vTotalCubes = DIMSIZ('}Cubes');
vLooper = 1;

While (vLooper <= vTotalCubes);
	vCube = DIMNM('}Cubes', vLooper);
	cIsAppCube = CellGetS(cApplicationCubesCube, pAppId, vCube);
	cCubeAddress = '';
	addConcatSymbol = 0;
	If (cIsAppCube @<> '');
		dimensionIndex = 1;
		While (dimensionIndex > 0 ); 
			cCubeDimensionName = TABDIM(vCube, dimensionIndex);
			If (cCubeDimensionName @= '');
				dimensionIndex = -1;
			Else;
				If (addConcatSymbol > 0);
					cCubeAddress = cCubeAddress | '|';
				Else;
					addConcatSymbol = 1;
				EndIf; 
			EndIf;
			dimensionIndex = dimensionIndex + 1;
		End;
		vTotalClients = DIMSIZ('}Clients');
		vLooperClient = 1;
		While (vLooperClient <= vTotalClients);
			vClient = DIMNM('}Clients', vLooperClient);
			CubeDataReservationReleaseAll(vCube,vClient,cCubeAddress);
			vLooperClient = vLooperClient +1;
		End;
	EndIf;
	vLooper = vLooper +1;
End;

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
