601,100
602,"}tp_error_cleanup"
562,"NULL"
586,
585,
564,
565,"tABGqxo9IEg2gLtY`0i6agdoespM]Y2ptTKkFeOZ_LqyR7<FUO5s]EwAA17:>JRb[U=l@M3EfYxNGLRirWoUP86kerF;ZMotnbi]4u_S>Bh53ynr;tTU82kYw`nBNz51aKq2<x^]FenJV_cw4AFLDF[0`\KkL22bQOy1xzSf?fIOxvQNgu]tRqS;S\zv@w9NLWS=9h:@"
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
560,1
pControl
561,1
2
590,1
pControl,"N"
637,1
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,61
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

#*** get the number of days for expiration from the control cube (attribute)
vConfigDim =cControlPrefix | 'tp_config';
vDaysExpire = AttrN ( vConfigDim, 'TI Message Expiration (Days)', 'NumericValue' );

#*** get today's date
vToday = TODAY(1);
#get the day number for today
vTodayDay = DAYNO( vToday );

#*** get all children from the 'All' consolidation in the tp_process_guids dimension
vDim =cControlPrefix | 'tp_process_guids';
vAll = 'All';
vElem = '';
vElem1 = '';

#*** delete date elements that are expired and all their children elements
vLooper = ELCOMPN ( vDim, vAll );

WHILE ( vLooper > 0 );
  vElem = ELCOMP ( vDim, vAll, vLooper );
  vElemDay = DAYNO( vElem );
  IF ( vTodayDay - vElemDay >= vDaysExpire );
    vLooper1 = ELCOMPN ( vDim, vElem );
    WHILE ( vLooper1 > 0 );
      vElem1 = ELCOMP ( vDim, vElem, vLooper1 );
      DimensionElementDelete ( vDim, vElem1 );
      vLooper1 = vLooper1 - 1;
    END;
  DimensionElementDelete ( vDim, vElem );
  ENDIF;
  vLooper = vLooper - 1;
END;

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
