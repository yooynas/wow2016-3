601,100
602,"}tp_admin_application_users"
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
560,2
pExecutionId
pControl
561,2
2
2
590,2
pExecutionId,"None"
pControl,"Y"
637,2
pExecutionId,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,134


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
cTM1Process = cControlPrefix | 'tp_admin_application_users';
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
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:',
		pExecutionId, pControl);
EndIf;

#*** Check everyone group
cEveryoneGroup = cControlPrefix | 'tp_Everyone';
If (DIMIX('}Groups', cEveryoneGroup) = 0);
	vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube',
		'pGuid', pExecutionId,
		'pProcess', cTM1Process,
		'pErrorCode', 'TI_NODE_NOT_EXIST',
		'pErrorDetails', '}Groups' | ', ' | cEveryoneGroup,
		'pControl', pControl);
	
	ProcessError;
EndIf;

#*** 
vMDX = '{FILTER([}Clients].MEMBERS, [}ClientGroups].[}Groups].[' | cEveryoneGroup | '] = ""), [}Clients].[Admin]}';
cNewUsersSubset = 'tp_temp_new_users_' | pExecutionId;

If (SubsetExists('}Clients', cNewUsersSubset) > 0);
	SubsetDestroy('}Clients', cNewUsersSubset);
EndIf;

SubsetCreateByMdx(cNewUsersSubset, vMDX);

cNewUsersSubsetSize = SubsetGetSize('}Clients', cNewUsersSubset);
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'New user count: ' | TRIM(STR(cNewUsersSubsetSize, 5, 0)));
EndIf;

cClientsDimSize = DIMSIZ('}Clients');
If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'All user count: ' | TRIM(STR(cClientsDimSize, 5, 0)));
EndIf;

If (cClientsDimSize < 2*cNewUsersSubsetSize);

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Add all users');
	EndIf;
	
	vIndex = 1;
	While (vIndex <= cClientsDimSize);
		vClient = DIMNM('}Clients', vIndex);
		
		AssignClientToGroup(vClient, cEveryoneGroup);
		
		vIndex = vIndex + 1;
	End;

Else;

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'Only add new users');
	EndIf;

	vRealIndex = 1;
	vIndex = 1;
	While (vIndex <= cNewUsersSubsetSize);
		vClient = SubsetGetElementName('}Clients', cNewUsersSubset, vRealIndex);
		
		If (vClient @<> 'Admin');
			AssignClientToGroup(vClient, cEveryoneGroup);
		Else;
			vRealIndex = vRealIndex + 1;
		EndIf;
		
		vIndex = vIndex + 1;
	End;

EndIf;

If (SubsetExists('}Clients', cNewUsersSubset) > 0);
	SubsetDestroy('}Clients', cNewUsersSubset);
Endif;

#*** No error

If (cGenerateLog @= 'Y');
	TextOutput(cTM1Log, 'The end has been reached.');
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
