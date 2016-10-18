601,100
602,"}tp_incr_update_permission_cell_security"
562,"VIEW"
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
560,7
pExecutionId
pAppId
pApprovalDim
pApprovalSubset
pInputView
pReviewerEditOn
pControl
561,7
2
2
2
2
2
2
2
590,7
pExecutionId,"None"
pAppId,"MyApp"
pApprovalDim,"TestElist"
pApprovalSubset,"TestElist"
pInputView,"None"
pReviewerEditOn,"F"
pControl,"N"
637,7
pExecutionId,
pAppId,
pApprovalDim,
pApprovalSubset,
pInputView,
pReviewerEditOn,
pControl,
577,7
vNode
vGroup
vIncremental
vValue
NVALUE
SVALUE
VALUE_IS_STRING
578,7
2
2
2
2
1
2
1
579,7
1
2
3
4
0
0
0
580,7
0
0
0
0
0
0
0
581,7
0
0
0
0
0
0
0
582,0
572,63


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
cTM1Process = cControlPrefix | 'tp_incr_update_permission_cell_security';
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

#*** Log Parameters

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters:',
pExecutionId, pAppId, pApprovalDim, pApprovalSubset, pInputView, pReviewerEditOn, pControl);
EndIf;

#*** 
vCube = cControlPrefix | 'tp_application_security_update}' | pAppId;

#*** Set local variables
DataSourceType='VIEW';
DatasourceNameForServer=vCube ;
DatasourceCubeview=pInputView;

573,1

574,32


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

If (vNode @<>'' & vGroup @<>'' & vValue @='Y');

ExecuteProcess(cControlPrefix | 'tp_incr_update_single_node_and_group', 
'pExecutionId', pExecutionId, 'pAppId', pAppId,
'pApprovalDim', pApprovalDim, 'pApprovalSubset', pApprovalSubset, 
'pUpdateNode', vNode, 'pUpdateGroup', vGroup, 
'pReviewerEditOn',pReviewerEditOn, 'pControl', pControl);

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), vNode, vGroup, vValue);
EndIf;

EndIf;

575,20


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

IF (ViewExists(vCube, pInputView)=1);
ViewDestroy(vCube, pInputView);
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
