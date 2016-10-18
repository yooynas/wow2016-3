601,100
602,"}tp_reserve_release_all"
562,"NULL"
586,
585,
564,
565,"wfcvBky;ep><geJNe@IYU8Va0QMTeZ20GRwzTGDQr:3T;p9cYdz@l0D2^>_\PzomiGR<5TvFIZ^<cg]Ag]E];mxUd:[n4T`4l;d_D6I0npd`1Aq]cmidsro??N7qPBC1vvb@9IE5y2uxfqx18z_wDST8lY^DxG0Lf_^r;;X0O?ZXp_]eC8U=tG?rxj_hx`OIxHJfplr4"
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
pAppId
pControl
561,3
2
2
2
590,3
pExecutionId,"None"
pAppId,"MyApp"
pControl,"N"
637,3
pExecutionId,
pAppId,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,145
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


#*** Get lock

#cLockName = 'tp_semaphore';
#Synchronized( cLockName ) ;

#*** Log File Name
cTM1Process = cControlPrefix | 'tp_reserve_release_all';
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

If (cGenerateLog @= 'Y');
	cLogCubeText = 'Release all slices pAppId=' | pAppId | '|User=' | TM1User();
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
EndIf;

cApplicationCubesCube = cControlPrefix | 'tp_application_cubes';
totalCubes = DIMSIZ('}Cubes');
indexCube = 0;

If (cGenerateLog @= 'Y');
	cLogCubeText = 'Reserve cube number cubes to check' | NumberToString(totalCubes);
	TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
EndIf;

While (indexCube < totalCubes);
	cCubeName = DIMNM('}Cubes', indexCube+1);

	If (cGenerateLog @= 'Y');
		cLogCubeText = 'Getting Check Reserve cube flag ' | cCubeName;
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
	EndIf;

	cIsAppCube = CellGetS(cApplicationCubesCube, pAppId, cCubeName);

	If (cGenerateLog @= 'Y');
		cLogCubeText = 'Reserve cube flag ' | cCubeName | ' is ' | cIsAppCube;
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
	EndIf;

	cCubeAddress = '';
	addConcatSymbol = 0;
	If (cIsAppCube @<> '');
		If (cGenerateLog @= 'Y');
			## debug list reservations
			vIndex = 1;
			vDelim = '|';
			vAddress = CubeDataReservationGet( vIndex, cCubeName, '',vDelim);
			If (vAddress @= '');
				cLogCubeText = 'There are no reservations on cube ' | cCubeName;
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
			EndIf;
			WHILE (vAddress @<> '');
				cLogCubeText = 'There is a reservation on cube ' | cCubeName | ' for - ' | vAddress;
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
				vIndex = vIndex + 1;
				vAddress = CubeDataReservationGet( vIndex, cCubeName, '', vDelim);
			End;	
		EndIf;
		dimensionIndex = 1;
		While (dimensionIndex > 0 ); 
			cCubeDimensionName = TABDIM(cCubeName, dimensionIndex);
			If (cCubeDimensionName @= '');
				dimensionIndex = -1;
			Else;
				If (addConcatSymbol > 0);
					cCubeAddress = cCubeAddress | '|';
				Else;
					addConcatSymbol = 1;
				EndIf; 
			EndIf;
			
			If (cGenerateLog @= 'Y');
				cLogCubeText = 'Reserve address = ' | cCubeAddress;
				TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
			EndIf;
			dimensionIndex = dimensionIndex + 1;
		End;
		If (cGenerateLog @= 'Y');
			cLogCubeText = 'Calling CubeDataReservationReleaseAll(' | cCubeName | ',' | cCubeAddress;
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
		EndIf;
		CubeDataReservationReleaseAll(cCubeName, '', cCubeAddress);
	EndIf;
 
	indexCube = indexCube + 1;
	If (cGenerateLog @= 'Y');
		## debug list reservations
		vIndex = 1;
		vDelim = '|';
		vAddress = CubeDataReservationGet( vIndex, cCubeName, '',vDelim);
		If (vAddress @= '');
			cLogCubeText = 'There are no reservations on cube ' | cCubeName;
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
		EndIf;
		WHILE (vAddress @<> '');
			cLogCubeText = 'There is a reservation on cube ' | cCubeName | ' for - ' | vAddress;
			TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), cLogCubeText);
			vIndex = vIndex + 1;
			vAddress = CubeDataReservationGet( vIndex, cCubeName, '', vDelim);
		End;	
	EndIf;
End;


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
