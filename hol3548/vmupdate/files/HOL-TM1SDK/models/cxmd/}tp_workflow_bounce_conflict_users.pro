601,100
602,"}tp_workflow_bounce_conflict_users"
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
pNode
pApprovalDim
pTime
pNewOwnerID
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
pNode,"NA"
pApprovalDim,"NA"
pTime,"0"
pNewOwnerID,"None"
pCheckBouncingOnly,"N"
pBouncingMode,"NEVER"
pControl,"N"
637,9
pExecutionId,
pAppId,
pNode,
pApprovalDim,
pTime,
pNewOwnerID,
pCheckBouncingOnly,
pBouncingMode,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,228
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

#***
if (pApprovalDim @= '');
	StringGlobalVariable('gApprovalDim');
	StringGlobalVariable('gApprovalSubset');
	StringGlobalVariable('gIsActive');

	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_application_attributes', 'pExecutionId', pExecutionId,
		'pAppId', pAppId, 'pControl',  pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;

	pApprovalDim = gApprovalDim;

Endif;
#***

cConfigDim = cControlPrefix | 'tp_config';
If (DimensionExists(cConfigDim) = 1);
	cGenerateLog = ATTRS(cControlPrefix | 'tp_config', 'Generate TI Log', 'String Value');
Else;
	cGenerateLog = 'N';
EndIf;

If (cGenerateLog @= 'Y');
	cLogCubeText = 'parameters: pAppId=' | pAppId | '|pNode=' | pNode | '|pApprovalDim=' | pApprovalDim | '|pTime=' | pTime;
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
EndIf;

cApplicationCubesCube = cControlPrefix | 'tp_application_cubes';
totalCubes = DIMSIZ('}Cubes');
indexCube = 1;

If (cGenerateLog @= 'Y');
	cLogCubeText = 'number cubes to check=' | NumberToString(totalCubes);
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
EndIf;

While (indexCube <= totalCubes);
	cCubeName = DIMNM('}Cubes', indexCube);

	If (cGenerateLog @= 'Y');
		cLogCubeText = 'Getting Check Reserve cube flag ' | cCubeName;
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
	EndIf;

	cIsAppCube = CellGetS(cApplicationCubesCube, pAppId, cCubeName);

	If (cGenerateLog @= 'Y');
		cLogCubeText = 'Reserve cube flag ' | cCubeName | ' is ' | cIsAppCube;
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
	EndIf;

	cCubeAddress = '';
	addConcatSymbol = 0;
	If (cIsAppCube @<> '');
		
		dimensionIndex = 1;
		While (dimensionIndex > 0 ); 
			cCubeDimensionName = TABDIM(cCubeName, dimensionIndex);
			If (cCubeDimensionName @= '');
				dimensionIndex = -1;
			Else;
				If (addConcatSymbol > 0);
					cCubeAddress = cCubeAddress | '|';
				Else;
					addConcatSymbol = 1;
				EndIf; 
				If (cCubeDimensionName @= pApprovalDim);
					cCubeAddress = cCubeAddress | pNode;
					vApprovalDimIndex = dimensionIndex;
				EndIf;
			EndIf;
			
			If (cGenerateLog @= 'Y');
				cLogCubeText = 'Reserve address = ' | cCubeAddress;
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
			EndIf;
			dimensionIndex = dimensionIndex + 1;
		End;

		## get conflict reservations
		## we need two rounds, the first round get all conflict DRs from other users and bounce
		## the second round get overlapping DRs from the same user and bounce
		vRound = 1;
		While (vRound <=2);
			vIndex = 1;
			vDelim = '|';
			If (vRound = 1);
				vConflictAddress =CubeDataReservationGetConflicts(vIndex, cCubeName, pNewOwnerID, cCubeAddress, vDelim) ;
			Else;
				vConflictAddress = CubeDataReservationGet(vIndex, cCubeName, pNewOwnerID,vDelim) ;
			EndIf;

			If (vConflictAddress @= '' & cGenerateLog @= 'Y');
				cLogCubeText = 'There are no conflict reservations on cube ' | cCubeName;
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
			EndIf;
			WHILE (vConflictAddress @<> '' );
				If (cGenerateLog @= 'Y');
					cLogCubeText = 'Conflict reservation on cube ' | cCubeName | ' for - ' | vConflictAddress;
					TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
				EndIf;

				#Get conflict DR time
				vPos = SCAN(vDelim, vConflictAddress);
				vLength=LONG(vConflictAddress);
				vConflictDRTime = SUBST(vConflictAddress, 1, vPos-1);

				#Get conflict DR user
				vConflictAddress=SUBST(vConflictAddress, vPos+1, vLength-vPos);
				vPos = SCAN(vDelim, vConflictAddress);
				vLength=LONG(vConflictAddress);
				vConflictUser = SUBST(vConflictAddress, 1, vPos-1);

				#Get conflict address
				vFinalConflictAddress = SUBST(vConflictAddress, vPos+1, vLength-vPos);

				#Check conflict user privilege on the node
				StringGlobalVariable('gEdit');
				vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_user_permissions', 
					'pGuid', pExecutionId, 'pApplication', pAppId, 'pNode', pNode, 'pUser', vConflictUser, 'pControl', pControl);
				If (vReturnValue <> ProcessExitNormal());
					ProcessError;
				EndIf;

				#Bounce this user's revervation/ownership
				If (gEdit @= 'T');
					vParseAddress = vFinalConflictAddress;
					vParseDimIndex = 1;
					While (vParseDimIndex <> vApprovalDimIndex);
						vParsePos = SCAN(vDelim, vParseAddress);
						vParseAddress = SUBST(vParseAddress, vParsePos+1, LONG(vParseAddress)-vParsePos); 
						vParseDimIndex = vParseDimIndex +1;
					End;
					vParsePos = SCAN(vDelim, vParseAddress);
					IF (vParsePos >0);
						vTakeOwnershipNode = SUBST(vParseAddress, 1, vParsePos-1);
					Else;
						vTakeOwnershipNode  = vParseAddress;
					Endif;

					vDoBounce = 'N';
					IF (vRound = 1 & vConflictUser @<> '' & vTakeOwnershipNode @<> '');
						vDoBounce = 'Y';
					ElseIf (vRound =2 & ELISANC(gApprovalDim, vTakeOwnershipNode, pNode)  =1);
						cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;
						cTakeOwnershipNode = 'TakeOwnershipNode';
						vOwnershipNodeOnCurrentNode = CellGetS(cStateCube, pNode, cTakeOwnershipNode);
						#Don't bounce yourself if ownershipnodes are the same
						#Bounce yourself if ownership nodes are different, applies to rejecting a leaf node
						IF (vOwnershipNodeOnCurrentNode @<> vTakeOwnershipNode);
							vDoBounce = 'Y';
						Endif;
					Endif;

					IF (vDoBounce @='Y');
						vReturnValue = ExecuteProcess(cControlPrefix | 'tp_workflow_bounce_nodes', 'pExecutionId', pExecutionId,'pAppId', pAppId,
						'pOwnerIdToBounce',vConflictUser, 'pOwnershipNodeToBounce', vTakeOwnershipNode,'pSourceNode', pNode, 'pTime', pTime,
						'pCheckBouncingOnly', pCheckBouncingOnly, 'pBouncingMode', pBouncingMode,  'pControl', pControl);

						If (vReturnValue <> ProcessExitNormal());
							ProcessError;
						EndIf;	
		
					Endif;
				EndIf;

				vIndex = vIndex + 1;
				If (vRound = 1);
					vConflictAddress =CubeDataReservationGetConflicts(vIndex, cCubeName, pNewOwnerID, cCubeAddress, vDelim) ;
				Else;
					vConflictAddress = CubeDataReservationGet(vIndex, cCubeName, pNewOwnerID,vDelim) ;
				Endif;

					
			End;	
			
			vRound = vRound +1;
		End;
	EndIf;
 
	indexCube = indexCube + 1;
End;

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
