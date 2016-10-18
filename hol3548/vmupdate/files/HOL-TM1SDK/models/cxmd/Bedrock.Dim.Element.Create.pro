﻿601,100
602,"Bedrock.Dim.Element.Create"
562,"NULL"
586,
585,
564,
565,"r4AtMVQ7Sm0YmhNpbsac>NHnj]ry=YE`1BAoHGHM8RtY9O_3UMrFf@iwlO3>K6_??D^r7LAal3BwhzYpRP]p2tj`[Z@?FxH=1gjrMdSnAnLPjl>Av=TC`X<vqWA\sSK[[1YPpc[sme;<FDT_0sd8L^zB0Ea9vnUkPcmfOUwPiiflwIV1[_s]@SQuHBpNAxWm9NA>r]x`"
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
pDimension
pElement
pElementType
pDebug
561,4
2
2
2
1
590,4
pDimension,""
pElement,""
pElementType,""
pDebug,0
637,4
pDimension,Dimension Name
pElement,Element Name
pElementType,Element Type (N S C)
pDebug,Debug Mode
577,0
578,0
579,0
580,0
581,0
582,0
572,97

#****Begin: Generated Statements***
#****End: Generated Statements****

#####################################################################################
##~~Copyright bedrocktm1.org 2011 www.bedrocktm1.org/how-to-licence.php Ver 3.0.2~~##
#####################################################################################

# This process will create new element in a dimension


### Constants ###

cProcess = 'Bedrock.Dim.Element.Create';
cTimeStamp = TimSt( Now, '\Y\m\d\h\i\s' );
sRandomInt = NumberToString( INT( RAND( ) * 1000 ));
cDebugFile = GetProcessErrorFileDirectory | cProcess | '.' | cTimeStamp | '.' | sRandomInt ;


### Initialise Debug ###

If( pDebug >= 1 );

  # Set debug file name
  sDebugFile = cDebugFile | 'Prolog.debug';

  # Log start time
  AsciiOutput( sDebugFile, 'Process Started: ' | TimSt( Now, '\d-\m-\Y \h:\i:\s' ) );

  # Log parameters
  AsciiOutput( sDebugFile, 'Parameters: pDimension   : ' | pDimension );
  AsciiOutput( sDebugFile, '            pElement     : ' | pElement );
  AsciiOutput( sDebugFile, '            pElementType : ' | pElementType );

EndIf;


### Validate Parameters ###

nErrors = 0;

# Validate dimension
If( Trim( pDimension ) @= '' );
  nErrors = 1;
  sMessage = 'No dimension specified';
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;
If( DimensionExists( pDimension ) = 0 );
  nErrors = 1;
  sMessage = 'Dimension: ' | pDimension | ' does not exist on server.';
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;

# Validate element
If( Trim( pElement ) @= '' );
  nErrors = 1;
  sMessage = 'No element specified';
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;
If( DimIx( pDimension, pElement ) > 0 );
  nErrors = 1;
  sMessage = 'Element: ' | pElement | ' already exists in dimension: ' | pDimension;
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;

# Validate element type
pElementType = Upper( pElementType );
If( pElementType @<> 'N' & pElementType @<> 'C' & pElementType @<> 'S' );
  nErrors = 1;
  sMessage = 'Invalid element type: ' | pElementType;
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, sMessage );
  EndIf;
  ItemReject( sMessage );
EndIf;


### Insert Element into dimension ###

If( pDebug <= 1 );
  DimensionElementInsert( pDimension, '',  pElement, pElementType );
EndIf;


### End Prolog ###
573,4

#****Begin: Generated Statements***
#****End: Generated Statements****

574,4

#****Begin: Generated Statements***
#****End: Generated Statements****

575,35

#****Begin: Generated Statements***
#****End: Generated Statements****

#####################################################################################
##~~Copyright bedrocktm1.org 2011 www.bedrocktm1.org/how-to-licence.php Ver 3.0.2~~##
#####################################################################################


### Initialise Debug ###

If( pDebug >= 1 );

  # Set debug file name
  sDebugFile = cDebugFile | 'Epilog.debug';

  # Log errors
  If( nErrors <> 0 );
    AsciiOutput( sDebugFile, 'Errors Occurred' );
  EndIf;

  # Log finish time
  AsciiOutput( sDebugFile, 'Process Finished: ' | TimSt( Now, '\d-\m-\Y \h:\i:\s' ) );

EndIf;


### If errors occurred terminate process with a major error status ###

If( nErrors <> 0 );
  ProcessQuit;
EndIf;


### End Epilog ###
576,CubeAction=1511DataAction=1503CubeLogChanges=0
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
917,1
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
