601,100
602,"cube.SystemInfo.SetCurrentDate"
562,"NULL"
586,
585,
564,
565,"bkabpBb?eUCeGU>qyfbp@zILGO9px]4\XD;M:aH9W<hdp^11P1md1yGS2B^?6M8xPZ>\DChYkXn4tma6[C=qCxxowb]Voa6<P=WT_LLIbZK9=e4TfauBfEqAQRD8TVuoJhVK717;nSG:3EC<FR>t]BwKyWHJ?V^MAJ@Upv`o95O1Ld>x\ATvpqlG1BmP=aiI1BuH<c5J"
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
931,1

603,0
572,92

#****Begin: Generated Statements***
#****End: Generated Statements****


### CONSTANTS ###
cProcessName = 'cub System Info - Set Current Date';

cCubeT1 = 'System Info';


### TRANFORMATIONS ###
cSystemDateTime = NOW();

cCurrentYear = TIMST( cSystemDateTime, '\Y' );
cCurrentMonth = TIMST( cSystemDateTime, '\m' );
cCurrentDay = TIMST( cSystemDateTime, '\d' );
cCurrentDate = TIMST( cSystemDateTime, '\Y\m\d');

#cCurrentPeriod = DIMNM( 'Period', DIMIX( 'Period',SUBST(cCurrentDate,6,2) ) );

IF(
StringToNumber( cCurrentMonth) < 4);
  cFinYear = cCurrentYear;
ELSE;
    cFinYear = ATTRS( 'Year', cCurrentYear, 'Year +1');
ENDIF;

### LOAD ###

CELLPUTS( cCurrentDate, cCubeT1, 'Current Date', 'String');

#CELLPUTS( cCurrentYear, cCubeT1, 'Current Cal Year', 'String');
#CELLPUTN( StringToNumber( cCurrentYear), cCubeT1, 'Current Cal Year', 'Numeric');

#CELLPUTS( cFinYear, cCubeT1, 'Current Fin Year', 'String');
#CELLPUTN( StringToNumber( cFinYear), cCubeT1, 'Current Fin Year', 'Numeric');

#CELLPUTS( cCurrentWeek, cCubeT1, 'Current Week','String');
#CELLPUTN( cCurrentWeekIndex, cCubeT1, 'Current Week','Numeric');
#CELLPUTS( cCurrentWeekday, cCubeT1, 'Current Weekday','String');

#CELLPUTS( cCurrentPeriod, cCubeT1, 'Current Period' , 'String' );
#CELLPUTN( NUMBR (ATTRS( 'Period', cCurrentPeriod, 'Two Digit' )) , cCubeT1, 'Current Period' , 'Numeric' );

#CELLPUTS( cCurrentMonth, cCubeT1, 'Current Period No', 'String' );

#CELLPUTS( cLastFulllWeek, cCubeT1, 'Last Full Week', 'String');
#CELLPUTN( cLastFulllWeekIndex, cCubeT1, 'Last Full Week', 'Numeric');

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
sDim = 'Month';
sSubName = 'Current Month';
IF(
SubsetExists( sDim, sSubName) = 0);
  SubsetCreate( sDim, sSubName);
ELSE;
  SubsetDeleteAllElements( sDim, sSubName);
ENDIF;
SubsetElementInsert( sDim, sSubName, cCurrentMonth, 1);

sDim = 'Day';
sSubName = 'Current Day';
IF(
SubsetExists( sDim, sSubName) = 0);
  SubsetCreate( sDim, sSubName);
ELSE;
  SubsetDeleteAllElements( sDim, sSubName);
ENDIF;
#sCurrentDay = ATTRS( 'Month', cCurrentPeriod, 'Month Short') | ' ' | NumberToString(cCurrentDay);
#SubsetElementInsert( sDim, sSubName, sCurrentDay, 1);
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
