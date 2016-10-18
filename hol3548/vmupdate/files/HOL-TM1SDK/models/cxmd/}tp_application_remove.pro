601,100
602,"}tp_application_remove"
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
560,3
pExecutionId
pAppId
pControl
561,3
2
2
2
590,3
pExecutionId,"None"
pAppId,"MyApp"
pControl,"N"
637,3
pExecutionId,
pAppId,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,205
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
cTM1Process = cControlPrefix | 'tp_application_remove';
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
CubeLockOverride(1);

#*** Log Parameters

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:', pExecutionId, pAppId, pControl);
EndIf;

cApplicationsDim = cControlPrefix | 'tp_applications';
If (DIMIX(cApplicationsDim, pAppId) <> 0);

	#***
	
	StringGlobalVariable('gApprovalDim');
	StringGlobalVariable('gApprovalSubset');

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Release all data reservations', pAppId);
	EndIf;
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_reserve_release_all', 'pExecutionId', pExecutionId, 
			'pAppId', pAppId, 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
		
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_application_attributes',
	'pExecutionId', pExecutionId,
	'pAppId', pAppId, 'pControl',  pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Get approval hierarchy', gApprovalDim, gApprovalSubset);
	EndIf;

	#***
	If (gApprovalDim @<> '');

		cPermissionCube = cControlPrefix | 'tp_application_permission}' | pAppId;
		cCellSecurityCube = '}CellSecurity_' | cPermissionCube;
	
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Destroy permissions cubes');
		EndIf;
	
		CubeDestroy(cPermissionCube);
		CubeDestroy(cCellSecurityCube);
	
		cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;
		CubeDestroy(cStateCube);

		#***
		cApprovalElementSecurityCube = '}ElementSecurity_' | gApprovalDim;
		CubeDestroy(cApprovalElementSecurityCube);

		cSecurityCube = cControlPrefix | 'tp_application_security}' | pAppId;
		CubeDestroy(cSecurityCube);
	
		cSecurityUpdateCube = cControlPrefix | 'tp_application_security_update}' | pAppId;
		CubeDestroy(cSecurityUpdateCube);


		#***
		cAllView = 'All';
		cElementPropertiesCube = '}ElementProperties_' | gApprovalDim;
		cElementPropertiesDim = '}ElementProperties';

		IF (CubeExists(cElementPropertiesCube) =1);
			If (ViewExists(cElementPropertiesCube, cAllView) = 1);
				ViewDestroy(cElementPropertiesCube, cAllView);
			EndIf;
			ViewCreate(cElementPropertiesCube, cAllView);
			ViewColumnDimensionSet(cElementPropertiesCube, cAllView, cElementPropertiesDim, 1);
			ViewRowDimensionSet(cElementPropertiesCube, cAllView, gApprovalDim, 1);
			ViewZeroOut(cElementPropertiesCube, cAllView);

		Endif;

		#***Remove global security overlay cubes
		cApplicationCubesCube = cControlPrefix | 'tp_application_cubes';
	
		totalCubes = DIMSIZ('}Cubes');
		indexCube = totalCubes;
	
		While (indexCube >= 1);
			cCubeName = DIMNM('}Cubes', indexCube);
	
			cIsAppCube = CellGetS(cApplicationCubesCube, pAppId, cCubeName);
			cOverlayCube = '}SecurityOverlayGlobal_' | cCubeName;

			If (cIsAppCube @= 'A' & CubeExists(cOverlayCube) >0);
				SecurityOverlayDestroyGlobalDefault(cCubeName);
			EndIf;
		
			indexCube = indexCube - 1;
		End;
	
	EndIf;

	#***
	
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Remove application node: ' | pAppId);
	EndIf;

	# clear requires data reservation flag for  application cubes
	cApplicationCubesCube = cControlPrefix | 'tp_application_cubes';
	cCubePropertiesCube = '}CubeProperties';
	totalCubes = DIMSIZ('}Cubes');
	indexCube = 0;
	While (indexCube < totalCubes);
		cCubeName = DIMNM('}Cubes', indexCube+1);
	
		If (cGenerateLog @= 'Y');
			cLogCubeText = 'Getting Check Reserve cube flag ' | cCubeName;
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
		EndIf;
	
		cIsAppCube = CellGetS(cApplicationCubesCube, pAppId, cCubeName);
	
		If ((gApprovalDim @= '' & cIsAppCube @= 'Y') % cIsAppCube @= 'A');
			# clear the require reservation lag
			CellPutS('', cCubePropertiesCube, cCubeName, 'DATARESERVATIONMODE');
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Data Reservation is no longer required on cube ' | cCubeName);
			EndIf;
		EndIf;
		
		indexCube = indexCube + 1;
	End;

	DimensionElementDelete(cApplicationsDim, pAppId);

	#*** Remove sandboxes associated with the application
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_delete_sandboxes',
		'pExecutionId', pExecutionId, 'pAppId', pAppId, 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
Else;

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Application does not exist: ' | pAppId);
	EndIf;

EndIf;

#***
CubeLockOverride(0);

#*** No error

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
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
## (C) Copyright IBM Corp. 2008, 2009, 2010
##
## The source code for this program is not published or otherwise
## divested of its trade secrets, irrespective of what has been
## deposited with the U.S. Copyright Office.
#################################################################







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
