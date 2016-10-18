﻿601,100
602,"Bedrock.Dim.Attr.Delete"
562,"NULL"
586,
585,
564,
565,"i^TsdQJfhad6ve5yyHYDwm\oWdw97TOAuSxCj5mKLvUgv2g;Uv1e[u^mKS>KDKv53k65O6sDV`mIE]<ighx<Q?5aJ`^B=IlSjgfclPG=DU1jXwY;]Km1\Dblym[83;u:8WAu>I4fp_HEMjqSlFjh]sz_yPs_YodGH0KbINO]PX4H=mnwjB=Hxzrpr`DERo^EB;yov^EB"
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
pDimension
pAttribute
pDebug
561,3
2
2
1
590,3
pDimension,""
pAttribute,""
pDebug,0
637,3
pDimension,"Dimension Name"
pAttribute,"Attribute Name"
pDebug,"Debug Mode"
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,68

#****Begin: Generated Statements***
#****End: Generated Statements****

#####################################################################################
##~~Copyright bedrocktm1.org 2011 www.bedrocktm1.org/how-to-licence.php Ver 3.0.2~~##
#####################################################################################

### Constants ###

cProcess = 'Bedrock.Dim.Attr.Delete';
cTimeStamp = TimSt( Now, '\Y\m\d\h\i\s' );
sRandomInt = NumberToString( INT( RAND( ) * 1000 ));
cDebugFile = GetProcessErrorFileDirectory | cProcess | '.' | cTimeStamp | '.' | sRandomInt ;

### Initialise Debug ###

If( pDebug >= 1 );

  # Set debug file name
  sDebugFile = cDebugFile | 'Prolog.debug';

  # List parameters
  AsciiOutput( sDebugFile, 'Parameters: pDimension : ' | pDimension );
  AsciiOutput( sDebugFile, '            pAttribute : ' | pAttribute );

EndIf;


### Validate Parameters ###

# Validate dimension
If( Trim( pDimension ) @= '' );
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, 'No dimension specified' );
  EndIf;
  ProcessQuit;
EndIf;
If( DimensionExists( pDimension ) = 0 );
 If( pDebug >= 1 );
    AsciiOutput( sDebugFile, 'Dimension: ' | pDimension | ' does not exist' );
  EndIf;
  ProcessQuit;
EndIf;

# Validate attribute
If( Trim( pAttribute ) @= '' );
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, 'No attribute specified' );
  EndIf;
  ProcessQuit;
EndIf;
If( DimIx( '}ElementAttributes_' | pDimension, pAttribute ) = 0 );
  If( pDebug >= 1 );
    AsciiOutput( sDebugFile, 'Attribute ' | pAttribute | ' does not exist in dimenson: ' | pDimension );
  EndIf;
  ProcessQuit;
EndIf;


### Delete Attribute ###

If( pDebug <= 1 );
  AttrDelete( pDimension, pAttribute );
EndIf;


### End Prolog ###
573,4

#****Begin: Generated Statements***
#****End: Generated Statements****

574,4

#****Begin: Generated Statements***
#****End: Generated Statements****

575,4

#****Begin: Generated Statements***
#****End: Generated Statements****

576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,1
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
918,0
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
