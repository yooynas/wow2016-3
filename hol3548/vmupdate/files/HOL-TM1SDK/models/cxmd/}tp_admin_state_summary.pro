﻿601,100
602,"}tp_admin_state_summary"
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
560,4
pExecutionId
pAppId
pSummaryReportPath
pControl
561,4
2
2
2
2
590,4
pExecutionId,"None"
pAppId,"MyApp"
pSummaryReportPath,"C:\temp\state_summary.csv"
pControl,"Y"
637,4
pExecutionId,
pAppId,
pSummaryReportPath,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,204


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

DatasourceASCIIDelimiter = ',';
DatasourceASCIIQuoteCharacter='';

# Find application id.
cApplicationsDim = cControlPrefix | 'tp_applications';
If (DIMIX(cApplicationsDim, pAppId) = 0);
vAppId = DIMNM(cApplicationsDim, 1);
Else;
vAppId = pAppId;
EndIf;

cStateCube = cControlPrefix | 'tp_application_state}' | vAppId;
If (CubeExists(cStateCube) = 0);
ProcessError;
EndIf;

# Define elements for approval node info
cNodeInfoDim = cControlPrefix | 'tp_node_info';

cState = 'State';
cViewed = 'Viewed';
cSaved = 'Saved';
cReviewed = 'Reviewed';
cBeingEdited = 'BeingEdited';
cCurrentOwner = 'CurrentOwner';
cCurrentOwnerId = 'CurrentOwnerId';
cStartEditingDate = 'StartEditingDate';
cStateChangeUser = 'StateChangeUser';
cStateChangeDate = 'StateChangeDate';
cDataChangeUser = 'DataChangeUser';
cDataChangeDate = 'DataChangeDate';

# define state values
cNotStarted = '0';
cIncomplete = '1';
cWorkInProgress = '2';
cReady = '3';
cLocked = '4';

# Get approval hierarchy
StringGlobalVariable('gApprovalDim');
StringGlobalVariable('gApprovalSubset');
StringGlobalVariable('gIsActive');

vReturnValue = ExecuteProcess(cControlPrefix | 'tp_get_application_attributes', 'pExecutionId', pExecutionId,
'pAppId', vAppId, 'pControl',  pControl);
If (vReturnValue <> ProcessExitNormal());
ProcessError;
EndIf;

# Define report variables
vC_NotStarted_Name = 'Contributor (Not Started)';
vC_NotStarted_Count = 0;
vC_WorkInProgress_Name = 'Contributor (Work In Progress)';
vC_WorkInProgress_Count = 0;
vC_Incomplete_Name = 'Contributor (Incomplete)';
vC_Incomplete_Count = 0;
vC_Ready_Name = 'Contributor (Ready)';
vC_Ready_Count = 0;
vC_Locked_Name = 'Contributor (Locked)';
vC_Locked_Count = 0;
vC_Viewed_Name = 'Contributor (Viewed)';
vC_Viewed_Count = 0;
vC_Saved_Name = 'Contributor (Saved)';
vC_Saved_Count = 0;
vC_Reviewed_Name = 'Contributor (Reviewed)';
vC_Reviewed_Count = 0;

vR_NotStarted_Name = 'Reviewer (Not Started)';
vR_NotStarted_Count = 0;
vR_WOrkInProgress_Name = 'Reviewer (Work In Progress)';
vR_WorkInProgress_Count = 0;
vR_Incomplete_Name = 'Reviewer (Incomplete)';
vR_Incomplete_Count = 0;
vR_Ready_Name = 'Reviewer (Ready)';
vR_Ready_Count = 0;
vR_Locked_Name = 'Reviewer (Locked)';
vR_Locked_Count = 0;
vR_Viewed_Name = 'Reviewer (Viewed)';
vR_Viewed_Count = 0;
vR_Saved_Name = 'Reviewer (Saved)';
vR_Saved_Count = 0;
vR_Reviewed_Name = 'Reviewer (Reviewed)';
vR_Reviewed_Count = 0;

### Count nodes based on status
cApprovalSubsetSize = SubsetGetSize(gApprovalDim, gApprovalSubset);
vIndex = 1;
While (vIndex <= cApprovalSubsetSize);
vNode = SubsetGetElementName(gApprovalDim, gApprovalSubset, vIndex);
vType = DTYPE(gApprovalDim, vNode);

# state
vValue = CellGetS(cStateCube, vNode, cState);
If (vType @= 'C');
If (vValue @= '1');
vR_Incomplete_Count = vR_Incomplete_Count + 1;
ElseIf (vValue @= '2');
vR_WorkInProgress_Count = vR_WorkInProgress_Count + 1;
ElseIf (vValue @= '3');
vR_Ready_Count = vR_Ready_Count + 1;
ElseIf (vValue @= '4');
vR_Locked_Count = vR_Locked_Count + 1;
Else;
vR_NotStarted_Count = vR_NotStarted_Count + 1;
EndIf;
Else;
If (vValue @= '1');
vC_Incomplete_Count = vC_Incomplete_Count + 1;
ElseIf (vValue @= '2');
vC_WorkInProgress_Count = vC_WorkInProgress_Count + 1;
ElseIf (vValue @= '3');
vC_Ready_Count = vC_Ready_Count + 1;
ElseIf (vValue @= '4');
vC_Locked_Count = vC_Locked_Count + 1;
Else;
vC_NotStarted_Count = vC_NotStarted_Count + 1;
EndIf;
EndIf;

# Viewed
vValue = CellGetS(cStateCube, vNode, cViewed);
If (vType @= 'C');
If (vValue @= 'Y');
vR_Viewed_Count = vR_Viewed_Count + 1;
EndIf;
Else;
If (vValue @= 'Y');
vC_Viewed_Count = vC_Viewed_Count + 1;
EndIf;
EndIf;

# Saved
vValue = CellGetS(cStateCube, vNode, cSaved);
If (vType @= 'C');
If (vValue @= 'Y');
vR_Saved_Count = vR_Saved_Count + 1;
EndIf;
Else;
If (vValue @= 'Y');
vC_Saved_Count = vC_Saved_Count + 1;
EndIf;
EndIf;

# Reviewed
vValue = CellGetS(cStateCube, vNode, cReviewed);
If (vType @= 'C');
If (vValue @= 'Y');
vR_Reviewed_Count = vR_Reviewed_Count + 1;
EndIf;
Else;
If (vValue @= 'Y');
vC_Reviewed_Count = vC_Reviewed_Count + 1;
EndIf;
EndIf;

vIndex = vIndex + 1;
End;

### Create report
TextOutPut(pSummaryReportPath, vC_NotStarted_Name, NumberToString(vC_NotStarted_Count));
TextOutPut(pSummaryReportPath, vC_Incomplete_Name, NumberToString(vC_Incomplete_Count));
TextOutPut(pSummaryReportPath, vC_WorkInProgress_Name, NumberToString(vC_WorkInProgress_Count));
TextOutPut(pSummaryReportPath, vC_Ready_Name, NumberToString(vC_Ready_Count));
TextOutPut(pSummaryReportPath, vC_Locked_Name, NumberToString(vC_Locked_Count));
TextOutPut(pSummaryReportPath, vC_Viewed_Name, NumberToString(vC_Viewed_Count));
TextOutPut(pSummaryReportPath, vC_Saved_Name, NumberToString(vC_Saved_Count));
TextOutPut(pSummaryReportPath, vC_Reviewed_Name, NumberToString(vC_Reviewed_Count));

TextOutPut(pSummaryReportPath, vR_NotStarted_Name, NumberToString(vR_NotStarted_Count));
TextOutPut(pSummaryReportPath, vR_Incomplete_Name, NumberToString(vR_Incomplete_Count));
TextOutPut(pSummaryReportPath, vR_WorkInProgress_Name, NumberToString(vR_WorkInProgress_Count));
TextOutPut(pSummaryReportPath, vR_Ready_Name, NumberToString(vR_Ready_Count));
TextOutPut(pSummaryReportPath, vR_Locked_Name, NumberToString(vR_Locked_Count));
TextOutPut(pSummaryReportPath, vR_Viewed_Name, NumberToString(vR_Viewed_Count));
TextOutPut(pSummaryReportPath, vR_Saved_Name, NumberToString(vR_Saved_Count));
TextOutPut(pSummaryReportPath, vR_Reviewed_Name, NumberToString(vR_Reviewed_Count));




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
