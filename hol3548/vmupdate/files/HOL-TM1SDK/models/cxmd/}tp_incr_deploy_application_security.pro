601,100
602,"}tp_incr_deploy_application_security"
562,"CHARACTERDELIMITED"
586,"dummy.txt"
585,"dummy.txt"
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
560,8
pExecutionId
pAppId
pApprovalDim
pApprovalSubset
pReviewerEditOn
pSourceFile
pFullDeploy
pControl
561,8
2
2
2
2
2
2
2
2
590,8
pExecutionId,"None"
pAppId,"MyApp"
pApprovalDim,"plan_business_unit"
pApprovalSubset,"All Business Units"
pReviewerEditOn,"F"
pSourceFile,"dummy.txt"
pFullDeploy,"N"
pControl,"Y"
637,8
pExecutionId,
pAppId,
pApprovalDim,
pApprovalSubset,
pReviewerEditOn,
pSourceFile,
pFullDeploy,
pControl,
577,6
vNode
vGroup
vRight
vViewDepth
vReviewDepth
vAction
578,6
2
2
2
2
2
2
579,6
1
2
3
4
5
6
580,6
0
0
0
0
0
0
581,6
0
0
0
0
0
0
582,0
572,102


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
cTM1Process = cControlPrefix | 'tp_incr_deploy_application_security';
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

#cLockName = 'tp_semaphore';
#Synchronized( cLockName ) ;

#***

CubeLockOverride(1);

#*** Log Parameters

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:',
pExecutionId, pAppId, pApprovalDim, pApprovalSubset, pReviewerEditOn, pSourceFile, pFullDeploy, pControl);
EndIf;

#***
vDimRights = cControlPrefix | 'tp_rights';
vDimRightsMeasures = cControlPrefix | 'tp_security_measures';
vDimRightsUpdateMeasure = cControlPrefix | 'tp_security_update_measures';
vRightsCube = cControlPrefix | 'tp_application_security}' | pAppId;
vCubeUpdates = cControlPrefix | 'tp_application_security_update}' | pAppId;

If (pFullDeploy @= 'Y' & CubeExists(vRightsCube) = 1);
CubeDestroy(vRightsCube);
EndIf;

If (CubeExists(vCubeUpdates) = 1);
CubeDestroy(vCubeUpdates);
EndIf;

If (CubeExists(vRightsCube) = 0);

vReturnValue = ExecuteProcess(cControlPrefix | 'tp_incr_create_update_artifacts', 
'pExecutionId', pExecutionId, 
'pAppId', pAppId, 
'pApprovalDim', pApprovalDim,
'pApprovalSubset', pApprovalSubset,
'pControl', pControl);
If (vReturnValue <> ProcessExitNormal());
ProcessError;
EndIf;

EndIf;

If (pFullDeploy @<> 'Y' & CubeExists(vCubeUpdates) = 0);
	CubeCreate(vCubeUpdates, pApprovalDim, '}Groups', vDimRightsUpdateMeasure);
	CubeSetLogChanges(vCubeUpdates, 1);
EndIf;

#*** Set local variables
DataSourceType = 'CHARACTERDELIMITED';
DatasourceASCIIDelimiter = CHAR(9);
DatasourceASCIIHeaderRecords = 1;
DatasourceNameForServer = pSourceFile;

#*** Set input file encoding as UTF-8
SetInputCharacterSet('TM1CS_UTF8');

573,1

574,88


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

cTM1Log = cDataLog;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), vNode, vGroup, vRight, vViewDepth, vReviewDepth, vAction);
EndIf;
#IF (1)
If (DIMIX(pApprovalDim, vNode) >0 & DIMIX('}Groups', vGroup) >0);

vNodePName = DimensionElementPrincipalName(pApprovalDim, vNode);
vGroupPName = DimensionElementPrincipalName('}Groups', vGroup);

#IF (2)
If (vAction @= 'D');
CellPutS('', vRightsCube, vNodePName,vGroupPName, vRight, 'Rights');
CellPutS('', vRightsCube,vNodePName,vGroupPName, vRight, 'ViewDepth');
CellPutS('', vRightsCube, vNodePName, vGroupPName, vRight, 'ReviewDepth');
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Delete action: ' | vAction);
EndIf;
#IF (2)
Else;

If (vRight @<> '');
CellPutS(vRight, vRightsCube, vNodePName, vGroupPName, vRight, 'Rights');
CellPutS(vViewDepth, vRightsCube, vNodePName, vGroupPName, vRight, 'ViewDepth');
CellPutS(vReviewDepth, vRightsCube, vNodePName,vGroupPName, vRight, 'ReviewDepth');
Else;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Right is empty, so do not add to rights cube', vNodePName, vGroupPName);
EndIf;

EndIf;

#IF (2)
EndIf;

#IF (3)
IF (pFullDeploy @<> 'Y');
vChildrenSubset = 'tp_temp_children_' | pExecutionId | vAction;
vMdxAllDescendants = 'Descendants([' | pApprovalDim | '].[' | vNodePName | '])';
IF (SubsetExists(pApprovalDim, vChildrenSubset) =1);
SubsetDestroy(pApprovalDim, vChildrenSubset);
ENDIF;
SubsetCreateByMDX(vChildrenSubset, vMdxAllDescendants);
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_util_convert_dynamic_subset_to_static', 'pExecutionId', pExecutionId,
'pDim', pApprovalDim, 'pSubset', vChildrenSubset);
If (vReturnValue <> ProcessExitNormal());
	ProcessError;
EndIf;

vChildrenSubsetSize = SubsetGetSize(pApprovalDim, vChildrenSubset);
vIndex = 1;
While (vIndex <= vChildrenSubsetSize);
vChild = SubsetGetElementName(pApprovalDim, vChildrenSubset, vIndex);
vChildPName = DimensionElementPrincipalName(pApprovalDim, vChild);
vCellValue = CellGetS(vCubeUpdates, vChildPName, vGroupPName, 'Incremental');
IF (vCellValue @= '');
CellPutS('Y', vCubeUpdates, vChildPName, vGroupPName, 'Incremental');
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), vChildPName, vGroupPName);
EndIf;
ENDIF;

vIndex = vIndex +1;
END;

SubsetDestroy(pApprovalDim, vChildrenSubset);
ENDIF;
#IF (3)
#IF (1)
EndIf;
575,78


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

#Create a view in update cube with items that are not in approval subset
#then zero out the view

#IF (1)
IF (pFullDeploy @<>'Y');
vDimSize = DIMSIZ(pApprovalDim);
vSubsetSize = SubsetGetSize(pApprovalDim, pApprovalSubset);
vZeroOutMdx = '';
IF (vDimSize > vSubsetSize);

If (CubeExists(pApprovalDim) = 0);
vZeroOutMdx= 'EXCEPT([' | pApprovalDim | '].MEMBERS, TM1SubsetToSet([' | pApprovalDim | '], "' | pApprovalSubset | '"))';
Else;
vZeroOutMdx = 'EXCEPT([' | pApprovalDim | '].MEMBERS, TM1SubsetToSet([' | pApprovalDim | '].[' | pApprovalDim | '], "' | pApprovalSubset | '"))';
EndIf;

ENDIF;

vTempView ='tp_temp_zeroout_nonapproval_' | pExecutionId;
vTempSubset = vTempView;
IF (SubsetExists(pApprovalDim, vTempSubset) = 1);
SubsetDestroy(pApprovalDim, vTempSubset);
ENDIF;

IF (ViewExists(vCubeUpdates, vTempView) =1);
ViewDestroy(vCubeUpdates, vTempView);
ENDIF;

IF (vZeroOutMdx @<> '');
ViewCreate(vCubeUpdates, vTempView);
ViewRowDimensionSet(vCubeUpdates, vTempView, pApprovalDim, 1);
ViewRowDimensionSet(vCubeUpdates, vTempView, '}Groups', 2);
ViewRowDimensionSet(vCubeUpdates, vTempView, 'tp_rights_update_measures', 3);
SubsetCreatebyMDX(vTempSubset, vZeroOutMdx);
ViewSubsetAssign(vCubeUpdates, vTempView, pApprovalDim, vTempView);
ViewZeroOut(vCubeUpdates, vTempView);
ViewDestroy(vCubeUpdates, vTempView);
SubsetDestroy(pApprovalDim, vTempSubset);
ENDIF;


#Create a view in update cube with
#all elements in approval dimension
#all groups in }Groups dimension
#suppress zero is turned on
#This view will be used row by row later to udpate cell level security cube
vViewUpdate = 'tp_temp_records_for_processing_' | pExecutionId;
ViewCreate(vCubeUpdates, vViewUpdate);
ViewRowDimensionSet(vCubeUpdates, vViewUpdate, pApprovalDim, 1);
ViewRowDimensionSet(vCubeUpdates, vViewUpdate, '}Groups', 2);
ViewColumnDimensionSet(vCubeUpdates, vViewUpdate, 'tp_rights_update_measures', 3);
ViewSuppressZeroesSet(vCubeUpdates, vViewUpdate, 1);

ExecuteProcess(cControlPrefix | 'tp_incr_update_permission_cell_security', 'pExecutionId', pExecutionId, 'pAppId', pAppId, 'pApprovalDim', pApprovalDim, 'pApprovalSubset', p
ApprovalSubset, 'pInputView', vViewUpdate, 'pReviewerEditOn', pReviewerEditOn, 'pControl', pControl);

#IF (1)
ENDIF;

#***
CubeLockOverride(0);

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
