601,100
562,"VIEW"
586,"Time"
585,"Time"
564,
565,"vC7b<ge0gYgEgH:yWE;MPIaTfB7v9Lu?p[?45Tw[3H9Baymcoo>5H7u;<=_d075wLM]6sdsWKp]>mF1[kMKZ;LUwupA37fr4rws?E@@p@tK;n\EJ?1ENBS9D77SJIK=o<ls7Ue[PZ2@=9]DYUtP@=S`NfKXOFKbgGH9U;vYI?ovAiE[iSiIf4n^<IR\G9k9B]FW\UvZQ"
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
570,z_TI_cub Time - Populate Static Data
571,
569,0
592,0
599,1000
560,0
561,0
590,0
637,0
577,7
vYear
vPeriod
vMeasure
vValue
NVALUE
SVALUE
VALUE_IS_STRING
578,7
2
2
2
1
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
582,4
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
572,82

#****Begin: Generated Statements***
#****End: Generated Statements****

### CONSTANTS ###
cProcessName = 'cub Time - Populate Static Data';
cViewName = 'z_TI_' | NumberToString( ROUND( RAND() *100000));
#cViewName = 'z_TI_' | cProcessName;
cSubName = cViewName;

cCubeT1 = 'Time';

sDim = 'Year';
nMinYearIndex = 9999;
index = 1;
sDimSiz = DIMSIZ( sDim);
WHILE( index <= sDimSiz);
  sElement = DIMNM( sDim, index);
  sElementIndex = ATTRN( sDim, sElement, 'Year Index');
#  ASCIIOUTPUT( 'adam.csv', sElement, NumberToString( nMinYearIndex) , NumberToString(sElementIndex) );
  IF(
  sElementIndex <>0 &
  sElementIndex < nMinYearIndex);
    nMinYearIndex = sElementIndex;
  ENDIF;
  index = index +1;
END;


### BUILD DATA SOURCE VIEW ###
sCube = cCubeT1;
ViewDestroy( sCube, cViewName);
ViewCreate( sCube, cViewName);

ViewExtractSkipCalcsSet (sCube, cViewName, 0);
ViewExtractSkipRuleValuesSet (sCube, cViewName, 0);
ViewExtractSkipZeroesSet(sCube, cViewName, 0);

sDim= 'Year';
SubsetDestroy( sDim, cSubName);
SubsetCreate( sDim, cSubName);
index = 1;
sDimSiz = DIMSIZ( sDim);
WHILE( index <= sDimSiz);
  sElement = DIMNM( sDim, index);
  sElementLevel = ELLEV( sDim, sElement);
  IF(
  sElementLevel =0 );
    SubsetElementInsert( sDim, cSubName, sElement, 1);
  ENDIF;
  index = index +1;
END;
ViewSubsetAssign( sCube, cViewName, sDim, cSubName);

sDim= 'Period';
SubsetDestroy( sDim, cSubName);
SubsetCreate( sDim, cSubName);
index = 1;
sDimSiz = DIMSIZ( sDim);
WHILE( index <= sDimSiz);
  sElement = DIMNM( sDim, index);
  sElementLevel = ELLEV( sDim, sElement);
  IF(
  sElementLevel =0 &
  sElement @<> 'Full Year' &
  sElement @<> 'OB') ;
    SubsetElementInsert( sDim, cSubName, sElement, 1);
  ENDIF;
  index = index +1;
END;
ViewSubsetAssign( sCube, cViewName, sDim, cSubName);

sDim= 'Time Measures';
SubsetDestroy( sDim, cSubName);
SubsetCreate( sDim, cSubName);
SubsetElementInsert( sDim, cSubName, 'Financial Year Index', 1);
ViewSubsetAssign( sCube, cViewName, sDim, cSubName);

DataSourceType = 'VIEW';
DataSourceCubeView = cViewName;

#PROCESSQUIT;
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,40

#****Begin: Generated Statements***
#****End: Generated Statements****

### POPULATE FINANCIAL YEAR INDEX ###
nYearIndex = ( ATTRN( 'Year', vYear, 'Year Index') - nMinYearIndex) *12;
nMonthIndex = ATTRN( 'Period', vPeriod, 'Financial Year Index');
CELLPUTN( nYearIndex + nMonthIndex, cCubeT1, vYear, vPeriod, 'Financial Year Index');

### POPULATE CALENDAR YEAR INDEX ###
nCalMonthIndex = ATTRN( 'Period', vPeriod, 'Calendar Year Index');
CELLPUTN( nYearIndex + nCalMonthIndex, cCubeT1, vYear, vPeriod, 'Calendar Year Index');

### POPULATE NEXT FINANCIAL YEAR ###
IF( vPeriod @= 'Mar');
  CELLPUTS ( AttrS('Year', vYear,'Next Year'), cCubeT1, vYear, vPeriod, 'Next Financial Year');
ELSE;
  CELLPUTS ( vYear, cCubeT1, vYear, vPeriod, 'Next Financial Year');
ENDIF;

### POPULATE PREVIOUS FINANCIAL YEAR ###
IF( vPeriod @= 'Apr');
  CELLPUTS ( ATTRS( 'Year', vYear,'Prev Year'), cCubeT1, vYear, vPeriod, 'Prev Financial Year');
ELSE;
  CELLPUTS ( vYear, cCubeT1, vYear, vPeriod, 'Prev Financial Year');
ENDIF;

### POPULATE FINANCIAL YEAR ###
IF( nMonthIndex <=9 );
  CELLPUTS ( AttrS('Year', vYear,'Next Year'), cCubeT1, vYear, vPeriod, 'Financial Year');
ELSE;
  CELLPUTS ( vYear, cCubeT1, vYear, vPeriod, 'Financial Year');
ENDIF;

### POPULATE FINANCIAL YEAR ###
IF( nMonthIndex <=9 );
  CELLPUTS ( AttrS( 'Year', vYear,'Prev Year'), cCubeT1, vYear, vPeriod, 'Calendar Year');
ELSE;
  CELLPUTS ( vYear, cCubeT1, vYear, vPeriod, 'Calendar Year');
ENDIF;
575,13

#****Begin: Generated Statements***
#****End: Generated Statements****


sCube = cCubeT1;
ViewDestroy( sCube, cViewName);

sDim= 'Period';
SubsetDestroy( sDim, cSubName);

sDim= 'Time Measures';
SubsetDestroy( sDim, cSubName);
576,CubeAction=1511DataAction=1503CubeLogChanges=0
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
