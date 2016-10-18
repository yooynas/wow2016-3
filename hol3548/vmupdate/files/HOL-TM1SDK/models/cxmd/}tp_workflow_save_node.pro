601,100
602,"}tp_workflow_save_node"
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
572,241


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
cTM1Process = cControlPrefix | 'tp_workflow_save_node';
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

If (gApprovalDim @= '');
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

If (gApprovalDim @<> '');
	cPrincipalNodeName = DimensionElementPrincipalName(gApprovalDim, pNode);
EndIf;

If (gApprovalDim @= '' % DTYPE(gApprovalDim, pNode) @='N');
	
	#*** Check user privilege
	if (gApprovalDim @<> '');
		StringGlobalVariable('gEdit');
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_user_permissions', 
			'pGuid', pExecutionId, 'pApplication', pAppId, 'pNode', pNode, 'pUser', TM1User, 'pControl', pControl);
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
	
	#*** Check owner
	cCurrentOwner = 'CurrentOwner';
	cOwner = CellGetS(cStateCube, cStateMember, cCurrentOwner);
	if ((gApprovalDim @= '' & cOwner @<> '' & cDisplayUserName @<> cOwner) %
			(gApprovalDim @<> '' & cDisplayUserName @<> cOwner));
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'TI_WRONG_OWNER',
			'pErrorDetails', 'Save' | ', ' | pNode | ', ' | cOwner,
			'pControl', pControl);
		
		ProcessError;
	EndIf;
	
	#*** Set values
	cSaved = 'Saved';
	CellPutS('Y', cStateCube, cStateMember, cSaved);
	
	cDataChangeUser = 'DataChangeUser';
	CellPutS(cDisplayUserName, cStateCube, cStateMember, cDataChangeUser);
	
	cDataChangeDate = 'DataChangeDate';
	CellPutS(pTime, cStateCube, cStateMember, cDataChangeDate);
Else;

	vMDX = '{INTERSECT(TM1FILTERBYLEVEL({DESCENDANTS([' | gApprovalDim | '].[' | pNode | ']) }, 0), TM1SUBSETTOSET([' | gApprovalDim | '],"' | gApprovalSubset | '")), ['
		| gApprovalDim | '].[' | pNode | ']}';
	vSubsetLeafChildren = 'save_onConsolidation_' | pExecutionId;
	If (SubsetExists(gApprovalDim, vSubsetLeafChildren) <> 0);
		SubsetDestroy(gApprovalDim, vSubsetLeafChildren);
	EndIf;
	SubsetCreateByMdx(vSubsetLeafChildren, vMDX);
	SubsetElementInsert(gApprovalDim, vSubsetLeafChildren, pNode, 0);
	vSize = SubsetGetSize(gApprovalDim, vSubsetLeafChildren);

	looper = vSize;
	While (looper >=1);
		vLeafChild = SubsetGetElementName(gApprovalDim, vSubsetLeafChildren, looper);
	
		If (vLeafChild @<> pNode);
	
			StringGlobalVariable('gEdit');
			vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_user_permissions', 
				'pGuid', pExecutionId, 'pApplication', pAppId, 'pNode', vLeafChild, 'pUser', TM1User, 'pControl', pControl);
			If (vReturnValue <> ProcessExitNormal());
				ProcessError;
			EndIf;
	
			cCurrentOwner = 'CurrentOwner';
			cCurrentOwnerValue = CellGetS(cStateCube, vLeafChild, cCurrentOwner);
			
			cState = 'State';
			cStateValue = CellGetS(cStateCube, vLeafChild, cState);
			
			cTakeOwnershipNode = 'TakeOwnershipNode';
			cTakeOwnershipNodeValue = CellGetS(cStateCube, vLeafChild, cTakeOwnershipNode);
	
			If (gEdit @= 'T' & 
			    cDisplayUserName @= cCurrentOwnerValue & 
			    cStateValue @= '2' &
			    cTakeOwnershipNodeValue @= cPrincipalNodeName);
	    
				#*** Set values
				cSaved = 'Saved';
				CellPutS('Y', cStateCube, vLeafChild, cSaved);
				
				cDataChangeUser = 'DataChangeUser';
				CellPutS(cDisplayUserName, cStateCube, vLeafChild, cDataChangeUser);
				
				cDataChangeDate = 'DataChangeDate';
				CellPutS(pTime, cStateCube, vLeafChild, cDataChangeDate);
			EndIf;	
		EndIf;
	
		looper = looper -1;
	End;
EndIf;

If (SubsetExists(gApprovalDim, vSubsetLeafChildren) <>0);
	SubsetDestroy(gApprovalDim, vSubsetLeafChildren);
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
