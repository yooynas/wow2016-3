601,100
602,"}tp_clean_approval_owner_groups"
562,"NULL"
586,
585,
564,
565,"qcJ5kNZvf2ymDYhhvaX5:vovi>bP^5Hyom18]n5><VBrYj4@3LC1\wK]fN?rBU_kBzrHvnBkwov1ZFssdQKae`LYLq9Uhz[o;IJF8ds8h0MD`:sYcRXn15QY6[emXR2FbwY4V?QMhQ5_mTENBR9]FgAzhxenl1^Nv4Tlyv5sQlX=YW8aZjNf>d<cakE`h]e:uz_t?602"
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
pExecutionId
pAppId
pControl
561,3
2
2
2
590,3
pExecutionId,"None"
pAppId,"MyApp"
pControl,"N"
637,3
pExecutionId,
pAppId,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
931,1

572,149


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
cTM1Process = cControlPrefix | 'tp_clean_approval_owner_groups';
StringGlobalVariable('gPrologLog');
StringGlobalVariable('gEpilogLog');
vReturnValue = ExecuteProcess( cControlPrefix | 'tp_get_log_file_names', 'pExecutionId', pExecutionId,
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
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:', pExecutionId, pAppID,  pControl);
EndIf;

#*** 

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Check application');
EndIf;

cApplicationsDim = cControlPrefix |  'tp_applications';

If (DimensionExists(cApplicationsDim) = 0);
ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pExecutionId, 
'pProcess', cTM1Process,
'pErrorCode', 'TI_DIM_NOT_EXIST',
'pErrorDetails', cApplicationsDim, 
'pControl', pControl);

ProcessError;
EndIf;

If (DIMIX(cApplicationsDim, pAppId) = 0);
ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pExecutionId, 
'pProcess', cTM1Process,
'pErrorCode', 'TI_NODE_NOT_EXIST',
'pErrorDetails', pAppId, 
'pControl', pControl);

ProcessError;
EndIf;

#*** 

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Get Approval dimension and subset');
EndIf;

StringGlobalVariable('gApprovalDim');
StringGlobalVariable('gApprovalSubset');

vReturnValue = ExecuteProcess( cControlPrefix | 'tp_get_application_attributes', 'pExecutionId', pExecutionId,
'pAppId', pAppId, 'pControl',  pControl);
If (vReturnValue <> ProcessExitNormal());
ProcessError;
EndIf;

cApprovalDim = gApprovalDim;
cApprovalSubset = gApprovalSubset;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Approval Dimension: ' | cApprovalDim);
TextOutput(cTM1Log, 'Approval Subset: ' | cApprovalSubset);
EndIf;

#*** 

cStateCube = cControlPrefix | 'tp_application_state}' | pAppId;
cCurrentOwner = 'CurrentOwner';

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
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'clean owner groups');
EndIf;

cApprovalDimSize = DIMSIZ(gApprovalDim);
vIndex = 1;
While (vIndex <= cApprovalDimSize);
vNodePName = DIMNM(gApprovalDim, vIndex);

vOwner = CellGetS(cStateCube, vNodePName, cCurrentOwner);
If (DIMIX('}Clients', vOwner) <> 0);
vOwnerGroup = cControlPrefix | 'tp_owner_' | gApprovalDim | '_' | vNodePName;
If (DIMIX('}Groups', vOwnerGroup) <> 0);
vOwnerPName = DimensionElementPrincipalName('}Clients', vOwner);
RemoveClientFromGroup(vOwnerPName, vOwnerGroup);
EndIf;
EndIf;

vIndex = vIndex + 1;
End;

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
