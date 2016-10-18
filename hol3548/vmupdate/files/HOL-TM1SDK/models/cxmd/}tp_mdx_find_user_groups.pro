601,100
602,"}tp_mdx_find_user_groups"
562,"NULL"
586,
585,
564,
565,"m6wXV`x6xAvvma2TH42nlSC9AI``k82ARF^XM=<cd]]l1;xznpDztG7_W?7vYbX1]M[y1OTUPotisEorvFX3gi:xKY;jyO2Q0Yn8p[SG5G:hlL2FXPOxw7jE^aSyNgRGGDIfchO0Q5ykr0Cn\VngfcN>E9:ZsBQybwmuk@izkutbFfws13;KF6\UETBhlV1udRM;EtuT"
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
572,139


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
cTM1Process = cControlPrefix | 'tp_mdx_find_user_groups';
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

#*** Log Parameters
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:', pGuid, pAppID, pControl);
EndIf;

#*** 

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Check application');
EndIf;

cApplicationsDim = cControlPrefix |  'tp_applications';

If (DimensionExists(cApplicationsDim) = 0);
ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pGuid, 
'pProcess', cTM1Process,
'pErrorCode', 'TI_DIM_NOT_EXIST', 
'pErrorDetails', cApplicationsDim, 
'pControl', pControl);

ProcessError;
EndIf;

If (DIMIX(cApplicationsDim, pAppId) = 0);
ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pGuid, 
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

vReturnValue = ExecuteProcess( cControlPrefix | 'tp_get_application_attributes', 'pExecutionId', pGuid,
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

cGroupDim = '}Groups';
cGroupDimSize = DIMSIZ(cGroupDim);

#*** Check cube

cPermissionCube = cControlPrefix | 'tp_application_permission}' | pAppId;
cCellSecurityCube = '}CellSecurity_' | cPermissionCube;
If (CubeExists(cCellSecurityCube) = 0);
ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pGuid, 
'pProcess', cTM1Process,
'pErrorCode', 'TI_CUBE_NOT_EXIST', 
'pErrorDetails', cCellSecurityCube, 
'pControl', pControl);

ProcessError;
EndIf;

#*** declare global variables
StringGlobalVariable('gMdxFindUserGroups');
StringGlobalVariable('gMdxFindNonUserGroups');

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Find application groups');
EndIf;
vMDX1 = '[' | cCellSecurityCube | '].([' | cControlPrefix | 'tp_permissions].[VIEW], [}Groups].CURRENTMEMBER) = "Read"';
vMDX2 = 'FILTER([' | gApprovalDim | '].MEMBERS, ' | vMDX1 | ')';
vMDX3 = 'FILTER([}Groups].MEMBERS, COUNT(' | vMDX2 | ') > 0)';
gMdxFindUserGroups = vMdx3;
vMDX4 = 'EXCEPT([}Groups].MEMBERS, ' | vMdx3 | ')';
gMdxFindNonUserGroups = vMDX4;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'MDX for application groups', gMdxFindUserGroups);
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'MDX for non-application groups', gMdxFindNonUserGroups);
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
