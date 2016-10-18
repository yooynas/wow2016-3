601,100
602,"}tp_create_owner_groups"
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
pAppId,"None"
pControl,"Y"
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

572,191


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
cTM1Process = cControlPrefix | 'tp_create_owner_groups';
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

cLock = 'Lock';
cId = 'Id';
cSemaphoreCube = cControlPrefix | 'tp_semaphore';

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Start getting lock');
EndIf;

CellPutS(pExecutionId, cSemaphoreCube, cLock, cId);

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Finish getting lock');
EndIf;

#*** Log Parameters

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:',
pExecutionId, pAppId, pControl);
EndIf;

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
cApprovalDimSize = DIMSIZ(cApprovalDim);
cApprovalSubsetSize = SubsetGetSize(cApprovalDim, cApprovalSubset);

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 
'tp_get_application_attributes', cApprovalDim, cApprovalSubset, cSecuritySet);
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'),
'gApprovalSubsetComplementMdx', gApprovalSubsetComplementMdx);
EndIf;

#***

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Create owner groups');
EndIf;

vIndex = 1;
While (vIndex <= cApprovalSubsetSize);
vNode = SubsetGetElementName(cApprovalDim, cApprovalSubset, vIndex);
vNodePName = DimensionElementPrincipalName(cApprovalDim, vNode);

vOwnerGroup = cControlPrefix | 'tp_owner_' | cApprovalDim | '_' | vNodePName;
If (DIMIX('}Groups', vOwnerGroup) = 0);
AddGroup(vOwnerGroup);
EndIf;

vIndex = vIndex + 1;
End;

#*** 

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Remove owner groups that are no longer in the approval subset');
EndIf;

If (cApprovalSubsetComplementMdx @<> '');

vApprovalSubsetComplement = 'tp_temp_approval_subset_complement_' | pExecutionId;

SubsetDestroy(cApprovalDim, vApprovalSubsetComplement);
SubsetCreateByMdx(vApprovalSubsetComplement, cApprovalSubsetComplementMdx);

vApprovalSubsetComplementSize = SubsetGetSize(cApprovalDim, vApprovalSubsetComplement);
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'approval subset complement', vApprovalSubsetComplement, NumberToString(vApprovalSubsetComplementSize));
EndIf;

vIndex = 1;
While (vIndex <= vApprovalSubsetComplementSize);
vNode = SubsetGetElementName(cApprovalDim, vApprovalSubsetComplement, vIndex);
vNodePName = DimensionElementPrincipalName(cApprovalDim, vNode);

vOwnerGroup = cControlPrefix | 'tp_owner_' | cApprovalDim | '_' | vNodePName;
If (DIMIX('}Groups', vOwnerGroup) <> 0);
DeleteGroup(vOwnerGroup);
EndIf;

vIndex = vIndex + 1;
End;

SubsetDestroy(cApprovalDim, vApprovalSubsetComplement);

EndIf;

#*** No error

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
EndIf;

573,1

574,1

575,43


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


#*** Log File Name
cTM1Log = cEpilogLog;

#***

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Set element security on approval dimension');
EndIf;

vIndex = 1;
While (vIndex <= cApprovalSubsetSize);
vNode = SubsetGetElementName(cApprovalDim, cApprovalSubset, vIndex);
vNodePName = DimensionElementPrincipalName(cApprovalDim, vNode);

vOwnerGroup = cControlPrefix | 'tp_owner_' | cApprovalDim | '_' | vNodePName;
ElementSecurityPut('WRITE', cApprovalDim, vNodePName, vOwnerGroup);

vIndex = vIndex + 1;
End;

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
