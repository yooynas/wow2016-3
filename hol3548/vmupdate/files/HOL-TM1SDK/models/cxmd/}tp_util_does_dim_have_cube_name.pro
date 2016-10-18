601,100
602,"}tp_util_does_dim_have_cube_name"
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
560,3
pExecutionId
pDim
pControl
561,3
2
2
2
590,3
pExecutionId,"None"
pDim,"None"
pControl,"Y"
637,3
pExecutionId,
pDim,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,92


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
cTM1Process = cControlPrefix | 'tp_util_does_dim_have_cube_name';
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
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters: ', pDim, pControl);
EndIf;

#***

If (DimensionExists(pDim) = 0);
ProcessError;
EndIf;

StringGlobalVariable('gDoesDimHaveCubeName');
gDoesDimHaveCubeName = 'N';

If (CubeExists(pDim) <> 0);
gDoesDimHaveCubeName = 'Y';
EndIf;

If (gDoesDimHaveCubeName @= 'Y');
vFindDim = 'N';
cCube = pDim;
vIndex = 1;
While (vIndex > 0);
vCubeDim = TABDIM(cCube, vIndex);

If (vCubeDim @= '');
vIndex = -1;
ElseIf (vCubeDim @= pDim);
vIndex = -1;
vFindDim = 'Y';
EndIf;

vIndex = vIndex + 1;
End;

If (vFindDim @= 'N');
vReturnValue = ExecuteProcess(cControlPrefix | 'tp_error_update_error_cube', 
'pGuid', pExecutionId, 
'pProcess', cTM1Process, 
'pErrorCode', 'TI_DIM_CUBE_SAME_NAME',
'pErrorDetails', pDim,
'pControl', pControl);

ProcessError;
EndIf;

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
