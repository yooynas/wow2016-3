601,100
602,"}tp_incr_create_update_artifacts"
562,"NULL"
586,
585,
564,
565,"m6wXV`x6xAvvma2TH42nlSC9AI``k82ARF^XM=<cd]]l1;xznpDztG7_W?7vYbX1]M[y1OTUPotisEorvFX3gi:xKY;jyO2Q0Yn8p[SG5G:hlL2FXPOxw7jE^aSyNgRGGDIfchO0Q5ykr0Cn\VngfcN>E9:ZsBQybwmuk@izkutbFfws13;KF6\UETBhlV1udRM;EtuT"
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
560,5
pExecutionId
pAppId
pApprovalDim
pApprovalSubset
pControl
561,5
2
2
2
2
2
590,5
pExecutionId,"None"
pAppId,"MyApp"
pApprovalDim,"TestElist"
pApprovalSubset,"TestElist"
pControl,"N"
637,5
pExecutionId,
pAppId,
pApprovalDim,
pApprovalSubset,
pControl,
577,0
578,0
579,0
580,0
581,0
582,0
572,64


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

vDimRights = cControlPrefix | 'tp_rights';
vDimRightsMeasures = cControlPrefix | 'tp_security_measures';
vDimRightsUpdateMeasures = cControlPrefix | 'tp_security_update_measures';
vGroups = '}Groups';
vCube = cControlPrefix | 'tp_application_security}' | pAppId;
vCubeUpdates = cControlPrefix | 'tp_application_security_update}' | pAppId;

if (CubeExists(vCube) = 1);
	CubeDestroy(vCube);
endif;

if (CubeExists(vCubeUpdates) = 1);
	CubeDestroy(vCubeUpdates);
endif;

if (DimensionExists(vDimRights) = 1);
	DimensionDestroy(vDimRights);
endif;
DimensionCreate(vDimRights);

DimensionElementInsert(vDimRights, '','VIEW', 'S');
DimensionElementInsert(vDimRights, '','EDIT', 'S');
DimensionElementInsert(vDimRights, '','REVIEW', 'S');
DimensionElementInsert(vDimRights, '','SUBMIT', 'S');

if (DimensionExists(vDimRightsMeasures) = 1);
	DimensionDestroy(vDimRightsMeasures);
endif;
DimensionCreate(vDimRightsMeasures);

DimensionElementInsert(vDimRightsMeasures, '','Rights', 'S');
DimensionElementInsert(vDimRightsMeasures, '','ViewDepth', 'S');
DimensionElementInsert(vDimRightsMeasures, '','ReviewDepth', 'S');

if (DimensionExists(vDimRightsUpdateMeasures) = 1);
	DimensionDestroy(vDimRightsUpdateMeasures);
endif;
DimensionCreate(vDimRightsUpdateMeasures);
DimensionElementInsert(vDimRightsUpdateMeasures, '','Incremental', 'S');
DimensionElementInsert(vDimRightsUpdateMeasures, '','Processed', 'S');



573,1

574,1

575,23


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

CubeCreate(vCube, pApprovalDim, vGroups, vDimRights, vDimRightsMeasures);
CubeSetLogChanges(vCube, 1);

CubeCreate(vCubeUpdates, pApprovalDim, vGroups, vDimRightsUpdateMeasures);
CubeSetLogChanges(vCubeUpdates, 1);


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
