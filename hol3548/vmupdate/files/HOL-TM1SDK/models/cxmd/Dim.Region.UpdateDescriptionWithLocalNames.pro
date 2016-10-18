601,100
602,"Dim.Region.UpdateDescriptionWithLocalNames"
562,"SUBSET"
586,"Region"
585,"Region"
564,
565,"i`\hl^[yba?[4Me89[[Oi5zu[IUiBhhj:kLq][aEXd5<9a5PEWY1dd6jmNZrXS<P@NQCJS;n0p7:QehwfirWba2_V5frwj6cgea1t<HbaTP@uXXn;IpTpxGWu2=0;YK?\8j7T15>W8C^7RDpOXp<14@a7oL=e]s<LkK_8zJmi]Fp:Q`9ngaeTYy:mxDleqZEpHlV@iO9"
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
571,All
569,0
592,0
599,1000
560,1
pRegion
561,1
2
590,1
pRegion,"Oceania"
637,1
pRegion,Which region to customise Region dimension to? Asia
577,1
vRegion
578,1
2
579,1
1
580,1
0
581,1
0
582,1
VarType=32€ColType=827€
931,1
0,
603,0
572,12

#****Begin: Generated Statements***
#****End: Generated Statements****

cSourceDimension = 'Region with Local Descriptions';
cTargetDimension = 'Region';

IF(pRegion @= 'Asia' % pRegion @= 'Europe' % pRegion @= 'Oceania' % pRegion @= 'World');
# parameter OK
  Else;
  ProcessBreak;
EndIf;
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,31

#****Begin: Generated Statements***
#****End: Generated Statements****

sDesc = AttrS(cSourceDimension, vRegion, pRegion);

AttrPutS(sDesc, cTargetDimension, vRegion, 'Description');

# Update currency
sAttribute = 'Currency';
sRegionalisedAttribute = pRegion | sAttribute;
sStringAttribute =  AttrS(cSourceDimension, vRegion, sRegionalisedAttribute);
AttrPutS(sStringAttribute, cTargetDimension, vRegion, sAttribute);

## Update Company Tax Rate
#sAttribute = 'Company Tax Rate';
#sRegionalisedAttribute = pRegion | sAttribute;
#nNumericAttribute =  AttrN(cSourceDimension, vRegion, sRegionalisedAttribute);
#AttrPutN(nNumericAttribute, cTargetDimension, vRegion, sAttribute);
#
## Update Payroll Tax Rate
#sAttribute = 'Payroll Tax Rate';
#sRegionalisedAttribute = pRegion | sAttribute;
#nNumericAttribute =  AttrN(cSourceDimension, vRegion, sRegionalisedAttribute);
#AttrPutN(nNumericAttribute, cTargetDimension, vRegion, sAttribute);
#
## Update Super Rate
#sAttribute = 'Super Rate';
#sRegionalisedAttribute = pRegion | sAttribute;
#nNumericAttribute =  AttrN(cSourceDimension, vRegion, sRegionalisedAttribute);
#AttrPutN(nNumericAttribute, cTargetDimension, vRegion, sAttribute);
575,3

#****Begin: Generated Statements***
#****End: Generated Statements****
576,CubeAction=1511€DataAction=1503€CubeLogChanges=0€
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
