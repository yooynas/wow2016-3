601,100
602,"zSYS.Process.Execute"
562,"NULL"
586,
585,
564,
565,"xYG;p<e0wwW<Osfd?sy18T@`a<VRi_A1CV0^v6\S0g^RFhR5MvH4soD^D[IA2@R73xiui4zIZ2wz;5FgzA7Xi5>cfH6]xK:zK0q^06hFtd4d4b\HTkY29srQ\sQ60O[ff7RMpa@A7up]eYG0D:<@<PJ[03L]r_>g^a0yR6N8kqR?W5_VkOSZ2:Ja5A>r3]EZ03nTHC[e"
559,0
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,2
Select	*
From 	[].[];
567,","
588,"."
589,
568,""""
570,
571,All
569,0
592,0
599,1000
560,5
pProcess
pParamArray
pParamDelim
pParamValueStartDelim
pDebug
561,5
2
2
2
2
1
590,5
pProcess,""
pParamArray,""
pParamDelim,"&"
pParamValueStartDelim,":"
pDebug,0
637,5
pProcess,"The process to run"
pParamArray,"Array of parameters and parameter values e.g. pParam1:Value1&pParam2:Value2. Leave blank if process has no params or run with all default values"
pParamDelim,"Delimiter between parameters"
pParamValueStartDelim,"Delimiter between parameter name and parameter value"
pDebug,"Debug 0=false 1=true"
577,0
578,0
579,0
580,0
581,0
582,0
931,1
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
603,0
572,1178
######################
#**** COPYRIGHT CUBEWISE SERVICES AG
######################

#****Begin: Generated Statements***
#****End: Generated Statements****

######################
### Purpose:
### To execute ANY process in the TM1 instance
### End users need access to this process ONLY
### The process serves as a wrapper to call any process.  Note: a maximum of 24 parameters is allowed for
### This process does not use the standard logging script as it will always be calling another process which itself should be logged

######################
### Logging - common script 	###~ START
sThisProcName = GetProcessName();
### Params
sProcLogParams = 'pProcess:' | pProcess |' & '| 'pParamArray:' | pParamArray |' & '| 'pParamDelim:' | pParamDelim |' & '| 'pParamValueStartDelim:' | pParamValueStartDelim |' & '| 'pDebug:' | NumberToString(pDebug);
pDoProcessLogging = 1;
### Params
IF( pDoProcessLogging = 1 );
  cCubTgt = '';
  sProcLogCube = 'zSYS Process Execution Log';
  sCubLogCube = 'zSYS Cube Last Updated by Process';
  nProcessStartTime = Now();
  nProcessFinishTime = 0;
  nMetaDataRecordCount = 0;
  nDataRecordCount = 0;
  NumericGlobalVariable( 'PrologMinorErrorCount' );  PrologMinorErrorCount = 0;
  NumericGlobalVariable( 'MetadataMinorErrorCount' );  MetadataMinorErrorCount = 0;
  NumericGlobalVariable( 'DataMinorErrorCount' );  DataMinorErrorCount = 0;
  NumericGlobalVariable( 'ProcessReturnCode' );  ProcessReturnCode = 0;
  sProcessErrorLogFile = '';
  sProcessRunBy = TM1User();
  IF( DimIx( '}Clients', sProcessRunBy ) > 0 );
    sProcessRunBy = IF( AttrS( '}Clients', sProcessRunBy, '}TM1_DefaultDisplayValue' ) @= '', sProcessRunBy, AttrS( '}Clients', sProcessRunBy, '}TM1_DefaultDisplayValue' ) );
  EndIF;
  sLogYear = TimSt( nProcessStartTime, '\Y' );
  sLogDay = TimSt( nProcessStartTime, '\m-\d' );
  sLogMinute = TimSt( nProcessStartTime, '\h:\i' );
  sLogSecond = TimSt( nProcessStartTime, '\s' );

  nProcessExecutionIndex = CellGetN( sProcLogCube, 'All zSYS Time Year', 'Total Year', 'Total Day', 'Total Minute', sThisProcName, 'nProcessStartedFlag' ) + 1;
  nProcessExecutionIntraDayIndex = CellGetN( sProcLogCube, sLogYear, sLogDay, 'Total Day', 'Total Minute', sThisProcName, 'nProcessStartedFlag' ) + 1;

  nTotalLogTime = 2;
  sYear01 = sLogYear; sYear02 = sLogYear;
  sDay01 = sLogDay; sDay02 = 'D000';
  sMinute01 = sLogMinute; sMinute02 = 'Total Day Entry';
  sSecond01 = sLogSecond; sSecond02= 'Last Entry';
  
  nCountTime = 1;
  While ( nCountTime <= nTotalLogTime );
     sLoggingYear = Expand( '%sYear' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );
     sLoggingDay = Expand( '%sDay' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );
     sLoggingMinute = Expand( '%sMinute' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );
     sLoggingSecond = Expand( '%sSecond' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );

     CellPutN( nProcessStartTime, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessStartTime' );
     CellPutN( 1, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessStartedFlag' );
     CellPutN( nProcessExecutionIndex, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessExecutionIndex' );
     CellPutN( nProcessExecutionIntraDayIndex, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessExecutionIntraDayIndex' );
     CellPutS( sProcessRunBy, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'sRunBy' );
     CellPutS( sProcLogParams, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'sParams' );
     nCountTime = nCountTime + 1;
  End;
EndIF;
IF( CellGetN( 'zSYS Process Parallelization Control', sThisProcName, 'Disabled' ) <> 0 ); ProcessQuit; EndIF;

### Logging - common script 	###~ END
######################

# After logging initialize turn off ( turn back on later if >= 7 parameters )
pDoProcessLogging = 0;

######################
### Prolog script commences

### Inits - declare constants

cCubSettings = 	'zSYS Settings';
cDimExitCode = 	'zSYS ProcessExit Code';

cDebugDir =  	CellGetS( cCubSettings, 'Location: Debugging', 'String' );
cDebugDir = 	cDebugDir | IF( SubSt( cDebugDir, Long( cDebugDir ) , 1 ) @= '\', '', '\' );
cTimeStamp = 	TimSt( Now, '\Y\m\d\h\i\s' );
cDebugFile = 	cDebugDir | GetProcessName() | '.' | cTimeStamp | '.Debug';

cCubProcInfo = 	'zSYS Process Parameters Info';
cDimProc = 	'zSYS Processes';
cDimParamIdx = 	'zSYS Process Parameters';
cDimProcMeas = 	'zSYS Process Parameters Info Measure';

cTM1RunTI = 	CellGetS( cCubSettings, 'Location: TM1RunTI', 'String' );
cTM1RunTIConf = 	CellGetS( cCubSettings, 'Location: TM1RunTI Config', 'String' );
cBatchPath = 	CellGetS( cCubSettings, 'Location: Scripts', 'String' );
cAdminHost = 	CellGetS( cCubSettings, 'TM1 Admin Host', 'String' );
cServerName = 	CellGetS( cCubSettings, 'TM1 Server Name', 'String' );
sCmd = 		'"' | cTM1RunTI | '"' | ' -i ' | '"' | cTm1RunTIConf | '"' | ' -process ' | '"' | pProcess | '"' | ' ';

nRet = 		0;
nErr = 		0;
sErr = 		'';

### Initialise Debug ###

If( pDebug >= 1 );
  DatasourceASCIIQuoteCharacter = '';

  # Set debug file name
  sDebugFile = cDebugFile | '.Prolog.txt';

  # Log start time
  AsciiOutput( sDebugFile, 'Process Started: ' | TimSt( Now, '\d-\m-\Y \h:\i:\s' ) );

  # Log parameters
  AsciiOutput( sDebugFile, 'Parameters: ' );
  AsciiOutput( sDebugFile, 'pProcess: ' | pProcess );
  AsciiOutput( sDebugFile, 'pParamArray: ' | pParamArray );
  AsciiOutput( sDebugFile, 'pParamDelim: ' | pParamDelim );
  AsciiOutput( sDebugFile, 'pParamValueStartDelim: ' | pParamValueStartDelim );
  AsciiOutput( sDebugFile, '' );

EndIf;

### Test parameters

IF( DimIx( '}Processes', pProcess ) = 0 );
  nErr = nErr + 1;
  sErr = sErr | IF( sErr @= '', '', ' & ' ) | 'Invalid process: ' | pProcess;
Else;
  IF( DimIx( cDimProc, pProcess ) = 0 );
    nErr = nErr + 1;
    sErr = sErr | IF( sErr @= '', '', ' & ' ) | pProcess | ' has not been added to ' | cDimProc;
  EndIF;
EndIF;

IF( CellGetN( 'zSYS Process Parallelization Control', pProcess, 'zSYS.Process.Execute Disabled' ) <> 0 ); 
  nErr = nErr + 1;
  sErr = sErr | IF( sErr @= '', '', ' & ' ) | 'Process not allowed to be run from zSYS.Process.Execute: ' | pProcess;
EndIF;

IF( nErr > 0 );
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, '' );
    AsciiOutput( sDebugFile, sErr );
  EndIf;
  ItemReject( sErr );
EndIF;

### If the param array is empty then just run the process

IF( pParamArray @= '' );
  IF( pDebug >= 1 );
    AsciiOutput( sDebugFile, '' );
    AsciiOutput( sDebugFile, 'Running process with no parameters.' );
  EndIF;  
  nParamCount = 0;
  # If pParamArray is blank then SKIP the whole following section! 
Else;
####################
  # the EndIF for this test is after the looping through pParamArray
  nParams = CellGetN( cCubProcInfo, pProcess, 'All zSYS Process Parameters', 'Count' );
  sParamDelim = TRIM( pParamDelim );
  sParamValueStartDelim = TRIM( pParamValueStartDelim );
####################

### Test pParamArray parameter

IF( pParamDelim @= '' );
  nErr = nErr + 1;
  sErr = sErr | IF( sErr @= '', '', ' & ' ) | 'pParamDelim cannot be blank if a parameter array is passed!';
EndIF;

IF( pParamValueStartDelim @= '' );
  nErr = nErr + 1;
  sErr = sErr | IF( sErr @= '', '', ' & ' ) | 'pParamValueStartDelim cannot be blank if a parameter array is passed!';
EndIF;

IF( Scan( pParamValueStartDelim, pParamArray ) = 0 );
  nErr = nErr + 1;
  sErr = sErr | IF( sErr @= '', '', ' & ' ) | 'Parameter array does not contain pParamValueStartDelim.';
EndIF;

### Test RunTI Params
# Only if the number of params >= 7 as we allow for 2^6 = 64 possibilities of string/nueric param combinations but 128 starts to stretch it a bit far
# Only execute internally above 6 params if either all string or all numeric
# Otherwise external call to TM1RunTI

IF( nParams > 6 );

  IF( FileExists( cTM1RunTIConf ) = 0 );
    nErr = nErr + 1;
    sErr = sErr | IF( sErr @= '', '', ' & ' ) | 'RunTI config file not found: ' | cTM1RunTIConf;
  EndIF;

  IF( FileExists( cTM1RunTI ) = 0 );
    nErr = nErr + 1;
    sErr = sErr | IF( sErr @= '', '', ' & ' ) | 'RunTI not found: ' | cTM1RunTI;
  EndIF;

EndIF;

### Break if any errors

IF( nErr > 0 );
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, '' );
    AsciiOutput( sDebugFile, sErr );
  EndIf;
  ItemReject( sErr );
EndIF;

### Declare parameter variables x24

IF( nParams > 0 );
  P1_name = ''; P1_value = ''; P1_isString = 1;
  P2_name = ''; P2_value = ''; P2_isString = 1;
  P3_name = ''; P3_value = ''; P3_isString = 1;
  P4_name = ''; P4_value = ''; P4_isString = 1;
  P5_name = ''; P5_value = ''; P5_isString = 1;
  P6_name = ''; P6_value = ''; P6_isString = 1;
  P7_name = ''; P7_value = ''; P7_isString = 1;
  P8_name = ''; P8_value = ''; P8_isString = 1;
  P9_name = ''; P9_value = ''; P9_isString = 1;
  P10_name = ''; P10_value = ''; P10_isString = 1;
  P11_name = ''; P11_value = ''; P11_isString = 1;
  P12_name = ''; P12_value = ''; P12_isString = 1;
  P13_name = ''; P13_value = ''; P13_isString = 1;
  P14_name = ''; P14_value = ''; P14_isString = 1;
  P15_name = ''; P15_value = ''; P15_isString = 1;
  P16_name = ''; P16_value = ''; P16_isString = 1;
  P17_name = ''; P17_value = ''; P17_isString = 1;
  P18_name = ''; P18_value = ''; P18_isString = 1;
  P19_name = ''; P19_value = ''; P19_isString = 1;
  P20_name = ''; P20_value = ''; P20_isString = 1;
  P21_name = ''; P21_value = ''; P21_isString = 1;
  P22_name = ''; P22_value = ''; P22_isString = 1;
  P23_name = ''; P23_value = ''; P23_isString = 1;
  P24_name = ''; P24_value = ''; P24_isString = 1;
EndIF;

### Process pParamArray to extract the parameter names and values

sParamArray = 	TRIM( pParamArray );
nChar = 		1;
nCharCount = 	LONG( sParamArray );
sWord = 		'';
sLastDelim = 	'';
nParamCount = 	0;
sParamType = 	'';
nIndex = 		1;

# Add a trailing param delimiter so that the last parameter value is picked up
If( nCharCount > 0 );
  sParamArray = sParamArray | pParamDelim;
  nCharCount = nCharCount + LONG( sParamDelim );
EndIf;

# Commence the loop on pParamArray 
WHILE ( nChar <= nCharCount );

    sChar = SUBST( sParamArray, nChar, 1 );
    If( pDebug >= 1 );
      sMessage = 'Next character is: ' | sChar | ' at ' | NumberToString( nChar );
      AsciiOutput( sDebugFile, sMessage );
    EndIf;

    # Used for delimiters, required for multiple character dilimiters
    sDelim = '';
    nAddExtra = 0;

    # Ignore spaces
    IF (TRIM( sChar ) @<> '' );

      ### Parameter Name ###

      # If the delimiter is more than 1 character peek ahead the same amount
      # Ignore the first character
      sDelim = sChar;
      nCount = LONG( sParamValueStartDelim ) - 1;
      If( nCount > 0 & nChar + nCount <= nCharCount );
        # Add the extra characters
        sDelim = sDelim | SUBST( sParamArray, nChar + 1, nCount );
        # Move to the end of the delimter
        nAddExtra = nCount;
      EndIf;

      If( sDelim @= sParamValueStartDelim );

        sChar = sDelim;

        If( sLastDelim @<> '' & sLastDelim @<> sParamDelim );
            sMessage = 'The name of a parameter must follow a parameter delimiter (' | sParamDelim | ')';
            If( pDebug >= 1 );
              AsciiOutput( sDebugFile, sMessage );
            EndIf;
            ProcessQuit;
        EndIf;

        sParamName = sWord;
        nParamCount = nParamCount + 1;

        If( pDebug >= 1 );
          sMessage = 'Found parameter name: ' | sParamName | ' at ' | NumberToString( nChar );
          AsciiOutput( sDebugFile, '' );
          AsciiOutput( sDebugFile, sMessage );
        EndIf;

        ### Determine if the parameter is a member of the process ###
        nCount = 1;
        nParamIndex = 0;
        While( nCount <= nParams );
          sParamCountName = CellGetS( cCubProcInfo, pProcess, 'P' | NumberToString( nCount ), 'Parameter' );
          IF( sParamName @= sParamCountName );
             sParamType = CellGetS( cCubProcInfo, pProcess, 'P' | NumberToString( nCount ), 'Type' );
             nParamIndex = nCount;
             nCount = nParams;
          ENDIF;
          nCount = nCount + 1;
        End;

        If( nParamIndex = 0 );
            # The parameter does not exist in the process. Cancel process
            sMessage = 'The parameter: ' | sParamName | ' is not a member of: '| pProcess | 'process.';
            If( pDebug >= 1 );
              AsciiOutput( sDebugFile, sMessage );
            EndIf;
            nErr = nErr + 1;
            ProcessQuit;
        Else;
          If( pDebug >= 1 );
            sMessage = 'Parameter type is ' | sParamType;
            AsciiOutput( sDebugFile, sMessage );
            AsciiOutput( sDebugFile, '' );
          EndIf;
        EndIf;

        nIndex = 1;

        sLastDelim = sChar;
        # Clear the word
        sWord = '';
      Else;

        # Reset extra chars
        nAddExtra = 0;

        ### Check both both parameter delimiter and parameter value delimiter ###
        nIsDelimiter = 0;

        ## Check parameter delimiter first
        # If the delimiter is more than 1 character peek ahead the same amount
        # Ignore the first character
        sDelim = sChar;
        nCount = LONG( sParamDelim ) - 1;
        If( nCount > 0 & nChar + nCount <= nCharCount );
          # Add the extra characters
          sDelim = sDelim | SUBST( sParamArray, nChar + 1, nCount);
          # Move to the end of the delimter
          nAddExtra = nCount;
        EndIf;

        If( sDelim @= sParamDelim );
          nIsDelimiter = 1;
          sChar = sDelim;
        Else;
          # Reset extra chars
          nAddExtra = 0;

          ## Check param value delimiter

          # If the delimiter is more than 1 character peek ahead the same amount
          # Ignore the first character
          sDelim = sChar;
          nCount = LONG( sParamValueStartDelim ) - 1;
          If( nCount > 0 & nChar + nCount <= nCharCount );
            # Add the extra characters
            sDelim = sDelim | SUBST( sParamArray, nChar + 1, nCount);
            # Move to the end of the delimter
            nAddExtra = nCount;
          EndIf;

          If( sDelim @= sParamValueStartDelim );
            nIsDelimiter = 1;
            sChar = sDelim;
          Else;
            # Reset extra chars
            nAddExtra = 0;
          EndIf;

        EndIf;

        If ( nIsDelimiter = 1 );

          If( sLastDelim @= '' % sLastDelim @= sParamDelim );
            sMessage = 'A value delimiter must follow a parameter  name: ' |  sChar | ' (' | NumberToString( nChar ) | ')';
            If( pDebug >= 1 );
              AsciiOutput( sDebugFile, sMessage );
            EndIf;
            ProcessQuit;
          EndIf;

          sParamValue = sWord;

          If( pDebug >= 1 );
            sMessage = 'Found parameter value: ' | sParamValue | ' at ' | NumberToString( nChar );
            AsciiOutput( sDebugFile, sMessage );
            AsciiOutput( sDebugFile, '' );
          EndIf;

          # Build the TM1RunTI command string
          # always include trailing space
          sCmd = sCmd | sParamName |'='| IF( sParamType @= 'S', '"', '' ) | sParamValue | IF( sParamType @= 'S', '"', '' ) | ' ';

          # Set the Pn_name, Pn_value and Pn_isNumber variables
          IF( nParamCount = 1 );
            P1_name = sParamName; P1_value = sParamValue; P1_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 2 );
            P2_name = sParamName; P2_value = sParamValue; P2_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 3 );
            P3_name = sParamName; P3_value = sParamValue; P3_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 4 );
            P4_name = sParamName; P4_value = sParamValue; P4_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 5 );
            P5_name = sParamName; P5_value = sParamValue; P5_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 6 );
            P6_name = sParamName; P6_value = sParamValue; P6_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 7 );
            P7_name = sParamName; P7_value = sParamValue; P7_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 8 );
            P8_name = sParamName; P8_value = sParamValue; P8_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 9 );
            P9_name = sParamName; P9_value = sParamValue; P9_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 10 );
            P10_name = sParamName; P10_value = sParamValue; P10_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 11 );
            P11_name = sParamName; P11_value = sParamValue; P11_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 12 );
            P12_name = sParamName; P12_value = sParamValue; P12_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 13 );
            P13_name = sParamName; P13_value = sParamValue; P13_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 14 );
            P14_name = sParamName; P14_value = sParamValue; P14_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 15 );
            P15_name = sParamName; P15_value = sParamValue; P15_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 16 );
            P16_name = sParamName; P16_value = sParamValue; P16_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 17 );
            P17_name = sParamName; P17_value = sParamValue; P17_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 18 );
            P18_name = sParamName; P18_value = sParamValue; P18_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 19 );
            P19_name = sParamName; P19_value = sParamValue; P19_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 20 );
            P20_name = sParamName; P20_value = sParamValue; P20_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 21 );
            P21_name = sParamName; P21_value = sParamValue; P21_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 22 );
            P22_name = sParamName; P22_value = sParamValue; P22_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 23 );
            P23_name = sParamName; P23_value = sParamValue; P23_isString = IF( sParamType @= 'S', 1, 0 );
          ElseIF( nParamCount = 24 );
            P24_name = sParamName; P24_value = sParamValue; P24_isString = IF( sParamType @= 'S', 1, 0 );
          Else;
            sMessage = 'The maximum allowable number of parameters has been exceeded!';
            If( pDebug >= 1 );
              AsciiOutput( sDebugFile, sMessage );
            EndIf;
            ProcessQuit;
          EndIF;

          nIndex = nIndex + 1;

          sLastDelim = sChar;

          # Clear the word
          sWord = '';
        Else;
          sWord = sWord | sChar;
        EndIf;

      EndIf;

    EndIf;

    nChar = nChar + nAddExtra + 1;

    If( pDebug >= 1 );
      sMessage = 'Current word is: ' | sWord | ' at ' | NumberToString(nChar - 1);
      AsciiOutput( sDebugFile, sMessage );
    EndIf;

END;

# Exit pParamArray test
EndIF;

# Run the sub-process based on the number of parameters passed in

IF( pDebug >= 1 );
  IF( nParamCount >= 1 );
    sMessage = 'Running target process with ' | NumberToString( nParamCount ) | ' parameters.'; 
    AsciiOutput( sDebugFile, '' );
    AsciiOutput( sDebugFile, sMessage );
  EndIF; 
  IF( nParamCount >= 7 );
    sMessage = 'Eponential explosion of string/numeric parameter combinations. Process will be executed by TM1RunTI.'; 
    AsciiOutput( sDebugFile, sMessage );
  EndIF; 
EndIF; 

### 
### NOTE !
### Due to how TI works as 1st time a variable is set it is immutable in terns of value type string/numeric and a process parameter is traated like a variable meas that the following is not possible ...
### ExecuteProcess( pProcess, P1_name, IF( P1_isString, P1_Value, StringToNumber( P1_value ) ), P2_name, IF( P2_isString, P2_Value, StringToNumber( P2_value ) ) );
### This would have been much more elegant but it isn't possible. Therefore we handle as many combinations as possible with branching if logic but after processes using more than 6 parameters
### (64 conbinations) then rather than ExecuteProcess use TM1RunTI unless parameters are all of the same type.
### If >= 7 parameters being used then we use process logging to capture the process as the target process will be with the RunTI user not the original user, otherwise we lose the record of who called the TI
###

######################
### Logging - common script

IF( nParamCount >= 7 ); pDoProcessLogging = 1; EndIF;

### Params
IF( pDoProcessLogging = 1 );
  # All the variables for the logging are already set in the first logging declarations
  nCountTime = 1;
  While ( nCountTime <= nTotalLogTime );
     sLoggingYear = Expand( '%sYear' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );
     sLoggingDay = Expand( '%sDay' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );
     sLoggingMinute = Expand( '%sMinute' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );
     sLoggingSecond = Expand( '%sSecond' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );

     CellPutN( nProcessStartTime, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessStartTime' );
     CellPutN( 1, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessStartedFlag' );
     CellPutN( nProcessExecutionIndex, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessExecutionIndex' );
     CellPutN( nProcessExecutionIntraDayIndex, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessExecutionIntraDayIndex' );
     CellPutS( sProcessRunBy, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'sRunBy' );
     CellPutS( sProcLogParams, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'sParams' );
     nCountTime = nCountTime + 1;
  End;
EndIF;

####################
# Finally! Execute the target process

IF( nParamCount = 0 );
  ExecuteProcess( pProcess );
ElseIF( nParamCount = 1 );
  IF( P1_isString = 1 );
    nRet = ExecuteProcess( pProcess, P1_name, P1_value );
  Else;
    nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ) );
  EndIF;
ElseIF( nParamCount = 2 );
  IF( P1_isString = 1 );
    IF( P2_isString = 1 );
      nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value );
    Else;
      nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ) );
    EndIF;
  Else;
    IF( P2_isString = 1 );
      nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value );
    Else;
      nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ) );
    EndIF;
  EndIF;
ElseIF( nParamCount = 3 );
  IF( P1_isString = 1 );
    IF( P2_isString = 1 );
      IF( P3_isString = 1 );
        nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value );
      Else;
        nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ) );
      EndIF;
    Else;
      IF( P3_isString = 1 );
        nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value );
      Else;
        nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ) );
      EndIF;
    EndIF;
  Else;
    IF( P2_isString = 1 );
      IF( P3_isString = 1 );
        nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value );
      Else;
        nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ) );
      EndIF;
    Else;
      IF( P3_isString = 1 );
        nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value );
      Else;
        nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ) );
      EndIF;
    EndIF;
  EndIF;
ElseIF( nParamCount = 4 );
  IF( P1_isString = 1 );
    IF( P2_isString = 1 );
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value );
        Else;
          nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ) );
        EndIF;
      Else;
        IF( P4_isString = 1 );
          nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value );
        Else;
          nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ) );
        EndIF;
      EndIF;
    Else;
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value );
        Else;
          nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ) );
        EndIF;
      Else;
        IF( P4_isString = 1 );
          nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value );
        Else;
          nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ) );
        EndIF;
      EndIF;
    EndIF;
  Else;
    IF( P2_isString = 1 );
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, P4_value );
        Else;
          nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ) );
        EndIF;
      Else;
        IF( P4_isString = 1 );
          nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value );
        Else;
          nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ) );
        EndIF;
      EndIF;
    Else;
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value );
        Else;
          nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ) );
        EndIF;
      Else;
        IF( P4_isString = 1 );
          nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value );
        Else;
          nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ) );
        EndIF;
      EndIF;
    EndIF;
  EndIF;
ElseIF( nParamCount = 5 );
  IF( P1_isString = 1 );
    IF( P2_isString = 1 );
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ) );
          EndIF;
        Else;
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ) );
          EndIF;
        EndIF;
      Else;
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ) );
          EndIF;
        Else;
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ) );
          EndIF;
        EndIF;
      EndIF;
    Else;
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ) );
          EndIF;
        Else;
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ) );
          EndIF;
        EndIF;
      Else;
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ) );
          EndIF;
        Else;
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ) );
          EndIF;
        EndIF;
      EndIF;
    EndIF;
  Else;
    IF( P2_isString = 1 );
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ) );
          EndIF;
        Else;
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ) );
          EndIF;
        EndIF;
      Else;
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ) );
          EndIF;
        Else;
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ) );
          EndIF;
        EndIF;
      EndIF;
    Else;
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ) );
          EndIF;
        Else;
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ) );
          EndIF;
        EndIF;
      Else;
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ) );
          EndIF;
        Else;
          IF( P5_isString = 1 );
            nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value );
          Else;
            nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ) );
          EndIF;
        EndIF;
      EndIF;
    EndIF;
  EndIF;
ElseIF( nParamCount = 6 );
  IF( P1_isString = 1 );
    IF( P2_isString = 1 );
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        Else;
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        EndIF;
      Else;
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        Else;
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        EndIF;
      EndIF;
    Else;
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        Else;
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        EndIF;
      Else;
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        Else;
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        EndIF;
      EndIF;
    EndIF;
  Else;
    IF( P2_isString = 1 );
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        Else;
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        EndIF;
      Else;
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        Else;
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, P2_value, P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        EndIF;
      EndIF;
    Else;
      IF( P3_isString = 1 );
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        Else;
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, P3_value, P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        EndIF;
      Else;
        IF( P4_isString = 1 );
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, P4_value, P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        Else;
          IF( P5_isString = 1 );
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, P5_value, P6_name, StringToNumber( P6_value ) );
            EndIF;
          Else;
            IF( P6_isString = 1 );
              nRet = ExecuteProcess( pProcess, P1_name , StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, P6_value );
            Else;
              nRet = ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber( P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ) );
            EndIF;
          EndIF;
        EndIF;
      EndIF;
    EndIF;
  EndIF;
ElseIF( nParamCount = 7 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name, P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value );
  ElseIF( P1_isString + P2_isString + P3_isString + P4_isString + P5_isString + P6_isString + P7_isString = 0 );
    ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber(P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ), P7_name, StringToNumber( P7_value ) );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 8 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value );
  ElseIF( P1_isString + P2_isString + P3_isString + P4_isString + P5_isString + P6_isString + P7_isString + P8_isString = 0 );
    ExecuteProcess( pProcess, P1_name, StringToNumber( P1_value ), P2_name, StringToNumber( P2_value ), P3_name, StringToNumber(P3_value ), P4_name, StringToNumber( P4_value ), P5_name, StringToNumber( P5_value ), P6_name, StringToNumber( P6_value ), P7_name, StringToNumber( P7_value ), P8_name, StringToNumber( P8_value ) );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 9 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value );
  Else;
    # For any process with > 8 params discount the possibility of all the params being numeric!
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 10 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 11 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 12 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 13 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 14 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 15 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString * P15_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value, P15_name, P15_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 16 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString * P15_isString * P16_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value, P15_name, P15_value, P16_name, P16_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 17 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString * P15_isString * P16_isString * P17_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value, P15_name, P15_value, P16_name, P16_value, 
    P17_name, P17_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 18 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString * P15_isString * P16_isString * P17_isString * P18_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value, P15_name, P15_value, P16_name, P16_value, 
    P17_name, P17_value, P18_name, P18_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 19 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString * P15_isString * P16_isString * P17_isString * P18_isString * P19_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value, P15_name, P15_value, P16_name, P16_value, 
    P17_name, P17_value, P18_name, P18_value, P19_name, P19_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 20 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString * P15_isString * P16_isString * P17_isString * P18_isString * P19_isString * P20_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value, P15_name, P15_value, P16_name, P16_value, 
    P17_name, P17_value, P18_name, P18_value, P19_name, P19_value, P20_name, P20_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 21 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString * P15_isString * P16_isString * P17_isString * P18_isString * P19_isString * P20_isString * P21_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value, P15_name, P15_value, P16_name, P16_value, 
    P17_name, P17_value, P18_name, P18_value, P19_name, P19_value, P20_name, P20_value, P21_name, P21_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 22 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString * P15_isString * P16_isString * P17_isString * P18_isString * P19_isString * P20_isString * P21_isString * P22_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value, P15_name, P15_value, P16_name, P16_value, 
    P17_name, P17_value, P18_name, P18_value, P19_name, P19_value, P20_name, P20_value, P21_name, P21_value, P22_name, P22_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 23 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString * P15_isString * P16_isString * P17_isString * P18_isString * P19_isString * P20_isString * P21_isString * P22_isString * P23_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value, P15_name, P15_value, P16_name, P16_value, 
    P17_name, P17_value, P18_name, P18_value, P19_name, P19_value, P20_name, P20_value, P21_name, P21_value, P22_name, P22_value, P23_name, P23_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
ElseIF( nParamCount = 24 );
  IF( P1_isString * P2_isString * P3_isString * P4_isString * P5_isString * P6_isString * P7_isString * P8_isString * P9_isString * P10_isString * P11_isString * P12_isString * P13_isString * P14_isString * P15_isString * P16_isString * P17_isString * P18_isString * P19_isString * P20_isString * P21_isString * P22_isString * P23_isString * P24_isString = 1 ); 
    nRet = ExecuteProcess( pProcess, P1_name , P1_value, P2_name, P2_value, P3_name, P3_value, P4_name, P4_value, P5_name, P5_value, P6_name, P6_value, P7_name, P7_value, P8_name, P8_value, P9_name, P9_value, P10_name, P10_value, P11_name, P11_value, P12_name, P12_value, P13_name, P13_value, P14_name, P14_value, P15_name, P15_value, P16_name, P16_value, 
    P17_name, P17_value, P18_name, P18_value, P19_name, P19_value, P20_name, P20_value, P21_name, P21_value, P22_name, P22_value, P23_name, P23_value, P24_name, P24_value );
  Else;
    ExecuteCommand( sCmd, 1 );
  EndIF;
Else;
  # should not happen
EndIF;

### Closing Debug

If( pDebug >= 1 );
  sMessage = 'Process completed with exit code ' | AttrS( cDimExitCode, NumberToString( nRet ), 'Caption_Default' );
  AsciiOutput( sDebugFile, '' );
  AsciiOutput( sDebugFile, sMessage );
EndIf;

### END Prolog
573,5

#****Begin: Generated Statements***
#****End: Generated Statements****


574,5

#****Begin: Generated Statements***
#****End: Generated Statements****


575,39
######################
#**** COPYRIGHT CUBEWISE SERVICES AG
######################

#****Begin: Generated Statements***
#****End: Generated Statements****

######################
### Logging - common script ( Place LAST on Epilog )

IF( pDoProcessLogging = 1 );
  nProcessFinishTime = Now();
  sProcessErrorLogFile = GetProcessErrorFileName;

  nTotalLogTime = 2;
  sYear01 = sLogYear; sYear02 = sLogYear;
  sDay01 = sLogDay; sDay02 = 'D000';
  sMinute01 = sLogMinute; sMinute02 = 'Total Day Entry';
  sSecond01 = sLogSecond; sSecond02= 'Last Entry';

  nCountTime = 1;
  While( nCountTime <= nTotalLogTime );
      sLoggingYear = Expand( '%sYear' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );
      sLoggingDay = Expand( '%sDay' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );
      sLoggingMinute = Expand( '%sMinute' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );
      sLoggingSecond = Expand( '%sSecond' | NumberToStringEx( nCountTime, '00', '', '' ) | '%' );

      CellPutN( nProcessFinishTime, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessFinishTime' );
      CellPutN( 1, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessCompletedFlag' );
      CellPutN( PrologMinorErrorCount, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nPrologMinorErrorCount' );
      CellPutN( ProcessReturnCode, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'nProcessReturnCode' );
      CellPutS( sProcessErrorLogFile, sProcLogCube, sLoggingYear, sLoggingDay, sLoggingMinute, sLoggingSecond, sThisProcName, 'sProcessErrorLogFile' );
      nCountTime = nCountTime + 1;
  End;

EndIF;

######################
### END Epilog
576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,0
900,
901,
902,
938,0
937,
936,
935,
934,
932,0
933,0
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
