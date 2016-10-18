601,100
602,"Sys.Export.Dimension"
562,"NULL"
586,
585,
564,
565,"xvW6^qQc2iWKRv@Z9lrI7NhsaLPk42:J^_gj\7iuRM\B;WTPN73ZwPQW<;NmdKypj;8e=[lSy_]:cs[9;Q2;JAmaz6>YawsWpv77i[aUmT1B3jvMeDKuGF>>5faq;PwBl=zVCr;ov@8YzF3T0buQWveYyW<`RN[=?vvvPf2fl>22h]4zi<sWO@85xYP\;_JRGEoBpRHw"
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
pDimName
561,1
2
590,1
pDimName,"Account"
637,1
pDimName,Dimension Name
577,0
578,0
579,0
580,0
581,0
582,0
931,1

603,0
572,13

#****Begin: Generated Statements***
#****End: Generated Statements****


TextOutput(pDimName | '.txt', 'Element', 'Parent', 'Description');
nCount = DIMSIZ(pDimName);
n = 1;
WHILE ( n <= nCount );
	sEl = DIMNM(pDimName, n);
	TextOutput(pDimName | '.txt', sEl, ELPAR(pDimName, sEl, 1), ATTRS(pDimName, sEl, 'Description'));
	n = n + 1;
END;
573,4

#****Begin: Generated Statements***
#****End: Generated Statements****

574,4

#****Begin: Generated Statements***
#****End: Generated Statements****

575,4

#****Begin: Generated Statements***
#****End: Generated Statements****

576,_ParseParams={&quotmeasures&quot:[]&#044&quothasHeader&quot:&quotfalse&quot&#044&quotnumColumns&quot:&quot0&quot&#044&quotskipRows&quot:&quot0&quot&#044&quotlocale&quot:{&quotlanguange&quot:&quoten&quot&#044&quotvariant&quot:&quot&quot&#044&quotcountry&quot:&quotAU&quot}&#044&quotdimensions&quot:[]}_DeployParams={&quotdataAction&quot:&quotACCUMULATE&quot&#044&quotclass&quot:&quotDeployParams&quot&#044&quotdimensionConflictResolutions&quot:{}}
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
