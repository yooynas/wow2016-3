601,100
602,"}tp_util_is_in_subset"
562,"NULL"
586,
585,
564,
565,"qoopAxxAYh;T20gFkaVi8[HS<0CKg=S=go7yMCL5<O64Sim4XeBsX?2i_TFP_UxPbeaCTD;te17:r=a44PbBn@:5V<nHw[nn0[BUCJ6mY1zxszK_A3GmP4[d1NtRnk6i_3sUWCFmT>VD=rlPbOX0CVlxA7TwGfVMB6JpF;pH<BJj4yqk6x<;rovtDG:juz_2`Rm=f1sI"
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
pDim
pSubset
pNode
pControl
561,5
2
2
2
2
2
590,5
pExecutionId,"None"
pDim,"None"
pSubset,"None"
pNode,"None"
pControl,"Y"
637,5
pExecutionId,
pDim,
pSubset,
pNode,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,140


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
cTM1Process = cControlPrefix | 'tp_util_is_in_subset';
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

#***

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters: ', pDim, pSubset, pNode, pControl);
EndIf;

#***

StringGlobalVariable('gIsInSubset');

If (DimensionExists(pDim) = 0);
ProcessError;
EndIf;

If (SubsetExists(pDim, pSubset) = 0);
ProcessError;
EndIf;

gIsInSubset = 'N';
#IF(1)
If (DIMIX(pDim, pNode) <> 0);

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Node is in dimension', pNode, pDim);
EndIf;

cNodePName = DimensionElementPrincipalName(pDim, pNode);

cSubsetSize = SubsetGetSize(pDim, pSubset);
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Subset size: ' | NumberToString(cSubsetSize));
EndIf;

#IF(1.1)
If (cSubsetSize > 1);

If (CubeExists(pDim) = 0);
vMDX = 'EXCEPT(TM1SubsetToSet([' | pDim | '], "' | pSubset | '"), {[' | pDim | '].[' | cNodePName | ']})';
Else;
vMDX = 'EXCEPT(TM1SubsetToSet([' | pDim | '].[' | pDim | '] , "' | pSubset | '"), {[' | pDim | '].[' | cNodePName | ']})';
EndIf;
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'MDX: ', vMDX);
EndIf;

cSubsetLess = 'tp_temp_less_' | pExecutionId;
SubsetDestroy(pDim, cSubsetLess);
SubsetCreateByMdx(cSubsetLess, vMDX);

If (cSubsetSize > SubsetGetSize(pDim, cSubsetLess));
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Node is in subset(0)');
EndIf;
gIsInSubset = 'Y';
Else;
gIsInSubset = 'N';
EndIf;

SubsetDestroy(pDim, cSubsetLess);

#IF(1.1)
ElseIf (cSubsetSize = 1);

cOnlyMember = SubsetGetElementName(pDim, pSubset, 1);
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Only member: ' | cOnlyMember);
EndIf;
cOnlyMemberPName = DimensionElementPrincipalName(pDim, cOnlyMember);
If (cOnlyMemberPName @= cNodePName);
If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Node is in subset(1)');
EndIf;
gIsInSubset = 'Y';
Else;
gIsInSubset = 'N';
EndIf;

#IF(1.1)
Else

gIsInSubset = 'N';

EndIf;

EndIf;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'gIsInSubset: ' | gIsInSubset);
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
