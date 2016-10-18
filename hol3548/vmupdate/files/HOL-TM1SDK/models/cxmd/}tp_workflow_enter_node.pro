601,100
602,"}tp_workflow_enter_node"
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
572,231


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
cTM1Process = cControlPrefix | 'tp_workflow_enter_node' | pNode;
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

#*** Check user view privilege
if (gApprovalDim @<> '');
	StringGlobalVariable('gView');
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_user_permissions', 
		'pGuid', pExecutionId, 'pApplication', pAppId, 'pNode', pNode, 'pUser', TM1User, 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
	
	If (gView @= 'F');
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_NO_PERMISSION',
			'pErrorDetails', 'VIEW' | ', ' | pNode,
			'pControl', pControl);
		
		ProcessError;
	EndIf;
EndIf;

#*** Set state viewed
cViewed = 'Viewed';
CellPutS('Y', cStateCube, cStateMember, cViewed);

#*** Set state reviewed

cLocked = '4';
cState = 'State';
vValue = CellGetS(cStateCube, cStateMember, cState);

if (gApprovalDim @<> '');
	StringGlobalVariable('gReject');
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_user_permissions', 
		'pGuid', pExecutionId, 'pApplication', pAppId, 'pNode', pNode, 'pUser', TM1User, 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
	
	If (vValue @= cLocked & gReject @= 'T');
		cReviewed = 'Reviewed';
		CellPutS('Y', cStateCube, cStateMember, cReviewed);
	EndIf;
EndIf;

#*** Check owner
cWorkInProgress = '2';
cState = 'State';
If (gApprovalDim @= '' % DTYPE(gApprovalDim, pNode) @= 'N');
	vValue = CellGetS(cStateCube, cStateMember, cState);
	If (vValue @= cWorkInProgress);
		cCurrentOwner = 'CurrentOwner';
		cOwner = CellGetS(cStateCube, cStateMember, cCurrentOwner);
		If (cDisplayUserName @= cOwner);
	
			cBeingEdited = 'BeingEdited';
			CellPutS('Y', cStateCube, cStateMember, cBeingEdited);
	
			cStartEditingDate = 'StartEditingDate';
			CellPutS(pTime, cStateCube, cStateMember, cStartEditingDate);
	
		EndIf;
	EndIf;
ElseIf (gApprovalDim @<> '');
	### Enter all leaf nodes under consolidation node
	vMDX = '{INTERSECT(TM1FILTERBYLEVEL({DESCENDANTS([' | gApprovalDim | '].[' | pNode | ']) }, 0), TM1SUBSETTOSET([' | gApprovalDim | '], "' | gApprovalSubset |'")), ['
		| gApprovalDim | '].[' | pNode | ']}';
	vSubset = 'enterNode_onConsolidation_' | pExecutionId;
	If (SubsetExists(gApprovalDim, vSubset) <> 0);
		SubsetDestroy(gApprovalDim, vSubset);
	EndIf;
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'SubsetCreateByMdx(vSubset, vMDX);:', vMDX);
	EndIf;
	SubsetCreateByMdx(vSubset, vMDX);
	SubsetElementInsert(gApprovalDim, vSubset, pNode, 0);

	vSize = SubsetGetSize(gApprovalDim, vSubset);
	looper = vSize;
	While (looper >=1);
		vNode = SubsetGetElementName(gApprovalDim, vSubset, looper);

		IF (vNode @<> pNode);
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'Enter descendant node ' | vNode);
			EndIf;

			vState = CellGetS(cStateCube, vNode, cState);	
			cCurrentOwner = 'CurrentOwner';
			cOwner = CellGetS(cStateCube, vNode, cCurrentOwner);
			If (cDisplayUserName @= cOwner & vState @= cWorkInProgress);
	
				cBeingEdited = 'BeingEdited';
				CellPutS('Y', cStateCube, vNode, cBeingEdited);
			
				cStartEditingDate = 'StartEditingDate';
				CellPutS(pTime, cStateCube, vNode, cStartEditingDate);
			EndIf;
		ENDIF;
		
		looper = looper -1;
	End;
EndIf;

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
## (C) Copyright IBM Corp. 2010
##
## The source code for this program is not published or otherwise
## divested of its trade secrets, irrespective of what has been
## deposited with the U.S. Copyright Office.
#################################################################


IF (SubsetExists(gApprovalDim, vSubset) <>0);
	SubsetDestroy(gApprovalDim, vSubset);
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
