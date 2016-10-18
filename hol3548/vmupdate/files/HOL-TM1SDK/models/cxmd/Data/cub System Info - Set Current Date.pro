601,100
562,"NULL"
586,
585,
564,
565,"g2c`DP8a8>yAmnJh3Y1yD]COc??eeSF=2gMtb_tx\^cjrnJW;mBU>A51\2bT:DMmn3Imw;AvqTHMrM7^qS^GD_cCtSorF^AV]aE8\b2v=b4gPMYlaFl\L32b3Falt\kXA]Yt2VUSWVTsD<?IwNCu:2qa`SlAC9tlYc:lnlin?9P_Pjz4F_s>;Ilpo93lu6p139f[sM0B"
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
560,0
561,0
590,0
637,0
577,0
578,0
579,0
580,0
581,0
582,0
572,87

#****Begin: Generated Statements***
#****End: Generated Statements****


### CONSTANTS ###
cProcessName = 'cub System Info - Set Current Date';

cCubeT1 = 'System Info';


### TRANFORMATIONS ###
cSystemDateTime = NOW();

cCurrentYear = TIMST( cSystemDateTime, '\Y' );
cCurrentMonth = TIMST( cSystemDateTime, '\m' );
cCurrentDate = TIMST( cSystemDateTime, '\Y-\m-\d');

cCurrentWeek = ATTRS('Date', cCurrentDate, 'Week' );
cCurrentWeekIndex = NUMBR(SUBST( ATTRS('Date', cCurrentDate, 'Week' ), 6, 2)) ;
cCurrentWeekday = ATTRS( 'Date', cCurrentDate, 'Weekday' );

cLastFulllWeek = ATTRS( 'Week', cCurrentWeek, 'Last week' );
cLastFulllWeekIndex = StringToNumber( SUBST( cLastFulllWeek, 6,2 ) );

cCurrentPeriod = DIMNM( 'Period', DIMIX( 'Period',SUBST(cCurrentDate,6,2) ) );

IF(
StringToNumber( cCurrentMonth) < 4);
  cFinYear = cCurrentYear;
ELSE;
    cFinYear = ATTRS( 'Year', cCurrentYear, 'Next Year');
ENDIF;

### LOAD ###

CELLPUTS( cCurrentDate, cCubeT1, 'Current Date', 'String');

CELLPUTS( cCurrentYear, cCubeT1, 'Current Cal Year', 'String');
CELLPUTN( StringToNumber( cCurrentYear), cCubeT1, 'Current Cal Year', 'Numeric');

CELLPUTS( cFinYear, cCubeT1, 'Current Fin Year', 'String');
CELLPUTN( StringToNumber( cFinYear), cCubeT1, 'Current Fin Year', 'Numeric');

CELLPUTS( cCurrentWeek, cCubeT1, 'Current Week','String');
CELLPUTN( cCurrentWeekIndex, cCubeT1, 'Current Week','Numeric');
CELLPUTS( cCurrentWeekday, cCubeT1, 'Current Weekday','String');

CELLPUTS( cCurrentPeriod, cCubeT1, 'Current Period' , 'String' );
CELLPUTN( NUMBR (ATTRS( 'Period', cCurrentPeriod, 'Two Digit' )) , cCubeT1, 'Current Period' , 'Numeric' );

CELLPUTS( cCurrentMonth, cCubeT1, 'Current Period No', 'String' );

CELLPUTS( cLastFulllWeek, cCubeT1, 'Last Full Week', 'String');
CELLPUTN( cLastFulllWeekIndex, cCubeT1, 'Last Full Week', 'Numeric');

### SUBSETS ###
sDim = 'Year';
sSubName = 'Current Year';
IF(
SubsetExists( sDim, sSubName) = 0);
  SubsetCreate( sDim, sSubName);
ELSE;
  SubsetDeleteAllElements( sDim, sSubName);
ENDIF;
SubsetElementInsert( sDim, sSubName, cCurrentYear, 1);

sDim = 'Year';
sSubName = 'Current Financial Year';
IF(
SubsetExists( sDim, sSubName) = 0);
  SubsetCreate( sDim, sSubName);
ELSE;
  SubsetDeleteAllElements( sDim, sSubName);
ENDIF;
SubsetElementInsert( sDim, sSubName, cFinYear, 1);

### SUBSETS ###
sDim = 'Period';
sSubName = 'Current Month';
IF(
SubsetExists( sDim, sSubName) = 0);
  SubsetCreate( sDim, sSubName);
ELSE;
  SubsetDeleteAllElements( sDim, sSubName);
ENDIF;
SubsetElementInsert( sDim, sSubName, cCurrentPeriod, 1);
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,3

#****Begin: Generated Statements***
#****End: Generated Statements****
576,CubeAction=1511DataAction=1503CubeLogChanges=0
638,1
804,0
1217,1
900,
901,
902,
903,
906,
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
