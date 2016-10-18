601,100
602,"}tp_workflow_has_node_being_edited"
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
pNodes
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
pNodes,"NA"
pControl,"N"
637,5
pExecutionId,
pTime,
pAppId,
pNodes,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,193


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



cControlPrefix = '';
If (pControl @= 'Y');
	cControlPrefix = '}';
EndIf;

#*** Log File Name
cTM1Process = cControlPrefix | 'tp_workflow_has_node_being_edited';
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
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:', pExecutionId, pTime, pAppId, pNodes, pControl);
EndIf;

#***

cDisplayUserName = ATTRS('}Clients', TM1User, '}TM1_DefaultDisplayValue');
If (cDisplayUserName @= '');
	cDisplayUserName = TM1User;
EndIf;

#***

cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;
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

#*** Build subset of leaf nodes under node list
vStringToScan = pNodes;
nodeSeparater = ',';
vPosNode = SCAN(nodeSeparater, vStringToScan);
If (vPosNode = 0);
	vMDX = '{TM1FILTERBYLEVEL({DESCENDANTS([' | gApprovalDim | '].[' | pNodes | ']) }, 0)}';
Else;
	vMDX = '{DISTINCT({';

	nodeCount = 0;
	While (vPosNode >0);
		vNodeId = SUBST(vStringToScan, 1, vPosNode-1);
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Add node ' | vNodeId);
		EndIf;

		If (nodeCount > 0);
			vMDX = vMDX | ',';
		EndIf;
		vMDX = vMDX | '{TM1FILTERBYLEVEL({DESCENDANTS([' | gApprovalDim | '].[' | vNodeId | '])},0)}';

		vStringToScan = SUBST(vStringToScan, vPosNode +1, LONG(vStringToScan)-vPosNode);
		vPosNode = SCAN(nodeSeparater, vStringToScan);
		
		nodeCount = nodeCount + 1;
	End;
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Add node ' | vStringToScan);
	EndIf;
	If (nodeCount > 0);
		vMDX = vMDX | ',';
	EndIf;
	vMDX = vMDX | '{TM1FILTERBYLEVEL({DESCENDANTS([' | gApprovalDim | '].[' | vStringToScan | '])},0)}})}';
EndIf;

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'Leaf MDX: ' | vMDX);
EndIf;

vSubset = 'hasNodeBeingEdited_' | pExecutionId;
If (SubsetExists(gApprovalDim, vSubset) <> 0);
	SubsetDestroy(gApprovalDim, vSubset);
EndIf;
SubsetCreateByMdx(vSubset, vMDX, gApprovalDim);

vReturnValue = ExecuteProcess(cControlPrefix | 'tp_util_convert_dynamic_subset_to_static', 'pExecutionId', pExecutionId,
	'pDim', gApprovalDim, 'pSubset',  vSubset);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;

#*** See if any leafs are being edited
cBeingEdited = 'BeingEdited';
vSize = SubsetGetSize(gApprovalDim, vSubset);
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'Number of leafs is ' | TRIM(STR(vSize, 5, 0)));
EndIf;
looper = vSize;
While (looper >= 1);
	vNode = SubsetGetElementName(gApprovalDim, vSubset, looper);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Check leaf node ' | vNode);
	EndIf;
	
	vEdited = CellGetS(cStateCube, vNode, cBeingEdited);
	If (vEdited @= 'Y');
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
			'pGuid', pExecutionId, 
			'pProcess', cTM1Process, 
			'pErrorCode', 'NODE_OWNER_ACTIVE',
			'pErrorDetails', pAppId,
			'pControl', pControl);
		
		looper = 1;
	EndIf;
			
	looper = looper - 1;
End;

#*** No error

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
EndIf;

573,1

574,1

575,22


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


If (SubsetExists(gApprovalDim, vSubset) <>0);
	SubsetDestroy(gApprovalDim, vSubset);
EndIf;


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
