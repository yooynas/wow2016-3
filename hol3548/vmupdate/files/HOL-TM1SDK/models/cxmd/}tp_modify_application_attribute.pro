601,100
602,"}tp_modify_application_attribute"
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
560,5
pExecutionId
pAppId
pAttrName
pAttrValue
pControl
561,5
2
2
2
2
2
590,5
pExecutionId,"None"
pAppId,"MyApp"
pAttrName,"NA"
pAttrValue,"NA"
pControl,"N"
637,5
pExecutionId,
pAppId,
pAttrName,
pAttrValue,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,172
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
cTM1Process = cControlPrefix | 'tp_modify_application_attribute';
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

#*** Log Parameters

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Parameters:', 
pExecutionId, pAppId, pAttrName, pAttrValue, pControl);
EndIf;

#***
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Check application id', pAppId);
EndIf;

cApplicationsDim = cControlPrefix | 'tp_applications';
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
TextOutput(cTM1Log, 'Check application attribute', pAttrName);
EndIf;

cApplicationsAttrDim = '}ElementAttributes_' | cApplicationsDim;
If (DIMIX(cApplicationsAttrDim, pAttrName) = 0);
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pExecutionId, 
'pProcess', cTM1Process, 
'pErrorCode', 'TI_NODE_NOT_EXIST',
'pErrorDetails', cApplicationsAttrDim | ', ' | pAttrName,
'pControl', pControl);

ProcessError;
EndIf;

#***
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Set application attribute', pAttrValue);
EndIf;

AttrPutS(pAttrValue, cApplicationsDim, pAppId, pAttrName);

#Set '}CubeProperties' data reservation flag
If (pAttrName @= 'IsActive');
	cApprovalDIM = ATTRS(cControlPrefix | 'tp_applications', pAppId, 'ApprovalDimension');

	cDataReservationType = '';
	If (pAttrValue @= 'Y');
		If (cApprovalDIM @= '');
			cDataReservationType = 'ALLOWED';
		Else;
			cDataReservationType = 'REQUIREDSHARED';
		EndIf;
	EndIf;


	cApplicationCubesCube = cControlPrefix | 'tp_application_cubes';
	
	totalCubes = DIMSIZ('}Cubes');
	indexCube = totalCubes;
	cCubePropertiesCube = '}CubeProperties';
	
	If (cGenerateLog @= 'Y');
		cLogCubeText = 'Reserve cube number cubes to check' | NumberToString(totalCubes);
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
	EndIf;
	
	#clear existing cube flags in case this is a redeployment
	While (indexCube >= 1);
		cCubeName = DIMNM('}Cubes', indexCube);
	
		cIsAppCube = CellGetS(cApplicationCubesCube, pAppId, cCubeName);
		cOverlayCube = '}SecurityOverlayGlobal_' | cCubeName;
	
		If ((cApprovalDIM @= '' & cIsAppCube @= 'Y') % cIsAppCube @= 'A');
			CellPutS(cDataReservationType, cCubePropertiesCube, cCubeName, 'DATARESERVATIONMODE');
			

			IF(cDataReservationType @= 'REQUIREDSHARED');

				#Add overlay cube
				IF (CubeExists(cOverlayCube) =0);
					vDimIndex =1;
					vDimension = TABDIM(cCubeName, vDimIndex);
					vTokenString = '';
					vFoundApproval = 'F';
					While (vDimension @<> '');
						IF (vDimension @= cApprovalDim);
							vSingleToken = '1';
							vFoundApproval = 'T';
						Else;
							vSingleToken = '0';
						EndIf;
						IF (vDimIndex > 1);
							vSingleToken = ':' | vSingleToken;
						Endif;
						vTokenString = vTokenString | vSingleToken;
						vDimIndex = vDimIndex +1;
						vDimension = TABDIM(cCubeName, vDimIndex);
					End;
					IF (vFoundApproval @= 'T');
						SecurityOverlayCreateGlobalDefault(cCubeName, vTokenString);
					Endif;
				Endif;
			Endif;
		Else;
			#Remove overlay cube
			IF (CubeExists(cOverlayCube) =1);
				SecurityOverlayDestroyGlobalDefault(cCubeName);
			Endif;
		EndIf;
		
		indexCube = indexCube - 1;
	End;
EndIf;

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
