601,100
602,"}tp_incr_update_single_node_and_group"
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
560,8
pExecutionId
pAppId
pApprovalDim
pApprovalSubset
pUpdateNode
pUpdateGroup
pReviewerEditOn
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
pApprovalDim,"TestElist"
pApprovalSubset,"TestElist"
pUpdateNode,"None"
pUpdateGroup,"None"
pReviewerEditOn,"F"
pControl,"N"
637,8
pExecutionId,
pAppId,
pApprovalDim,
pApprovalSubset,
pUpdateNode,
pUpdateGroup,
pReviewerEditOn,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,287
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
cTM1Process = cControlPrefix | 'tp_incr_update_single_node_and_group';
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
pExecutionId, pAppId, pApprovalDim, pApprovalSubset, pUpdateNode, pUpdateGroup, pReviewerEditOn, pControl);
EndIf;

#***
cCubeSecurityCube = '}CubeSecurity';
cDimensionSecurityCube = '}DimensionSecurity';
cElementAttributesPrefix = '}ElementAttributes_';
cNone = 'NONE';
cRead = 'READ';
cWrite = 'WRITE';
cLock = 'WRITE';
vLeafElementSecurity = cREAD;

#***
vUpdateNodePName = DimensionElementPrincipalName(pApprovalDim, pUpdateNode);
vUpdateGroupPName = DimensionElementPrincipalName('}Groups', pUpdateGroup);
vRightsCube = cControlPrefix | 'tp_application_security}' | pAppId;
vCellSecurityCube = '}CellSecurity_' | cControlPrefix | 'tp_application_permission}' | pAppId;

vIsLeafNode = 'T';
If (DTYPE(pApprovalDim, vUpdateNodePName) @= 'C');
vIsLeafNode = 'F';
Else;
vIsLeafNode = 'T';
EndIf;

vSetElementSecurity = 'F';
ElementSecurityPut('NONE', pApprovalDim, vUpdateNodePName, vUpdateGroupPName);
CellPutS('NONE', vCellSecurityCube, vUpdateNodePName, 'VIEW', vUpdateGroupPName);
CellPutS('NONE', vCellSecurityCube, vUpdateNodePName, 'ANNOTATE', vUpdateGroupPName);
CellPutS('NONE', vCellSecurityCube, vUpdateNodePName, 'EDIT', vUpdateGroupPName);
CellPutS('NONE', vCellSecurityCube, vUpdateNodePName, 'SUBMIT', vUpdateGroupPName);
CellPutS('NONE', vCellSecurityCube, vUpdateNodePName, 'REJECT', vUpdateGroupPName);

#*** assign rights to self
vSelfRightView = CELLGETS(vRightsCube, vUpdateNodePName, vUpdateGroupPName, 'VIEW', 'Rights');
vSelfRightEdit = CELLGETS(vRightsCube, vUpdateNodePName, vUpdateGroupPName, 'EDIT', 'Rights');
vSelfRightSubmit = CELLGETS(vRightsCube, vUpdateNodePName, vUpdateGroupPName, 'SUBMIT', 'Rights');
vSelfRightReview = CELLGETS(vRightsCube, vUpdateNodePName, vUpdateGroupPName, 'REVIEW', 'Rights');

#IF (1)
IF (vSelfRightView @= 'VIEW');
	CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'VIEW', vUpdateGroupPName);
	vLeafElementSecurity = cREAD;
	vSetElementSecurity = 'T';
#IF (1)
ENDIF;

#IF (2)
IF (vSelfRightEdit @='EDIT');

	#IF (2.1)
	IF (vIsLeafNode @= 'T');

		CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'EDIT', vUpdateGroupPName);
		CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'ANNOTATE', vUpdateGroupPName);
		CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'VIEW', vUpdateGroupPName);
		vLeafElementSecurity = cWrite;
		vSetElementSecurity = 'T';

	#IF (2.1)
	ENDIF;

#IF (2)
ENDIF;

#IF (3)
IF (vSelfRightSubmit @='SUBMIT');
	CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'SUBMIT', vUpdateGroupPName);

	IF (vIsLeafNode @= 'T');
		CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'EDIT', vUpdateGroupPName);
	ENDIF;

	CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'ANNOTATE', vUpdateGroupPName);
	CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'VIEW', vUpdateGroupPName);
	vLeafElementSecurity = cLock;
	vSetElementSecurity = 'T';

#IF (3)
ENDIF;

#IF (4)
IF (vSelfRightReview @='REVIEW');

	IF (vIsLeafNode @= 'F');
		CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'ANNOTATE', vUpdateGroupPName);
		CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'VIEW', vUpdateGroupPName);
		vSetElementSecurity = 'T';
	ENDIF;

#IF (4)
ENDIF;

#*** Pass rights down from ancestors

#First get all ancestors in the approval subset
vMdx = 'HIERARCHIZE({intersect ([' | pApprovalDim | '].[' | vUpdateNodePName | '].AncestorsAll, [' ;
vMdx = vMDx | pApprovalDim | '].[' | pApprovalSubset | '])})';

vSubsetAncestors = 'get_ancestors_' | pExecutionId;
If (SubsetExists(pApprovalDim, vSubsetAncestors) <>0);
	SubsetDestroy(pApprovalDim, vSubsetAncestors);
EndIf;
SubsetCreateByMdx(vSubsetAncestors, vMdx, pApprovalDim);
SubsetElementInsert(pApprovalDim, vSubsetAncestors , vUpdateNodePName, 0);

vSize = SubsetGetSize(pApprovalDim, vSubsetAncestors);

vLooper =vSize;
vLevel = 0;
WHILE (vLooper > 0);
	vParent = SubsetGetElementName(pApprovalDim, vSubsetAncestors, vLooper);
	If (vParent @<>vUpdateNodePName );
		vLevel = vLevel +1;
		If (cGenerateLog @= 'Y');
			TextOutput(cTM1Log, 'Passing down rights to' |  vUpdateNodePName, 
				'Ancestor: ' | NumberToString(vLevel), ' ' | vParent);
		EndIf;
		vParentRightView = CELLGETS(vRightsCube, vParent, vUpdateGroupPName, 'VIEW', 'Rights');
		vParentRightSubmit =  CELLGETS(vRightsCube, vParent, vUpdateGroupPName, 'SUBMIT', 'Rights');
		vParentRightReview =  CELLGETS(vRightsCube, vParent, vUpdateGroupPName, 'REVIEW', 'Rights');

		vParentViewDepth = 0;
		vTempValue = CELLGETS(vRightsCube, vParent, vUpdateGroupPName, 'VIEW', 'ViewDepth');
		If (vTempValue @<> '');
			vParentViewDepth = StringToNumber(vTempValue);
		EndIf;
		vTempValue = CELLGETS(vRightsCube, vParent, vUpdateGroupPName, 'SUBMIT', 'ViewDepth');
		If (vTempValue @<> '' & StringToNumber(vTempValue) > vParentViewDepth);
			vParentViewDepth = StringToNumber(vTempValue);
		EndIf;
		vTempValue = CELLGETS(vRightsCube, vParent, vUpdateGroupPName, 'REVIEW', 'ViewDepth');
		If (vTempValue @<> '' & StringToNumber(vTempValue) > vParentViewDepth);
			vParentViewDepth = StringToNumber(vTempValue);
		EndIf;

		vParentReviewDepth = 0;
		vTempValue = CELLGETS(vRightsCube, vParent, vUpdateGroupPName, 'REVIEW', 'ReviewDepth');
		If (vTempValue @<> '');
			vParentReviewDepth = StringToNumber(vTempValue);
		EndIf;
		vTempValue = CELLGETS(vRightsCube, vParent, vUpdateGroupPName, 'SUBMIT', 'ReviewDepth');
		If (vTempValue @<> '' & StringToNumber(vTempValue) > vParentReviewDepth);
			vParentReviewDepth = StringToNumber(vTempValue);
		EndIf;

		vCellValueView = CellGetS(vCellSecurityCube, vUpdateNodePName, 'VIEW', vUpdateGroupPName);
		vCellValueEdit = CellGetS(vCellSecurityCube, vUpdateNodePName, 'EDIT', vUpdateGroupPName);
		vCellValueAnnotate = CellGetS(vCellSecurityCube, vUpdateNodePName, 'ANNOTATE', vUpdateGroupPName);
		vCellValueReject = CellGetS(vCellSecurityCube, vUpdateNodePName, 'REJECT', vUpdateGroupPName);
		vCellValueSubmit = CellGetS(vCellSecurityCube, vUpdateNodePName, 'SUBMIT', vUpdateGroupPName);

		#IF (5)
		IF ((vParentRightView @= 'VIEW' % vParentRightSubmit @= 'SUBMIT' % 
     			vParentRightReview @='REVIEW') & vParentViewDepth >= vLevel);
			IF (vCellValueView @<> 'READ');
				CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'VIEW', vUpdateGroupPName);
			ENDIF;
			IF (vLeafElementSecurity @<> cWrite &  vLeafElementSecurity @<> cLock);
				vLeafElementSecurity = cRead;			
			Endif;
			vSetElementSecurity = 'T';

		#IF (5)
		ENDIF;

		#IF (6)
		IF ((vParentRightSubmit @= 'SUBMIT' % vParentRightReview @='REVIEW') &
    			 vParentReviewDepth >= vLevel);

			IF (vCellValueReject @<> 'READ');
				CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'REJECT', vUpdateGroupPName);
			ENDIF;
			IF (vCellValueAnnotate @<> 'READ');
				CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'ANNOTATE', vUpdateGroupPName);
			ENDIF;
			IF (vCellValueView @<> 'READ');
				CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'VIEW', vUpdateGroupPName);
			ENDIF;

			#*** Add additional privileges with reviewer edit on
			IF (pReviewerEditOn @= 'T');

				IF (vCellValueSubmit @<> 'READ');
					CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'SUBMIT', vUpdateGroupPName);
				ENDIF;

				IF (vIsLeafNode @= 'T');

					IF (vCellValueEdit @<> 'READ');
						CellPutS('READ', vCellSecurityCube, vUpdateNodePName, 'EDIT', vUpdateGroupPName);
					ENDIF;

					IF (vLeafElementSecurity @<> cLock );
						vLeafElementSecurity = cLock;
					ENDIF;

				ENDIF;

			ENDIF;

			vSetElementSecurity = 'T';
		#IF (6)
		ENDIF;

	EndIf;

	vLooper = vLooper -1 ;

END;

cApplicationsDim = cControlPrefix | 'tp_applications';
If (vSetElementSecurity @= 'T');
	IF (vIsLeafNode @= 'T');
		ElementSecurityPut(vLeafElementSecurity, pApprovalDim, vUpdateNodePName, vUpdateGroupPName);
	ELSE;
		ElementSecurityPut(cWrite, pApprovalDim, vUpdateNodePName, vUpdateGroupPName);
	ENDIF;
	ElementSecurityPut('READ', cApplicationsDim, pAppId, vUpdateGroupPName);
	cElementAttributes = cElementAttributesPrefix | pApprovalDim;
	If (DimensionExists(cElementAttributes) <> 0);
		CellPutS('READ', cDimensionSecurityCube, cElementAttributes, vUpdateGroupPName);
	EndIf;
	If (CubeExists(cElementAttributes) <> 0);
		CellPutS('READ', cCubeSecurityCube, cElementAttributes, vUpdateGroupPName);
	EndIf;
Else;
	ElementSecurityPut('NONE', pApprovalDim, vUpdateNodePName, vUpdateGroupPName);
	CellPutS('', vCellSecurityCube, vUpdateNodePName, 'VIEW', vUpdateGroupPName);
	CellPutS('', vCellSecurityCube, vUpdateNodePName, 'ANNOTATE', vUpdateGroupPName);
	CellPutS('', vCellSecurityCube, vUpdateNodePName, 'EDIT', vUpdateGroupPName);
	CellPutS('', vCellSecurityCube, vUpdateNodePName, 'SUBMIT', vUpdateGroupPName);
	CellPutS('', vCellSecurityCube, vUpdateNodePName, 'REJECT', vUpdateGroupPName);
EndIf;


573,1

574,1

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


If (SubsetExists(pApprovalDim, vSubsetAncestors) <>0);
	SubsetDestroy(pApprovalDim, vSubsetAncestors);
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
