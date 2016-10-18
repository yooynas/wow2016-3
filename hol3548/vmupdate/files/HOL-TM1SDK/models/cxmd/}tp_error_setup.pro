601,100
602,"}tp_error_setup"
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
572,99


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

#***Create error cube and dimensions
vCube=cControlPrefix | 'tp_process_errors';
vGuidDim =cControlPrefix |  'tp_process_guids';
vMeasureDim =cControlPrefix | 'tp_process_error_measures';

if (CubeExists(vCube)=1);
CubeDestroy(vCube);
endif;

if (DimensionExists(vGuidDim) = 1);
DimensionDestroy(vGuidDim);
endif;

if (DimensionExists(vMeasureDim)=1);
DimensionDestroy(vMeasureDim);
endif;

DimensionCreate(vGuidDim);
DimensionCreate(vMeasureDim);

#add meatures to error measure dimension
DimensionElementInsert(vMeasureDim, '', 'UserName','S');
DimensionElementInsert(vMeasureDim, '', 'SourceProcess','S');
DimensionElementInsert(vMeasureDim, '', 'Status','S');
DimensionElementInsert(vMeasureDim, '', 'StartTime','S');
DimensionElementInsert(vMeasureDim, '', 'ClientStartTime','S');
DimensionElementInsert(vMeasureDim, '', 'EndTime','S');
DimensionElementInsert(vMeasureDim, '', 'PrologFile','S');
DimensionElementInsert(vMeasureDim, '', 'MetadataFile','S');
DimensionElementInsert(vMeasureDim, '', 'DataFile','S');
DimensionElementInsert(vMeasureDim, '', 'EpilogFile','S');
DimensionElementInsert(vMeasureDim, '', 'ErrorCode','S');
DimensionElementInsert(vMeasureDim, '', 'ErrorDetails','S');

DimensionElementInsert(vGuidDim, '', 'All', 'S');
CubeCreate(vCube, vGuidDim, vMeasureDim);
CubeSetLogChanges(vCube, 1);

#***Update tp_config dimension

#***Create tp_cofig dimension if it doesn't exist
vConfigDim =cControlPrefix | 'tp_config';
if (DimensionExists(vConfigDim)=0);
DimensionCreate(vConfigDim);
AttrInsert(vConfigDim, '', 'Numeric Value', 'N');
AttrInsert(vConfigDim, '', 'String Value', 'S');
endif;

#***add attribute to set number of days that errors expire
vElem = 'TI Message Expiration (Days)';
if (DIMIX(vConfigDim, vElem) = 0);
DimensionElementInsert(vConfigDim, '', vElem, 'S');
endif;

#***add attribute: whether we will generate log file or not
vElem = 'Generate TI Log';
if (DIMIX(vConfigDim, vElem) = 0);
DimensionElementInsert(vConfigDim, '', vElem, 'S');
endif;

#***set log directory
vElem = 'Log Directory';
if (DIMIX(vConfigDim, vElem) = 0);
DimensionElementInsert(vConfigDim, '', vElem, 'S');
endif;





573,1

574,1

575,28
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



#***Set initial default value for "errors expiration days"
vElem = 'TI Message Expiration (Days)';
if (DIMIX(vConfigDim, vElem) = 1);
AttrPutN(3, vConfigDim, vElem, 'NumericValue');
endif;

#***Set initial default value for "Generate TI Log"
vElem = 'Generate TI Log';
if (DIMIX(vConfigDim, vElem) = 1);
AttrPutS('Y', vConfigDim, vElem, 'StringValue');
endif;

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
