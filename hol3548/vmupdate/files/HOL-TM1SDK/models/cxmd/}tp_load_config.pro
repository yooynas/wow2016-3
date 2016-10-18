601,100
602,"}tp_load_config"
562,"CHARACTERDELIMITED"
586,"dummy.txt"
585,"dummy.txt"
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
560,2
pExecutionId
pControl
561,2
2
2
590,2
pExecutionId,"None"
pControl,"N"
637,2
pExecutionId,
pControl,
577,2
Tag
Value
578,2
2
2
579,2
1
2
580,2
0
0
581,2
0
0
582,0
572,38
#################################################################
## IBM Confidential
##
## OCO Source Materials
##
## BI and PM: pmpsvc
##
## (C) Copyright IBM Corp. 2009, 2009, 2010
##
## The source code for this program is not published or otherwise
## divested of its trade secrets, irrespective of what has been
## deposited with the U.S. Copyright Office.
#################################################################

cControlPrefix = '';
If (pControl @= 'Y');
cControlPrefix = '}';
EndIf;

DatasourceNameForServer='tm1s.cfg';
DataSourceType = 'CHARACTERDELIMITED';
DatasourceASCIIDelimiter = '=';

vDimension =cControlPrefix | 'tp_system_config';
vAttrConfigValue='ConfigValue';

IF ( DimensionExists ( vDimension ) = 0 );
  DimensionCreate(vDimension);
ENDIF;
AttrInsert(vDimension, '', vAttrConfigValue, 'S');

DimensionDeleteAllElements(vDimension);
DimensionElementInsert(vDimension, '', 'IntegratedSecurityMode', 'S');
DimensionElementInsert(vDimension, '', 'GroupsCreationLimit', 'S');
DimensionElementInsert(vDimension, '', 'AdminHost', 'S');
DimensionElementInsert(vDimension, '', 'ServerCAMURI', 'S');
DimensionElementInsert(vDimension, '', 'ClientCAMURI', 'S');

573,1

574,26
#################################################################
## IBM Confidential
##
## OCO Source Materials
##
## BI and PM: pmpsvc
##
## (C) Copyright IBM Corp. 2009, 2009, 2010
##
## The source code for this program is not published or otherwise
## divested of its trade secrets, irrespective of what has been
## deposited with the U.S. Copyright Office.
#################################################################

if (subst(Tag,1,1)@='#');
    ItemSkip;
endif;
if(subst(Tag,1,1)@='[');
    ItemSkip;
endif;
if(DimIX(vDimension,Tag)=0);
    ItemSkip;
endif;

AttrPutS(Value,vDimension,Tag,TRIM(vAttrConfigValue));

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
