601,100
602,"}tp_workflow_update_user_name"
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
pAppId
pUserName
pOldUserName
pControl
561,5
2
2
2
2
2
590,5
pExecutionId,"None"
pAppId,"None"
pUserName,"None"
pOldUserName,"None"
pControl,"Y"
637,5
pExecutionId,
pAppId,
pUserName,
pOldUserName,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,141


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
cTM1Process = cControlPrefix | 'tp_update_user_name';
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
pExecutionId, pAppId, pUserName, pOldUserName, pControl);
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

#*** 

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Update user name in state cube');
EndIf;

cCurrentOwner = 'CurrentOwner';
cCurrentOwnerId = 'CurrentOwnerId';
cStateChangeUser = 'StateChangeUser';
cDataChangeUser = 'DataChangeUser';

cApprovalDimSize = DIMSIZ(gApprovalDim);
vIndex = 1;
While (vIndex <= cApprovalDimSize);
vNodePName = DIMNM(gApprovalDim, vIndex);

vOwnerValue = CellGetS(cStateCube, vNodePName, cCurrentOwner);
vOwnerIdValue = CellGetS(cStateCube, vNodePName, cCurrentOwnerId);
vStateChangeUserValue = CellGetS(cStateCube, vNodePName, cStateChangeUser);
vDataChangeUserValue = CellGetS(cStateCube, vNodePName, cDataChangeUser);

If (vOwnerIdValue @= TM1User);
If (vOwnerValue @<> pUserName);
CellPutS(pUserName, cStateCube, vNodePName, cCurrentOwner);
EndIf;
EndIf;

If (vStateChangeUserValue @= pOldUserName);
CellPutS(pUserName, cStateCube, vNodePName, cStateChangeUser);
EndIf;

If (vDataChangeUserValue @= pOldUserName);
CellPutS(pUserName, cStateCube, vNodePName, cDataChangeUser);
EndIf;

vIndex = vIndex + 1;
End;

#*** 

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Update user name in }Clients');
EndIf;

vDisplayUserName = ATTRS('}Clients', TM1User, '}TM1_DefaultDisplayValue');
If (vDisplayUserName @<> pUserName);
AttrPutS(pUserName, '}Clients', TM1User, '}TM1_DefaultDisplayValue');
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
