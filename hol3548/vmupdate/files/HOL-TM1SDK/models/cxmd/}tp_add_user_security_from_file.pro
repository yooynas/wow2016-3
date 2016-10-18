601,100
602,"}tp_add_user_security_from_file"
562,"CHARACTERDELIMITED"
586,"dummy.txt"
585,"dummy.txt"
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
560,5
pExecutionId
pAppId
pReviewerEditOn
pSourceFile
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
pReviewerEditOn,"F"
pSourceFile,"None"
pControl,"N"
637,5
pExecutionId,
pAppId,
pReviewerEditOn,
pSourceFile,
pControl,
577,5
vNode
vGroup
vRight
vViewDepth
vReviewDepth
578,5
2
2
2
2
2
579,5
1
2
3
4
5
580,5
0
0
0
0
0
581,5
0
0
0
0
0
582,0
572,285

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
cTM1Process = cControlPrefix | 'tp_add_user_security_from_file';
StringGlobalVariable('gPrologLog');
StringGlobalVariable('gEpilogLog');
StringGlobalVariable('gDataLog');
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_log_file_names',
'pExecutionId', pExecutionId, 'pProcess', cTM1Process, 'pControl', pControl);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;
cPrologLog = gPrologLog;
cEpilogLog = gEpilogLog;
cDataLog = gDataLog;
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
							pExecutionId, pAppId, pReviewerEditOn, pSourceFile, pControl);
EndIf;

#*** Set local variables
DataSourceType = 'CHARACTERDELIMITED';
DatasourceASCIIDelimiter = CHAR(9);
DatasourceASCIIHeaderRecords = 1;
DatasourceNameForServer = pSourceFile;

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'DataSourceType: ' | DataSourceType);
	TextOutput(cTM1Log, 'DatasourceASCIIDelimiter: ' | DatasourceASCIIDelimiter);
	TextOutput(cTM1Log, 'DatasourceASCIIHeaderRecords: ' | NumberToString(DatasourceASCIIHeaderRecords));
	TextOutput(cTM1Log, 'DatasourceNameForServer: ' | DatasourceNameForServer);
EndIf;

#*** Set input file encoding as UTF-8

SetInputCharacterSet('TM1CS_UTF8');

#***
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'Check application dimension');
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
	TextOutput(cTM1Log, 'Check application id', pAppId);
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
	TextOutput(cTM1Log, 'Get Approval dimension and subset');
EndIf;

StringGlobalVariable('gApprovalDim');
StringGlobalVariable('gApprovalSubset');
StringGlobalVariable('gSecuritySet');
StringGlobalVariable('gApprovalSubsetComplementMdx');

vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_application_attributes',
'pExecutionId', pExecutionId, 'pAppId', pAppId, 'pControl', pControl);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;

cApprovalDim = gApprovalDim;
cApprovalSubset = gApprovalSubset;
cSecuritySet = gSecuritySet;
cApprovalSubsetComplementMdx = gApprovalSubsetComplementMdx;

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 
				'tp_get_application_attributes', cApprovalDim, cApprovalSubset, cSecuritySet);
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'),
				'gApprovalSubsetComplementMdx', gApprovalSubsetComplementMdx);
EndIf;

If (cApprovalDim @= '');
	cGroupsDimSize = DIMSIZ('}Groups');
	vPosition = 0;
	vIndexI = 1;
	While (vIndexI <= cGroupsDimSize);
	
		vGroup = DIMNM('}Groups', vIndexI);
		ElementSecurityPut('NONE', cApplicationsDim, pAppId, vGroup);
	
		vIndexI = vIndexI + 1;
	End;
Else;
	cApprovalDimSize = DIMSIZ(cApprovalDim);
	cApprovalSubsetSize = SubsetGetSize(cApprovalDim, cApprovalSubset);
	
	#***
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Check permission cube');
	EndIf;
	
	cPermissionCube = cControlPrefix | 'tp_application_permission}' | pAppId;
	If (CubeExists(cPermissionCube) = 0);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
		'pGuid', pExecutionId,
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_CUBE_NOT_EXIST',
		'pErrorDetails', cPermissionCube,
		'pControl', pControl);
	
		ProcessError;
	EndIf;

	#***
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Check cell level security cube');
	EndIf;

	cCellSecurityCube = '}CellSecurity_' | cPermissionCube;

	If (CubeExists(cCellSecurityCube) = 0);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
		'pGuid', pExecutionId,
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_CUBE_NOT_EXIST',
		'pErrorDetails', cCellSecurityCube,
		'pControl', pControl);
		
		ProcessError;
	Else;
		CubeSetLogChanges(cCellSecurityCube, 0);
	EndIf;

	#***
	StringGlobalVariable('gTopNode');
	NumericGlobalVariable('gTopLevel');
	
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_top_node',
	'pExecutionId', pExecutionId, 'pDim', cApprovalDim, 'pSubset', cApprovalSubset);
	If (vReturnValue <> ProcessExitNormal());
	ProcessError;
	EndIf;
	
	If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 
	'tp_get_top_node', gTopNode, NumberToString(gTopLevel));
	EndIf;

	#*** Zero out the values in cubes that are not in the approval subset
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Zero out the values in cubes that are not in the approval subset');
	EndIf;

	cApplicationsDim = cControlPrefix | 'tp_applications';
	cAppElementSecurityCube = '}ElementSecurity_' | cApplicationsDim;
	cElementSecurityCube = '}ElementSecurity_' | cApprovalDim;
	cPermissionsDim = cControlPrefix | 'tp_permissions';
	cPermissionCube = cControlPrefix | 'tp_application_permission}' | pAppId;
	cCellSecurityCube = '}CellSecurity_' | cPermissionCube;

	#* Zero out cell security cube
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Zero out cell security cube');
	EndIf;

	vAllView = 'tp_all_cell_security_view_' | pExecutionId;
	ViewCreate(cCellSecurityCube, vAllView);
	ViewColumnDimensionSet(cCellSecurityCube, vAllView, '}Groups', 1);
	ViewRowDimensionSet(cCellSecurityCube, vAllView, cApprovalDim, 1);
	ViewTitleDimensionSet(cCellSecurityCube, vAllView, cPermissionsDim);

	ViewZeroOut(cCellSecurityCube, vAllView);
	ViewDestroy(cCellSecurityCube, vAllView);

	#* Zero out element security cube
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Zero out element security cube');
	EndIf;

	vAllView = 'tp_temp_element_security_view_' | pExecutionId;
	ViewCreate(cElementSecurityCube, vAllView);
	ViewColumnDimensionSet(cElementSecurityCube, vAllView, '}Groups', 1);
	ViewRowDimensionSet(cElementSecurityCube, vAllView, cApprovalDim, 1);

	ViewZeroOut(cElementSecurityCube, vAllView);
	ViewDestroy(cElementSecurityCube, vAllView);


	#* Zero out application element security cube
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Zero out application element security cube');
	EndIf;

	cGroupsDimSize = DIMSIZ('}Groups');
	cApprovalDimSize = DIMSIZ(cApprovalDim);
	vIndexI = 1;
	While (vIndexI <= cGroupsDimSize);
		vGroup = DIMNM('}Groups', vIndexI);

		vRight = 'NONE';
		vIndexJ = 1;
		While (vIndexJ <= cApprovalDimSize);
			vNode = DIMNM(cApprovalDim, vIndexJ);
			vRight = ElementSecurityGet(cApprovalDim, vNode, vGroup);
			If (vRight @<> 'NONE');
				vIndexJ = cApprovalDimSize;
			EndIf;
			vIndexJ = vIndexJ + 1;
		End;

		If (vRight @= 'NONE');

			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Remove element security', cApplicationsDim,  pAppId, vGroup);
			EndIf;

			ElementSecurityPut('NONE', cApplicationsDim, pAppId, vGroup);
		EndIf;

		vIndexI = vIndexI + 1;
	End;
EndIf;

#*** No error

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
EndIf;


573,1

574,712


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
cTM1Log = cDataLog;

cRightView = 'VIEW';
cRightEdit = 'EDIT';
cRightSubmit = 'SUBMIT';
cRightReview = 'REVIEW';

cView = 'VIEW';
cAnnotate = 'ANNOTATE';
cEdit = 'EDIT';
cReject = 'REJECT';
cSubmit = 'SUBMIT';

cCubeSecurityCube = '}CubeSecurity';
cDimensionSecurityCube = '}DimensionSecurity';
cElementAttributesPrefix = '}ElementAttributes_';

IF (pReviewerEditOn @= 'T');
	cReviewerEditOn ='T';
Else;
	cReviewerEditOn = 'F';
ENDIF;

cViewDepth = NUMBR(vViewDepth);
cReviewDepth = NUMBR(vReviewDepth);

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Security set', cSecuritySet);
EndIf;

#cRead = 'read';
#cNone = 'none';
#cWrite = 'write';
#cLock = 'lock';
#If (cSecuritySet @= '');
cNone = 'NONE';
cRead = 'READ';
cWrite = 'WRITE';
cLock = 'WRITE';
#EndIf;

#***

cGroupPName = DimensionElementPrincipalName('}Groups', vGroup);

If (cApprovalDim @<> '');

	If (DIMIX(cApprovalDim, vNode) = 0);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_NODE_NOT_EXIST',
			'pErrorDetails', cApprovalDim | ', ' | vNode,
			'pControl', pControl);
	
		ProcessError;
	EndIf;
	
	If (DIMIX('}Groups', vGroup) = 0);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_GROUP_NOT_EXIST',
			'pErrorDetails', '}Groups' | ', ' | vGroup,
			'pControl', pControl);
	
		ProcessError;
	EndIf;
	
	cNodePName = DimensionElementPrincipalName(cApprovalDim, vNode);
	
	If ((cNodePName @<> gTopNode) & (ELISANC(cApprovalDim, gTopNode, cNodePName) = 0));
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_NODE_NOT_EXIST_IN_SUBSET',
			'pErrorDetails', cApprovalDim | ', ' | cApprovalSubset | ', ' | cNodePName,
			'pControl', pControl);
	
		ProcessError;
	EndIf;
	
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Get node and group principal name', cNodePName, cGroupPName);
	EndIf;
	
	# Give read right to the attributes dimension and cube of the approval dimension
	cElementAttributes = cElementAttributesPrefix | cApprovalDim;
	If (DimensionExists(cElementAttributes) <> 0);
		CellPutS(cRead, cDimensionSecurityCube, cElementAttributes, cGroupPName);
	EndIf;
	If (CubeExists(cElementAttributes) <> 0);
		CellPutS(cRead, cCubeSecurityCube, cElementAttributes, cGroupPName);
	EndIf;
	
	# IF(1)
		If (DTYPE(cApprovalDim, cNodePName) @= 'C');
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Consolidation node', cNodePName);
			EndIf;
	
	#***
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Assign rights to self', cNodePName);
			EndIf;
	
			If (vRight @= cRightSubmit);
	
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
				If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
					CellPutS(cRead, cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cReject, cGroupPName);
				If (vCellValue @= '');
					CellPutS(cNone, cCellSecurityCube, cNodePName, cReject, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cEdit, cGroupPName);
				If (vCellValue @= '');
					CellPutS(cNone, cCellSecurityCube, cNodePName, cEdit, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
				If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
					CellPutS(cRead, cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cView, cGroupPName);
				If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
					CellPutS(cRead, cCellSecurityCube, cNodePName, cView, cGroupPName);
				EndIf;
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), '142:ElementSecurityPut for submit ' | cNodePName | ',' | cRead | ',' | cGroupPName);
				EndIf;
				ElementSecurityPut(cWrite, cApprovalDim, cNodePName, cGroupPName);
	
			ElseIf (vRight @= cRightReview);
	
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
				If (vCellValue @= '');
					CellPutS(cNone, cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cReject, cGroupPName);
				If (vCellValue @= '');
					CellPutS(cNone, cCellSecurityCube, cNodePName, cReject, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cEdit, cGroupPName);
				If (vCellValue @= '');
					CellPutS(cNone, cCellSecurityCube, cNodePName, cEdit, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
				If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
					CellPutS(cRead, cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cView, cGroupPName);
				If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
					CellPutS(cRead, cCellSecurityCube, cNodePName, cView, cGroupPName);
				EndIf;
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), '169:ElementSecurityPut for review ' | cNodePName | ',' | cRead | ',' | cGroupPName);
				EndIf;
				ElementSecurityPut(cWrite, cApprovalDim, cNodePName, cGroupPName);
				
	
			ElseIf (vRight @= cRightView);
	
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
				If (vCellValue @= '');
					CellPutS(cNone, cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cReject, cGroupPName);
				If (vCellValue @= '');
					CellPutS(cNone, cCellSecurityCube, cNodePName, cReject, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cEdit, cGroupPName);
				If (vCellValue @= '');
					CellPutS(cNone, cCellSecurityCube, cNodePName, cEdit, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
				If (vCellValue @= '');
					CellPutS(cNone, cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
				EndIf;
				vCellValue = CellGetS(cCellSecurityCube, cNodePName, cView, cGroupPName);
				If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
					CellPutS(cRead, cCellSecurityCube, cNodePName, cView, cGroupPName);
				EndIf;
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), '197:ElementSecurityPut for view ' | cNodePName | ',' | cRead | ',' | cGroupPName);
				EndIf;
				ElementSecurityPut(cWrite, cApprovalDim, cNodePName, cGroupPName);
	
			Else;
	
				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
					'pGuid', pExecutionId,
					'pProcess', cTM1Process,
					'pErrorCode', 'TI_WRONG_PERMISSION',
					'pErrorDetails', cNodePName | ', ' | vRight,
					'pControl', pControl);
	
				ProcessError;
	
			EndIf;
	

			#***
	
			cLevel = ELLEV(cApprovalDim, cNodePName);

			#IF(2)
			If (cLevel > cReviewDepth);
	
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Level is greater than review depth: ' | NumberToString(cLevel));
				EndIf;
	
	
				cReviewDescendantsSubset = 'tp_temp_review_descendants_' | pExecutionId;
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Pass review right down, review depth: ' | vReviewDepth);
				EndIf;
	
				StringGlobalVariable('gMdxFindDescendants');
	
				#IF(2.1)
				If ((vRight @= cRightSubmit % vRight @= cRightReview) & (cReviewDepth > 0));
	
					vReturnValue = ExecuteProcess(cControlPrefix | 'tp_mdx_find_descendants', 
						'pExecutionId', pExecutionId, 
						'pDim', cApprovalDim, 'pSubset', '', 'pNode', cNodePName, 'pDepth', vReviewDepth, 'pSelf', 'Y');
					If (vReturnValue <> ProcessExitNormal());
						ProcessError;
					EndIf;
					SubsetDestroy(cApprovalDim, cReviewDescendantsSubset);
					SubsetCreateByMDX(cReviewDescendantsSubset, gMdxFindDescendants);
					vReturnValue = ExecuteProcess(cControlPrefix | 'tp_util_convert_dynamic_subset_to_static', 'pExecutionId', pExecutionId,
					'pDim', cApprovalDim, 'pSubset', cReviewDescendantsSubset);
					If (vReturnValue <> ProcessExitNormal());
						ProcessError;
					EndIf;
	
					cReviewDescendantsSubsetSize = SubsetGetSize(cApprovalDim, cReviewDescendantsSubset);
					vIndex = 1;
					While (vIndex <= cReviewDescendantsSubsetSize);
						vReadOrWrite = cRead;
						vElement = SubsetGetElementName(cApprovalDim, cReviewDescendantsSubset, vIndex);
						vElementPName = DimensionElementPrincipalName(cApprovalDim, vElement);
	
						#IF(2.1.1)
						If (vElementPName @<> cNodePName);
	
							vCellValue = CellGetS(cCellSecurityCube, vElementPName, cReject, cGroupPName);
							If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
								CellPutS(cRead, cCellSecurityCube, vElementPName, cReject, cGroupPName);
							EndIf;
							vCellValue = CellGetS(cCellSecurityCube, vElementPName, cAnnotate, cGroupPName);
							If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
								CellPutS(cRead, cCellSecurityCube, vElementPName, cAnnotate, cGroupPName);
							EndIf;
							vCellValue = CellGetS(cCellSecurityCube, vElementPName, cView, cGroupPName);
							If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
								CellPutS(cRead, cCellSecurityCube, vElementPName, cView, cGroupPName);
							EndIf;
	
							#***Add additional privileges with reviewer edit on
							#IF(2.1.1.1)
							If (cReviewerEditOn @= 'T');
								vCellValue = CellGetS(cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
								If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
									CellPutS(cRead, cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
								EndIf;
	
								If (DTYPE(cApprovalDim, vElementPName) @<> 'C');
									vCellValue = CellGetS(cCellSecurityCube, vElementPName, cEdit, cGroupPName);
									If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
										CellPutS(cRead, cCellSecurityCube, vElementPName, cEdit, cGroupPName);
									EndIf;
									vReadOrWrite = cLock;
	
								Else;
									vCellValue = CellGetS(cCellSecurityCube, vElementPName, cEdit, cGroupPName);
									If (vCellValue @= '');
										CellPutS(cNone, cCellSecurityCube, vElementPName, cEdit, cGroupPName);
									EndIf;
									vReadOrWrite = cWrite;
	
								EndIf;
	
							#IF(2.1.1.1)
							Else;
	
								vCellValue = CellGetS(cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
								If (vCellValue @= '');
									CellPutS(cNone, cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
								EndIf;
								vCellValue = CellGetS(cCellSecurityCube, vElementPName, cEdit, cGroupPName);
								If (vCellValue @= '');
									CellPutS(cNone, cCellSecurityCube, vElementPName, cEdit, cGroupPName);
								EndIf;

	
							#IF(2.1.1.1)
							EndIf;
	
							If (cGenerateLog @= 'Y');
								TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), '306:ElementSecurityPut for ' | vElementPName | ',' | vRight | ',' | vReadOrWrite | ',' |
 cGroupPName);
							EndIf;
							cCellValue = ElementSecurityGet(cApprovalDim, vElementPName, cGroupPName);
							If ( cCellValue @<> vReadOrWrite);
 								If (vReadOrWrite @= cLock);
									ElementSecurityPut(vReadOrWrite, cApprovalDim, vElementPName, cGroupPName);
								Endif;

								If (vReadOrWrite @= cWrite & cCellValue @<> cLock);
									ElementSecurityPut(vReadOrWrite, cApprovalDim, vElementPName, cGroupPName);	
								Endif;

								If (vReadOrWrite @= cRead & cCellValue @<>cLock & cCellValue @<> cWrite);
									ElementSecurityPut(vReadOrWrite, cApprovalDim, vElementPName, cGroupPName);
								Endif;
		
							Endif;
		
						#IF(2.1.1)
						EndIf;
	
						vIndex = vIndex +1;
					End;
	
					SubsetDestroy(cApprovalDim, cReviewDescendantsSubset);
	

				#IF(2.1)
				EndIf;
	
			#IF(2)
			Else;
	
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Level is less than or equal to review depth: ' | NumberToString(cLevel));
				EndIf;
	
				#IF(2.2)
				If ((vRight @= cRightSubmit % vRight @= cRightReview));
	
					vIndex = 1;
					While (vIndex <= cApprovalDimSize);
						vReadOrWrite = cRead;
						vElement = DIMNM(cApprovalDim, vIndex);
						#IF(2.2.1)
						If (ELISANC(cApprovalDim, cNodePName, vElement) = 1);
							vElementPName = DimensionElementPrincipalName(cApprovalDim, vElement);
	
							vCellValue = CellGetS(cCellSecurityCube, vElementPName, cReject, cGroupPName);
							If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
								CellPutS(cRead, cCellSecurityCube, vElementPName, cReject, cGroupPName);
							EndIf;
							vCellValue = CellGetS(cCellSecurityCube, vElementPName, cAnnotate, cGroupPName);
							If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
								CellPutS(cRead, cCellSecurityCube, vElementPName, cAnnotate, cGroupPName);
							EndIf;
							vCellValue = CellGetS(cCellSecurityCube, vElementPName, cView, cGroupPName);
							If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
								CellPutS(cRead, cCellSecurityCube, vElementPName, cView, cGroupPName);
							EndIf;
	
							#***Add additional privileges with reviewer edit on
							#IF(2.2.1.1)
							If (cReviewerEditOn @= 'T');
	
								vCellValue = CellGetS(cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
								If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
									CellPutS(cRead, cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
								EndIf;
	
								If (DTYPE(cApprovalDim, vElementPName) @<> 'C');
									vCellValue = CellGetS(cCellSecurityCube, vElementPName, cEdit, cGroupPName);
									If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
										CellPutS(cRead, cCellSecurityCube, vElementPName, cEdit, cGroupPName);
									EndIf;
									vReadOrWrite = cLock;
	
								Else;
									vCellValue = CellGetS(cCellSecurityCube, vElementPName, cEdit, cGroupPName);
									If (vCellValue @= '');
										CellPutS(cNone, cCellSecurityCube, vElementPName, cEdit, cGroupPName);
									EndIf;
									vReadOrWrite = cWrite;
	
								EndIf;
	
							#IF(2.2.1.1)
							Else;
	
								vCellValue = CellGetS(cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
								If (vCellValue @= '');
									CellPutS(cNone, cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
								EndIf;
								vCellValue = CellGetS(cCellSecurityCube, vElementPName, cEdit, cGroupPName);
								If (vCellValue @= '');
									CellPutS(cNone, cCellSecurityCube, vElementPName, cEdit, cGroupPName);
								EndIf;
	
							#IF(2.2.1.1)
							EndIf;
	
							If (cGenerateLog @= 'Y');
								TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), '392:ElementSecurityPut for ' | vElementPName | ',' | vRight | ',' | vReadOrWrite | ',' |
 cGroupPName);
							EndIf;

							cCellValue = ElementSecurityGet(cApprovalDim, vElementPName, cGroupPName);
							If ( cCellValue @<> vReadOrWrite);
 								If (vReadOrWrite @= cLock);
									ElementSecurityPut(vReadOrWrite, cApprovalDim, vElementPName, cGroupPName);
								Endif;

								If (vReadOrWrite @= cWrite & cCellValue @<> cLock);
									ElementSecurityPut(vReadOrWrite, cApprovalDim, vElementPName, cGroupPName);	
								Endif;

								If (vReadOrWrite @= cRead & cCellValue @<>cLock & cCellValue @<> cWrite);
									ElementSecurityPut(vReadOrWrite, cApprovalDim, vElementPName, cGroupPName);
								Endif;
		
							Endif;
	
						#IF(2.2.1)
						EndIf;
	
						vIndex = vIndex + 1;
					End;
	
				#IF(2.2)
				EndIf;
	
			#IF(2)
			EndIf;
	
			#***
	
			#IF(3)
			If (((vRight @= cRightSubmit % vRight @= cRightReview) & (cViewDepth > cReviewDepth)) %
	    		(vRight @= cRightView));
	
				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Pass View right down, view depth: ' | vViewDepth);
				EndIf;
	
				#IF(3.1)
				If (cLevel > cViewDepth);
	
				cViewDescendantsSubset = 'tp_temp_view_descendants_' | pExecutionId;
				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_mdx_find_descendants', 
					'pExecutionId', pExecutionId, 
					'pDim', cApprovalDim, 'pSubset', '', 'pNode', cNodePName, 'pDepth', vViewDepth, 'pSelf', 'Y');
				If (vReturnValue <> ProcessExitNormal());
					ProcessError;
				EndIf;
				SubsetDestroy(cApprovalDim, cViewDescendantsSubset);
				SubsetCreateByMDX(cViewDescendantsSubset, gMdxFindDescendants);
				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_util_convert_dynamic_subset_to_static', 'pExecutionId', pExecutionId,
					'pDim', cApprovalDim, 'pSubset', cViewDescendantsSubset);
				If (vReturnValue <> ProcessExitNormal());
					ProcessError;
				EndIf;

				cViewDescendantsSubsetSize = SubsetGetSize(cApprovalDim, cViewDescendantsSubset);
				vIndex = 1;
				While (vIndex <= cViewDescendantsSubsetSize);
					vElement = SubsetGetElementName(cApprovalDim, cViewDescendantsSubset, vIndex);
					vElementPName = DimensionElementPrincipalName(cApprovalDim, vElement);
	
					If (vElementPName @<> cNodePName);
	
						vCellValue = CellGetS(cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
						If (vCellValue @= '');
							CellPutS(cNone, cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
						EndIf;
						vCellValue = CellGetS(cCellSecurityCube, vElementPName, cReject, cGroupPName);
						If (vCellValue @= '');
							CellPutS(cNone, cCellSecurityCube, vElementPName, cReject, cGroupPName);
						EndIf;
						vCellValue = CellGetS(cCellSecurityCube, vElementPName, cEdit, cGroupPName);
						If (vCellValue @= '');
							CellPutS(cNone, cCellSecurityCube, vElementPName, cEdit, cGroupPName);
						EndIf;
						vCellValue = CellGetS(cCellSecurityCube, vElementPName, cAnnotate, cGroupPName);
						If (vCellValue @= '');
							CellPutS(cNone, cCellSecurityCube, vElementPName, cAnnotate, cGroupPName);
						EndIf;
						vCellValue = CellGetS(cCellSecurityCube, vElementPName, cView, cGroupPName);
						If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
							CellPutS(cRead, cCellSecurityCube, vElementPName, cView, cGroupPName);
						EndIf;
						cCellValue = ElementSecurityGet(cApprovalDim, vElementPName, cGroupPName);
						If ( cCellValue @= '' % cCellValue @= cNone);
							ElementSecurityPut(cRead, cApprovalDim, vElementPName, cGroupPName);
						Endif;

	
					EndIf;
	
					vIndex = vIndex +1;
				End;
	
				SubsetDestroy(cApprovalDim, cViewDescendantsSubset);
	
			#IF(3.1)
			Else;
	
				vIndex = 1;
				While (vIndex <= cApprovalDimSize);
					vElement = DIMNM(cApprovalDim, vIndex);
					#IF(3.1.1)
					If (ELISANC(cApprovalDim, cNodePName, vElement) = 1);
						vElementPName = DimensionElementPrincipalName(cApprovalDim, vElement);
		
						vCellValue = CellGetS(cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
						If (vCellValue @= '');
							CellPutS(cNone, cCellSecurityCube, vElementPName, cSubmit, cGroupPName);
						EndIf;
						vCellValue = CellGetS(cCellSecurityCube, vElementPName, cReject, cGroupPName);
						If (vCellValue @= '');
							CellPutS(cNone, cCellSecurityCube, vElementPName, cReject, cGroupPName);
						EndIf;
						vCellValue = CellGetS(cCellSecurityCube, vElementPName, cEdit, cGroupPName);
						If (vCellValue @= '');
							CellPutS(cNone, cCellSecurityCube, vElementPName, cEdit, cGroupPName);
						EndIf;
						vCellValue = CellGetS(cCellSecurityCube, vElementPName, cAnnotate, cGroupPName);
						If (vCellValue @= '');
							CellPutS(cNone, cCellSecurityCube, vElementPName, cAnnotate, cGroupPName);
						EndIf;
						vCellValue = CellGetS(cCellSecurityCube, vElementPName, cView, cGroupPName);
						If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
							CellPutS(cRead, cCellSecurityCube, vElementPName, cView, cGroupPName);
						EndIf;
						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), '499:ElementSecurityPut for ' | vElementPName | ',' | vRight | ',' | cRead | ',' | cGroupP
Name);
						EndIf;
						cCellValue = ElementSecurityGet(cApprovalDim, vElementPName, cGroupPName);
						If ( cCellValue @= '' % cCellValue @= cNone);
							ElementSecurityPut(cRead, cApprovalDim, vElementPName, cGroupPName);
						Endif;
		
					#IF(3.1.1)
					EndIf;
		
					vIndex = vIndex + 1;
				End;
	
			#IF(3.1)
			EndIf;
	
		#IF(3)
		Else;
	
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'No need to pass View right down, view depth: ' | vViewDepth);
			EndIf;
	
		#IF(3)
		EndIf;
	
	# IF(1)
	Else;
		If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Leaf node', cNodePName);
		EndIf;
	
		If (vRight @= cRightSubmit);
	
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
			If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
				CellPutS(cRead, cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cReject, cGroupPName);
			If (vCellValue @= '');
				CellPutS(cNone, cCellSecurityCube, cNodePName, cReject, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cEdit, cGroupPName);
			If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
				CellPutS(cRead, cCellSecurityCube, cNodePName, cEdit, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
			If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
				CellPutS(cRead, cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cView, cGroupPName);
			If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
				CellPutS(cRead, cCellSecurityCube, cNodePName, cView, cGroupPName);
			EndIf;
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), '551:ElementSecurityPut for ' | cNodePName | ',' | vRight | ',' | cRead | ',' | cGroupPName);
			EndIf;

			ElementSecurityPut(cLock, cApprovalDim, cNodePName, cGroupPName);

	
		ElseIf (vRight @= cRightEdit);
	
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
			If (vCellValue @= '');
				CellPutS(cNone, cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cReject, cGroupPName);
			If (vCellValue @= '');
				CellPutS(cNone, cCellSecurityCube, cNodePName, cReject, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cEdit, cGroupPName);
			If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
				CellPutS(cRead, cCellSecurityCube, cNodePName, cEdit, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
			If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
				CellPutS(cRead, cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cView, cGroupPName);
			If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
				CellPutS(cRead, cCellSecurityCube, cNodePName, cView, cGroupPName);
			EndIf;
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), '582:ElementSecurityPut for ' | cNodePName | ',' | vRight | ',' | cWrite | ',' | cGroupPName);
			EndIf;
			cCellValue = ElementSecurityGet(cApprovalDim, cNodePName, cGroupPName);
			If ( cCellValue @<> cLock);
				ElementSecurityPut(cWrite, cApprovalDim, cNodePName, cGroupPName);
			Endif;
	
		ElseIf (vRight @= cRightView);
	
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
			If (vCellValue @= '');
				CellPutS(cNone, cCellSecurityCube, cNodePName, cSubmit, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cReject, cGroupPName);
			If (vCellValue @= '');
				CellPutS(cNone, cCellSecurityCube, cNodePName, cReject, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cEdit, cGroupPName);
			If (vCellValue @= '');
				CellPutS(cNone, cCellSecurityCube, cNodePName, cEdit, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
			If (vCellValue @= '');
				CellPutS(cNone, cCellSecurityCube, cNodePName, cAnnotate, cGroupPName);
			EndIf;
			vCellValue = CellGetS(cCellSecurityCube, cNodePName, cView, cGroupPName);
			If (vCellValue @= '' % CODE(vCellValue, 1) <> CODE(cRead, 1));
				CellPutS(cRead, cCellSecurityCube, cNodePName, cView, cGroupPName);
			EndIf;
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), '609:ElementSecurityPut for ' | cNodePName | ',' | vRight | ',' | cRead | ',' | cGroupPName);
			EndIf;
			cCellValue = ElementSecurityGet(cApprovalDim, cNodePName, cGroupPName);
			If ( cCellValue @<> cLock & cCellValue @<> cWrite);
				ElementSecurityPut(cRead, cApprovalDim, cNodePName, cGroupPName);
			Endif;
	
		Else;
	
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
				'pGuid', pExecutionId,
				'pProcess', cTM1Process,
				'pErrorCode', 'TI_WRONG_PERMISSION',
				'pErrorDetails', cNodePName | ', ' | vRight,
				'pControl', pControl);
	
			ProcessError;
	
		EndIf;
	
	# IF(1)
	EndIf;

EndIf;

#***
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Make Application element readable for group', cGroupPName);
EndIf;

cApplicationsDim = cControlPrefix | 'tp_applications';
ElementSecurityPut(cRead, cApplicationsDim, pAppId, cGroupPName);

#*** No error

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
EndIf;




575,37


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

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Starting epilog.');
EndIf;

#***
If (cApprovalDim @<> '');
	CubeSetLogChanges(cCellSecurityCube, 1);
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
