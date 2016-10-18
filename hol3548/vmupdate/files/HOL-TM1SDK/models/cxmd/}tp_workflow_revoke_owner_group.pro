601,100
602,"}tp_workflow_revoke_owner_group"
562,"NULL"
586,
585,
564,
565,"fvkFjAavvgW4I:[HVXPy26?5:B3>wD4ugrZ3>KY``6]JyP4?8wj@>OS_<@FJtD]VB]^qkGukxm`_@5MGP0fj]Aj`Ft6EsTb7@Co0BS8=v`[Oluv`B@5Yvahuy_LW?8DMc^FUbkpm6n2w@9[ArQLJL\=cQRL8[oUN@M<H>7r2>@>mH;^WC1@MsHU@WvJ39wA9dWDPeUej"
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
560,4
pExecutionId
pAppId
pNode
pControl
561,4
2
2
2
2
590,4
pExecutionId,"None"
pAppId,"None"
pNode,"None"
pControl,"N"
637,4
pExecutionId,
pAppId,
pNode,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
931,1

572,128


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
cTM1Process = cControlPrefix | 'tp_workflow_revoke_owner_group';
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
'Parameters:', pExecutionId, pAppId, pNode, pControl);
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

vNodePName = DimensionElementPrincipalName(gApprovalDim, pNode);

vOwnerGroup = cControlPrefix | 'tp_owner_' | gApprovalDim | '_' | vNodePName;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Revoke owner group', vOwnerGroup);
EndIf;

If (DIMIX('}Groups', vOwnerGroup) = 0);
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pExecutionId, 
'pProcess', cTM1Process, 
'pErrorCode', 'TI_NODE_NOT_EXIST',
'pErrorDetails', '}Groups' | ', ' | vOwnerGroup,
'pControl', pControl);

ProcessError;
EndIf;

vMDX = '{FILTER([}Clients].MEMBERS, [}ClientGroups].([}Clients].CURRENTMEMBER, [}Groups].[' | vOwnerGroup | ']) <> ""), [}Clients].[Admin]}';
vSubset = 'tp_current_owner_' | pExecutionId;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'MDX', vMDX);
EndIf;

SubsetDestroy('}Clients', vSubset);
SubsetCreateByMdx(vSubset, vMDX);

vSubsetSize = SubsetGetSize('}Clients', vSubset);

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'Subset', vSubset, NumberToString(vSubsetSize));
EndIf;

vIndex = vSubsetSize;
While (vIndex >= 1);
vOwner = SubsetGetElementName('}Clients', vSubset, vIndex);
vOwnerPName = DimensionElementPrincipalName('}Clients', vOwner);

If (vOwnerPName @<> 'Admin');
RemoveClientFromGroup(vOwnerPName, vOwnerGroup);
EndIf;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, 'RemoveClientFromGroup', vOwnerPName, vOwnerGroup);
EndIf;

vIndex = vIndex - 1;
End;

SubsetDestroy('}Clients', vSubset);

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
