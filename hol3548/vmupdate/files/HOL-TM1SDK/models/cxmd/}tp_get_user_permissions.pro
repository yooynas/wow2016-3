601,100
602,"}tp_get_user_permissions"
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
560,5
pGuid
pApplication
pNode
pUser
pControl
561,5
2
2
2
2
2
590,5
pGuid,"None"
pApplication,"None"
pNode,"None"
pUser,"None"
pControl,"N"
637,5
pGuid,
pApplication,
pNode,
pUser,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,179
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
cTM1Process = cControlPrefix | 'tp_get_user_permissions';
StringGlobalVariable('gPrologLog');
StringGlobalVariable('gEpilogLog');
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_log_file_names', 'pExecutionId', pGuid,
'pProcess', cTM1Process, 'pControl', pControl);
If (vReturnValue <> ProcessExitNormal());
ProcessError;
EndIf;
cPrologLog = gPrologLog;
cEpilogLog = gEpilogLog;
cTM1Log = cPrologLog;

cGenerateLog = ATTRS(cControlPrefix | 'tp_config', 'Generate TI Log', 'String Value');

#***log start
currentTime=NOW;
currentDate =TIMST(currentTime,'\Y \M \d - \h:\i:\s');
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Process: ', cTM1Process, ' started at ', currentDate);
EndIf;

#*** Log Parameters

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Parameters:', pGuid, pApplication, pNode, pUser, pControl);
EndIf;

## Check if a login user has permissions on Edit, Submit, Reject, View or Annotate
StringGlobalVariable('gEdit');
StringGlobalVariable('gSubmit');
StringGlobalVariable('gReject');
StringGlobalVariable('gView');
StringGlobalVariable('gAnnotate');

gEdit = 'F';
gSubmit = 'F';
gReject = 'F';
gView = 'F';
gAnnotate = 'F';

vApplicationDim = cControlPrefix | 'tp_applications';
vApplication = DimensionElementPrincipalName(vApplicationDim, pApplication);
vApprovalDim = AttrS(vApplicationDim, vApplication, 'ApprovalDimension');
vNode = '';
IF (DIMIX(vApprovalDim, pNode) >0);
vNode = DimensionElementPrincipalName( vApprovalDim, pNode );
ENDIF;

vPermissionCube = cControlPrefix | 'tp_application_permission}' | pApplication;

#***Check permission cube
IF (CubeExists(vPermissionCube) =0);
ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 'pGuid', pGuid, 'pProcess', cTM1Process,'pStartTime', '', 'pEndTime', currentDate,'pErrorCode', 'TI_CUBE_
NOT_EXIST', 'pStatus', 'ERROR', 'pClientStartTime', '', 'pErrorDetails', vPermissionCube, 'pControl', pControl);
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, vPermissionCube | ' does not exist.');
EndIf;
ProcessError;
ENDIF;

vCube = '}CellSecurity_' | vPermissionCube;
#***Check cell level security cube for permission cube
IF (CubeExists(vCube) =0);
ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 'pGuid', pGuid, 'pProcess', cTM1Process,'pStartTime', '', 'pEndTime', currentDate,'pErrorCode', 'TI_CUBE_
NOT_EXIST', 'pStatus', 'ERROR', 'pClientStartTime', '', 'pErrorDetails', vCube, 'pControl', pControl);
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, vCube | ' does not exist.');
EndIf;
ProcessError;
ENDIF;

vUser = pUser;
vPermissionDim = cControlPrefix | 'tp_permissions';
vGroupDim = '}Groups';

vSubset='user_group_' | pGuid;
if (subsetExists('}Groups', vSubset)<>0);
subsetdestroy('}Groups', vSubset);
endif;

#If a mdx return zero item, SubsetsetCreateByMdx will throw an error
#workaround, add SecurityAdmin as a dummy member
vMDX = '{ FILTER ( [}Groups].Members, [}ClientGroups].( [}Clients].[' | vUser | '] ) <> "" ), [}Groups].[SecurityAdmin]} ';
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'MDX', vMDX);
EndIf;

subsetCreateByMdx(vSubset, vMDX);
SubsetElementInsert('}Groups', vSubset, 'SecurityAdmin', 0);

looper =1;
vSubsetSize = SubsetGetSize('}Groups', vSubset);
while (looper <= vSubsetSize);
vGroup = SubsetGetElementName ('}Groups', vSubset, looper);
IF (UPPER(vGroup) @= 'ADMIN' % UPPER(vGroup) @= 'DATAADMIN');

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'User has ADMIN or DATAADMIN rights');
EndIf;

gEdit = 'T';
gSubmit = 'T';
gReject = 'T';
gView = 'T';
gAnnotate = 'T';

ELSE;

IF (vNode @<> '');

#VIEW permission
vSecurity = CellGetS(vCube, vNode, 'VIEW', vGroup);
IF (UPPER(vSecurity) @= 'READ');
gView = 'T';
ENDIF;

#EDIT permission
vSecurity = CellGetS(vCube, vNode, 'EDIT', vGroup);
IF (UPPER(vSecurity) @= 'READ');
gEdit = 'T';
ENDIF;

#SUBMIT permission
vSecurity = CellGetS(vCube, vNode, 'SUBMIT', vGroup);
IF (UPPER(vSecurity) @= 'READ');
gSubmit = 'T';
ENDIF;

#REJECT permission
vSecurity = CellGetS(vCube, vNode, 'REJECT', vGroup);
IF (UPPER(vSecurity) @= 'READ');
gReject = 'T';
ENDIF;

#ANNOTATE permission
vSecurity = CellGetS(vCube, vNode, 'ANNOTATE', vGroup);
IF (UPPER(vSecurity) @= 'READ');
gAnnotate = 'T';
ENDIF;

ENDIF;

ENDIF;

looper = looper+1;
end;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, gView, gAnnotate, gEdit, gReject, gSubmit);
EndIf;

#*** No error

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'The end has been reached.');
EndIf;

573,1

574,1

575,28
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

IF (SubsetExists('}Groups', vSubset) =1);
SubsetDestroy('}Groups', vSubset);
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
