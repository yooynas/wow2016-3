601,100
602,"}tp_error_add_guid"
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
560,2
pGuid
pControl
561,2
2
2
590,2
pGuid,"None"
pControl,"N"
637,2
pGuid,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,44
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

#*** create a dimension to store process guid
vGuidDim = cControlPrefix | 'tp_process_guids';

IF ( DimensionExists ( vGuidDim ) = 0 );
  ProcessError;
ENDIF;

vAll = 'All';

IF ( DIMIX ( vGuidDim, vAll ) = 0 );
  ProcessError;
ENDIF;

vToday = Today(1);

#****add today's date as a consolidated element and add each guid as a child

if (DIMIX (vGuidDim, vToday) =0);
  DimensionElementComponentAdd ( vGuidDim, vAll, vToday, 1 );
endif;

if (DIMIX (vGuidDim, pGUID) =0);
  DimensionElementComponentAdd(vGuidDim, vToday, pGuid, 1);
endif;
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
