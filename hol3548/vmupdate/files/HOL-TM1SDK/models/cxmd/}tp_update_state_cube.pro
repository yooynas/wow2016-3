601,100
602,"}tp_update_state_cube"
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
560,3
pGuid
pAppId
pControl
561,3
2
2
2
590,3
pGuid,"None"
pAppId,"MyApp"
pControl,"N"
637,3
pGuid,
pAppId,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,356


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
cTM1Process = cControlPrefix | 'tp_update_state_cube';
StringGlobalVariable('gPrologLog');
StringGlobalVariable('gEpilogLog');
vReturnValue = ExecuteProcess( cControlPrefix | 'tp_get_log_file_names', 'pExecutionId', pGuid,
'pProcess', cTM1Process, 'pControl', pControl);
If (vReturnValue <> ProcessExitNormal());
ProcessError;
EndIf;
cPrologLog = gPrologLog;
cEpilogLog = gEpilogLog;
cTM1Log = cPrologLog;

cGenerateLog = ATTRS(cControlPrefix | 'tp_config', 'Generate TI Log', 'String Value');

#*** Get lock

#cLockName = 'tp_semaphore';
#Synchronized( cLockName ) ;

#***
CubeLockOverride(1);

#*** Log Parameters
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW,'\Y \M \d - \h:\i:\s'), 'Parameters:', pGuid, pAppId,  pControl);
EndIf;

#*** Check application

cApplicationsDim = cControlPrefix |  'tp_applications';

If (DimensionExists(cApplicationsDim) = 0);
ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pGuid, 
'pProcess', cTM1Process,
'pErrorCode', 'TI_DIM_NOT_EXIST',
'pErrorDetails', cApplicationsDim, 
'pControl', pControl);
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, cApplicationsDim | ' does not exist.');
EndIf;
ProcessError;
EndIf;

If (DIMIX(cApplicationsDim, pAppId) = 0);
ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pGuid, 
'pProcess', cTM1Process,
'pErrorCode', 'TI_NODE_NOT_EXIST',
'pErrorDetails', pAppId, 
'pControl', pControl);
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, pAppId | ' does not exist.');
EndIf;
ProcessError;
EndIf;

#*** Check State cube
cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;
cNodeInfoDim = cControlPrefix | 'tp_node_info';

If (CubeExists(cStateCube) = 0);
ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pGuid, 
'pProcess', cTM1Process,
'pErrorCode', 'TI_CUBE_NOT_EXIST',
'pErrorDetails', cStateCube, 
'pControl', pControl);
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Cube ' | cStateCube | ' does not exist.');
EndIf;
ProcessError;
EndIf;

#* Get Approval dimension and subset

#*** declare global variables
StringGlobalVariable('gApprovalDim');
StringGlobalVariable('gApprovalSubset');
StringGlobalVariable('gApprovalSubsetComplementMdx');

vReturnValue = ExecuteProcess( cControlPrefix | 'tp_get_application_attributes', 'pExecutionId', pGuid,
'pAppId', pAppId, 'pControl',  pControl);
If (vReturnValue <> ProcessExitNormal());
ProcessError;
EndIf;

cApprovalDim = gApprovalDim;
cApprovalSubset = gApprovalSubset;
cApprovalSubsetComplementMdx = gApprovalSubsetComplementMdx;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Approval Dimension: ' | cApprovalDim);
TextOutput(cTM1Log, 'Approval Subset: ' | cApprovalSubset);
TextOutput(cTM1Log, 'Approval Subset Complement MDX: ' | cApprovalSubsetComplementMdx);
EndIf;

#*** Zero out the values in state cube that are not in the approval subset

If (cApprovalSubsetComplementMdx @<> '');

vApprovalSubsetComplement = 'tp_temp_approval_subset_complement_' | pGuid;
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'approval subset complement: ' | vApprovalSubsetComplement);
EndIf;

SubsetDestroy(cApprovalDim, vApprovalSubsetComplement);
SubsetCreateByMdx(vApprovalSubsetComplement, cApprovalSubsetComplementMdx);

vComplementView = 'tp_temp_view_' | pGuid;
ViewCreate(cStateCube, vComplementView);
ViewColumnDimensionSet(cStateCube, vComplementView, cNodeInfoDim, 1);
ViewRowDimensionSet(cStateCube, vComplementView, cApprovalDim, 1);
ViewSubsetAssign(cStateCube, vComplementView, cApprovalDim, vApprovalSubsetComplement);

ViewZeroOut(cStateCube, vComplementView);
ViewDestroy(cStateCube, vComplementView);

SubsetDestroy(cApprovalDim, vApprovalSubsetComplement);
EndIf;

#***Check invalid node states

#***States
cNotStarted= '0';
cIncomplete = '1';
cWorkInProgress = '2';
cReady = '3';
cLocked = '4';

vLevel = 0;
vSubset = 'nodes_in_level_' | pGuid;
vReachTopLevel = 'F';
WHILE (vReachTopLevel @= 'F');
	IF (SubsetExists(cApprovalDim, vSubset) =1);
		SubsetDestroy(cApprovalDim, vSubset);
	ENDIF;

	vMDX = '{INTERSECT(TM1FILTERBYLEVEL( TM1SUBSETALL( [' | cApprovalDim | '] ), ' | NumberToString(vLevel) | '), 
		[' | cApprovalDim | '].[' | cApprovalSubset | '])}';

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Mdx to get nodes with level ' | numberToString(vLevel) | ' : ' | vMDX);
	ENDIF;
	subsetCreateByMdx(vSubset, vMDX, cApprovalDim);
	vSubsetSize = SubsetGetSize(cApprovalDim, vSubset);

	IF (vSubsetSize >0);
		vReturnValue = ExecuteProcess(cControlPrefix | 'tp_util_convert_dynamic_subset_to_static', 'pExecutionId', pGuid,
			'pDim', cApprovalDim, 'pSubset', vSubset);
		If (vReturnValue <> ProcessExitNormal());
			ProcessError;
		EndIf;
	EndIF;

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'subset Size: ' | numbertostring(vSubsetSize) | ' for level: ' | NumberToString(vLevel));
	ENDIF;

	IF (vSubsetSize = 0);

		IF (vLevel >= 20);
			vReachTopLevel = 'T';
			If (cGenerateLog @= 'Y');
				TextOutput(cTM1Log, ' Reach top level: ' | NumberToString(vLevel));
			ENDIF;
		ENDIF;
	ELSE;
		vReachTopLevel = 'F';
		looper =vSubsetSize;
		WHILE (looper >0);
			vNode = SubsetGetElementName (cApprovalDim, vSubset, looper);
			vState = CellGetS(cStateCube, vNode, 'State');

			If (vNode @<> '');
				if (CellIsUpdateable(cStateCube, vNode, 'State') = 0);
					vDetail=INSRT('State',')',1);
					vDetail=INSRT(',',vDetail,1);
					vDetail=INSRT(vNode,vDetail,1);
					vDetail=INSRT('(',vDetail,1);
					vDetail=INSRT(cStateCube,vDetail,1);
					vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
					'pGuid', pGuid, 
					'pProcess', cTM1Process, 
					'pErrorCode', 'TI_APPLICATION_NOT_UPDATEABLE',
					'pErrorDetails', vDetail,
					'pControl', pControl);
					ProcessError;
				EndIf;
			EndIf;

			IF (vNode @<>'' & vLevel = 0 & DTYPE(cApprovalDim, vNode) @<> 'C');

				IF (vState @= '');
					CellPutS('0', cStateCube, vNode, 'State');

					If (cGenerateLog @= 'Y');
						TextOutput(cTM1Log, 'Leaf level node: ' | vNode | ' can not have state ' | vState | '. Change state from null to NotStarted 0' );
					ENDIF;

				ENDIF;

				IF (vState @= cReady % vState @= cIncomplete);
					CellPutS('2', cStateCube, vNode, 'State');

					If (cGenerateLog @= 'Y');
						TextOutput(cTM1Log, 'Leaf level node: ' | vNode | ' can not have state ' | vState | '. Change state to WorkInProgress 2' );
					ENDIF;

				ENDIF;

			ELSEIF (vNode @<>'' & vLevel >0 & DTYPE(cApprovalDim, vNode) @= 'C');
				IF (vState @= '');
					CellPutS('0', cStateCube, vNode, 'State');

					If (cGenerateLog @= 'Y');
						TextOutput(cTM1Log, 'Leaf level node: ' | vNode | ' can not have state ' | vState | '. Change state from null to NotStarted 0' );
					ENDIF;

				ENDIF;

				vChildrenSize = ELCOMPN(cApprovalDim, vNode);

				vNotStartedCount = 0;
				vIncompleteCount = 0;
				vInProgressCount =0;
				vReadyCount =0;
				vLockedCount =0;


				looper2 =1;
				While (looper2<=vChildrenSize);
					vChild = ELCOMP(cApprovalDim, vNode, looper2);
					vChildState = CellGetS(cStateCube, vChild, 'State');
					IF (vChildState @= '0');
						vNotStartedCount = vNotStartedCount +1;
					ELSEIF (vChildState @= '1');
						vIncompleteCount = vIncompleteCount +1;
					ELSEIF (vChildState @= '2');
						vInProgressCount = vInProgressCount +1;
					ELSEIF (vChildState @='3');
						vReadyCount = vReadyCount +1;
					ELSEIF (vChildState @= '4');
						vLockedCount = vLockedCount +1;
					ENDIF;
					looper2 = looper2+1;
				END;

				If (cGenerateLog @= 'Y');
					TextOutput(cTM1Log, 'NotStartedCount: ' | NumberToString(vNotStartedCount));
					TextOutput(cTM1Log, 'InCompleteCount: ' | NumberToString(vIncompleteCount));
					TextOutput(cTM1Log, 'InProgressCount: ' | NumberToString(vInProgressCount));
					TextOutput(cTM1Log, 'ReadyCount: ' | NumberToString(vReadyCount));
					TextOutput(cTM1Log, 'LockedCount: ' | NumberToString(vLockedCount));
					TextOutput(cTM1Log, 'Current State: ' | vState);
					TextOutput(cTM1Log, 'Current Node: ' | vNode);
				ENDIF;

				vNewState = '';
				#***NotStarted for consolidated node: If all children are NotStarted, parent should be NotStarted
				IF (vNotStartedCount >0 & vInProgressCount =0 & vLockedCount =0 & vReadyCount =0 & vInCompleteCount =0);
					vNewState = cNotStarted;
					IF (vNewState @<> vState);
						CellPutS(vNewState, cStateCube, vNode, 'State');
						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, vNode | ' state is changed from ' | vState | ' to NotStarted 0.' );
						ENDIF;
					ENDIF;

				#***Incomplete for consolidated node: At least one of the items that makes up this e.List item
				#has not started or Incomplete and at least one other item has started
				ELSEIF ((vNotStartedCount) >0 & (vInProgressCount >0 % vLockedCount >0  % vReadyCount>0 % vIncompleteCount >0));
					vNewState = cIncomplete;
					IF (vNewState @<> vState);
						CellPutS(vNewState, cStateCube, vNode, 'State');
						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, vNode | ' state is changed from ' | vState | ' to Incomplete 1.' );
						ENDIF;
					ENDIF;

				#***#***Incomplete for consolidated node: At least one of the items that makes up this e.List item
				#has not started or Incomplete and at least one other item has started
				ELSEIF (vIncompleteCount >0);
					vNewState = cIncomplete;
					IF (vNewState @<> vState);
						CellPutS(vNewState, cStateCube, vNode, 'State');
						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, vNode | ' state is changed from ' | vState | ' to Incomplete 1.' );
						ENDIF;
					ENDIF;

				#***WorkInProgress for consolidated node: All items making up this e.List item have started (nothing notStarted or incomplete)
				#at least one item has not been submitted
				ELSEIF ( vNotStartedCount =0 & vIncompleteCount=0 & (vInProgressCount +  vReadyCount) >0);
					vNewState = cWorkInProgress;
					IF (vNewState @<> vState);
						CellPutS(vNewState, cStateCube, vNode, 'State');
						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, vNode | ' state is changed from ' | vState | ' to WorkInProgress 2.' );
						ENDIF;
					ENDIF;

				#Ready for consolidated node: All items making up this e.List item have been submitted
				ELSEIF (vLockedCount >0 & vInProgressCount =0 & vNotStartedCount =0 & vReadyCount =0 & vIncompleteCount =0);
					vNewState = cReady;
					IF (vState @<> cReady & vState @<> cLocked);
						CellPutS(vNewState, cStateCube, vNode, 'State');
						If (cGenerateLog @= 'Y');
							TextOutput(cTM1Log, vNode | ' state is changed from ' | vState | ' to Ready 3.' );
						ENDIF;
					ENDIF;
				ENDIF;

			ENDIF;

			looper = looper -1;
		END;

	ENDIF;

	vLevel = vLevel +1;
END;

#***
CubeLockOverride(0);

#*** No error

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
EndIf;


573,1

574,1

575,30


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

IF (SubsetExists(cApprovalDim, vSubset) =1);
SubsetDestroy(cApprovalDim, vSubset);
ENDIF;


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
