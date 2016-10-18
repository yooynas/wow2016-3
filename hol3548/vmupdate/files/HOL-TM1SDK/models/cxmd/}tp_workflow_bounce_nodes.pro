601,100
602,"}tp_workflow_bounce_nodes"
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
560,9
pExecutionId
pAppId
pOwnerIdToBounce
pOwnershipNodeToBounce
pSourceNode
pTime
pCheckBouncingOnly
pBouncingMode
pControl
561,9
2
2
2
2
2
2
2
2
2
590,9
pExecutionId,"None"
pAppId,"MyApp"
pOwnerIdToBounce,"NA"
pOwnershipNodeToBounce,"NA"
pSourceNode,"NA"
pTime,"0"
pCheckBouncingOnly,"N"
pBouncingMode,"NEVER"
pControl,"N"
637,9
pExecutionId,
pAppId,
pOwnerIdToBounce,
pOwnershipNodeToBounce,
pSourceNode,
pTime,
pCheckBouncingOnly,
pBouncingMode,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,231

################################################################
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


#*** Log File Name
cTM1Process = GetProcessName();
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

#*** Log Parameters
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, TIMST(NOW,'\Y \M \d - \h:\i:\s'),
		'Parameters:', pExecutionId, pAppId, pOwnerIdToBounce, pOwnershipNodeToBounce, pControl);
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

#***
#constants
cLocked = '4';
cWorkInProgress = '2';
cState = 'State';
cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;
cCurrentOwner = 'CurrentOwner';
cCurrentOwnerId = 'CurrentOwnerId';
cTakeOwnershipNode = 'TakeOwnershipNode';
cStateMeasureDim=cControlPrefix | 'tp_node_info';

#****

#IF (Bounce 0)
IF (pOwnerIdToBounce @<>'' & pOwnershipNodeToBounce @<> '');
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Bounce nodes');
	EndIf;

	###bounce leaf nodes in the package
        IF (DIMIX('}Clients', pOwnerIdToBounce) >0);
	    vOwnerToBounce = ATTRS('}Clients', pOwnerIdToBounce, '}TM1_DefaultDisplayValue');
        Else;
	    vOwnerToBounce = pOwnerIdToBounce;
	EndIf;
	If (vOwnerToBounce @= '');
	    vOwnerToBounce = pOwnerIdToBounce;
	EndIf;

	# *** escape double quotes characters, if found, in the user it (such as CAM user id)
    varX = vOwnerToBounce;
	vPos = SCAN('"', varX );
	If (vPos > 1);
		tempID = '';
		While (vPos > 1);	
			var1 = SUBST(varX , 1, vPos -1) ;
			var2 = SUBST(varX , vPos + 1, LONG(varX ) - vPos);	
			varX  = var2;
			vPos = SCAN('"', varX );
			If (vPos > 1);
				tempID = tempID | var1 | '""' ;
			Else;
				tempID = tempID | var1 | '""' | varX;
			EndIf;
		End;
        vOwnerToBounce = tempID;
    EndIf;

	vMdx = '{FILTER(TM1FILTERBYLEVEL( TM1SUBSETTOSET([' | gApprovalDim | '],"' | gApprovalSubset | '"), 0), ';
	vMdx = vMdx | '[' | cStateCube | '].[' | cStateMeasureDim | '].[CurrentOwner]="' | vOwnerToBounce | '"' ;
	vMdx = vMdx | 'AND [' | cStateCube | '].[' | cStateMeasureDim | '].[TakeOwnershipNode]="' | pOwnershipNodeToBounce | '" ),';
	vMdx = vMdx | '[' | gApprovalDim | '].[' | pSourceNode | ']}';

	vSubsetNodesToBounce = 'nodesToBounce_by_' | pSourceNode | '_' | pExecutionId;
	IF (SubsetExists(gApprovalDim, vSubsetNodesToBounce) <>0);
		SubsetDestroy(gApprovalDim, vSubsetNodesToBounce);
	ENDIF;
	SubsetCreateByMdx(vSubsetNodesToBounce, vMDX);
	SubsetElementInsert(gApprovalDim, vSubsetNodesToBounce, pSourceNode, 0);

	vBounceSize = SubsetGetSize(gApprovalDim, vSubsetNodesToBounce);

	looperBounce = vBounceSize;
	While (looperBounce >=1);
		vNodeBounce =  SubsetGetElementName(gApprovalDim, vSubsetNodesToBounce, looperBounce);

		#IF (Bounce1)
		#exclude dummy node
		IF (vNodeBounce @<> pSourceNode);

			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, 'Bounce related nodes');
			EndIf;

			vBounceOwnerId = CellGetS(cStateCube, vNodeBounce, cCurrentOwnerId);
			vBounceOwnershipNode = CellGetS(cStateCube, vNodeBounce, cTakeOwnershipNode);
			vBounceState = CellGetS(cStateCube, vNodeBounce, cState);

			#IF (Bounce2)
			IF (vBounceOwnerId @=pOwnerIdToBounce & vBounceOwnershipNode @= pOwnershipNodeToBounce);

				#IF (Bounce3)
				If ((vBounceState @= '') % (vBounceState @=cWorkInProgress ));
					cBeingEdited = 'BeingEdited';
					cStartEditingDate = 'StartEditingDate';
					IF (vBounceState @=cWorkInProgress & pCheckBouncingOnly @= 'Y' & (pBouncingMode @= 'ALWAYS' % pBouncingMode @='ACTIVE') );
						vEdited = CellGetS(cStateCube,  vNodeBounce,cBeingEdited);
						If (vEdited @= 'Y');
							vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
							'pGuid', pExecutionId, 
							'pProcess', cTM1Process, 
							'pErrorCode', 'NODE_BOUNCE_OWNER_ACTIVE',
							'pErrorDetails', pAppId,
							'pControl', pControl);
						Elseif (pBouncingMode @= 'ALWAYS');
							vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
							'pGuid', pExecutionId, 
							'pProcess', cTM1Process, 
							'pErrorCode', 'NODE_BOUNCE_OWNER_INACTIVE',
							'pErrorDetails', pAppId,
							'pControl', pControl);		
							
						EndIf;
						looperBounce= 1;
					Else;

						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, 'clean state fields');
						EndIf;

						CellPutS('', cStateCube, vNodeBounce, cCurrentOwner);
						CellPutS('', cStateCube, vNodeBounce, cCurrentOwnerId);
						CellPutS('', cStateCube, vNodeBounce, cTakeOwnershipNode);
						#***

						CellPutS('', cStateCube, vNodeBounce, cBeingEdited);
						CellPutS('', cStateCube, vNodeBounce, cStartEditingDate);

						#***
						#change state
						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, 'Change state');
						EndIf;

						vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_change_node_state', 'pExecutionId', pExecutionId,
							'pTime', pTime, 'pAppId', pAppId, 'pNode', vNodeBounce, 'pPrivilege', 'BOUNCE', 'pControl', pControl);
						If (vReturnValue <> ProcessExitNormal());
							ProcessError;
						EndIf;
					Endif;

				#***
				#IF (Bounce3)
				ENDIF;
			#***
			#IF (Bounce2)
			ENDIF;

		#IF (Bounce1)
		ENDIF;

		looperBounce = looperBounce-1;
	END;

#IF (Bounce 0)
ENDIF;

#Finally take out DR on consolidation level
IF (pCheckBouncingOnly @= 'N');
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'revoke ownership on consolidation');
	EndIf;

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_reserve_slice', 'pExecutionId', pExecutionId, 
		'pAppId', pAppId, 'pNode', pOwnershipNodeToBounce, 'pApprovalDim', gApprovalDim, 'pReserve', 'N', 'pUser', pOwnerIdToBounce, 'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;

Endif;


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
## (C) Copyright IBM Corp. 2008, 2009
##
## The source code for this program is not published or otherwise
## divested of its trade secrets, irrespective of what has been
## deposited with the U.S. Copyright Office.
#################################################################


IF (SubsetExists(gApprovalDim, vSubsetNodesToBounce ) <>0);
SubsetDestroy(gApprovalDim, vSubsetNodesToBounce );
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
