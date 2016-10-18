601,100
602,"Dim.Element.Order.Import"
562,"CHARACTERDELIMITED"
586,"C:\TM1\AdventureWorks\Data\Account_Sorted.csv"
585,"C:\TM1\AdventureWorks\Data\Account_Sorted.csv"
564,
565,"jDvB=nJFUqaz>m=qL6e]zk8RPM`6SoZJcH=thg^J2eeUS5GDp?q\Df]_deb]02_qOe<;ldO>4QUMue^<nfvL]<z5Zoe1>gcCE_Z5pgo`7C7ZOr>>N5?hAscz3yQSByMTvqb1KeyLq<=CT@wT9mv4vsvlEMGC4\FwyFH^tBXv\Gh@gyG6ianH1GrsXKFlDn9za1af_Jf1"
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
589,","
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
577,4
vEl
vType
vParent
vWeight
578,4
2
2
2
1
579,4
2
3
4
5
580,4
0
0
0
0
581,4
0
0
0
0
582,6
IgnoredInputVarName=V1VarType=32ColType=1165
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
IgnoredInputVarName=V6VarType=33ColType=1165
603,0
572,8

#****Begin: Generated Statements***
#****End: Generated Statements****

pDimName = 'Account Test';

#ExecuteProcess('Dim.Element.Order.Delete');
DimensionDeleteAllElements(pDimName);
573,7

#****Begin: Generated Statements***
#****End: Generated Statements****

DimensionElementInsert(pDimName, '', vParent, 'C');
DimensionElementInsert(pDimName, '', vEl, vType);
DimensionElementComponentAdd(pDimName, vParent, vEl, vWeight );
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
