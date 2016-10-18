601,100
602,"}tp_util_export_cube"
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
560,4
pExecutionId
pCube
pBlob
pControl
561,4
2
2
2
2
590,4
pExecutionId,"None"
pCube,"None"
pBlob,"None"
pControl,"Y"
637,4
pExecutionId,
pCube,
pBlob,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,209


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

DatasourceASCIIDelimiter = char(9);
DatasourceASCIIQuoteCharacter='';

cControlPrefix = '';
If (pControl @= 'Y');
cControlPrefix = '}';
EndIf;

#*** Log File Name
cTM1Process = cControlPrefix | 'tp_util_export_cube';
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
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Parameters: ', pExecutionId, pCube, pBlob, pControl);
EndIf;

#***

If (CubeExists(pCube) = 0);
ProcessError;
EndIf;

cDimMax = 4;

vIndex = 1;
While (vIndex <> 0);

vDim = TABDIM(pCube, vIndex);
If (vDim @<> '');
vIndex = vIndex + 1;
Else;
cDimCount = vIndex - 1;
vIndex = 0;
EndIf;

End;

If (cGenerateLog @= 'Y');
TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'Dimension Count: ', NumberToString(cDimCount));
EndIf;

If (cDimCount > cDimMax);
ProcessError;
EndIf;

#***

#* Cube-2
If (cDimCount = 2);

cDim1 = TABDIM(pCube, 1);
cDim2 = TABDIM(pCube, 2);

cDim1Size = DIMSIZ(cDim1);
cDim2Size = DIMSIZ(cDim2);

vIndex1 = 1;
While (vIndex1 <= cDim1Size);
vElement1 = DIMNM(cDim1, vIndex1);

vIndex2 = 1;
While (vIndex2 <= cDim2Size);
vElement2 = DIMNM(cDim2, vIndex2);

If (DTYPE(cDim2, vElement2) @= 'S');
vValue = CellGetS(pCube, vElement1, vElement2);
Else;
vValue = NumberToString(CellGetN(pCube, vElement1, vElement2));
EndIf;

SetOutputCharacterSet(pBlob | '.blb', 'TM1CS_UTF8');
TextOutput(pBlob | '.blb', vElement1, vElement2, vValue);

vIndex2 = vIndex2 + 1;
End;
vIndex1 = vIndex1 + 1;
End;

#* Cube-3
ElseIf (cDimCount = 3);

cDim1 = TABDIM(pCube, 1);
cDim2 = TABDIM(pCube, 2);
cDim3 = TABDIM(pCube, 3);

cDim1Size = DIMSIZ(cDim1);
cDim2Size = DIMSIZ(cDim2);
cDim3Size = DIMSIZ(cDim3);

vIndex1 = 1;
While (vIndex1 <= cDim1Size);
vElement1 = DIMNM(cDim1, vIndex1);

vIndex2 = 1;
While (vIndex2 <= cDim2Size);
vElement2 = DIMNM(cDim2, vIndex2);

vIndex3 = 1;
While (vIndex3 <= cDim3Size);
vElement3 = DIMNM(cDim3, vIndex3);

If (DTYPE(cDim3, vElement3) @= 'S');
vValue = CellGetS(pCube, vElement1, vElement2, vElement3);
Else;
vValue = NumberToString(CellGetN(pCube, vElement1, vElement2, vElement3));
EndIf;

SetOutputCharacterSet(pBlob | '.blb', 'TM1CS_UTF8');
TextOutput(pBlob | '.blb', vElement1, vElement2, vElement3, vValue);

vIndex3 = vIndex3 + 1;
End;
vIndex2 = vIndex2 + 1;
End;
vIndex1 = vIndex1 + 1;
End;

#* Cube-4
ElseIf (cDimCount = 4);

cDim1 = TABDIM(pCube, 1);
cDim2 = TABDIM(pCube, 2);
cDim3 = TABDIM(pCube, 3);
cDim4 = TABDIM(pCube, 4);

cDim1Size = DIMSIZ(cDim1);
cDim2Size = DIMSIZ(cDim2);
cDim3Size = DIMSIZ(cDim3);
cDim4Size = DIMSIZ(cDim4);

vIndex1 = 1;
While (vIndex1 <= cDim1Size);
vElement1 = DIMNM(cDim1, vIndex1);

vIndex2 = 1;
While (vIndex2 <= cDim2Size);
vElement2 = DIMNM(cDim2, vIndex2);

vIndex3 = 1;
While (vIndex3 <= cDim3Size);
vElement3 = DIMNM(cDim3, vIndex3);

vIndex4 = 1;
While (vIndex4 <= cDim4Size);
vElement4 = DIMNM(cDim4, vIndex4);

If (DTYPE(cDim4, vElement4) @= 'S');
vValue = CellGetS(pCube, vElement1, vElement2, vElement3, vElement4);
Else;
vValue = NumberToString(CellGetN(pCube, vElement1, vElement2, vElement3, vElement4));
EndIf;

SetOutputCharacterSet(pBlob | '.blb', 'TM1CS_UTF8');
TextOutput(pBlob | '.blb', vElement1, vElement2, vElement3, vElement4, vValue);

vIndex4 = vIndex4 + 1;
End;
vIndex3 = vIndex3 + 1;
End;
vIndex2 = vIndex2 + 1;
End;
vIndex1 = vIndex1 + 1;
End;

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
