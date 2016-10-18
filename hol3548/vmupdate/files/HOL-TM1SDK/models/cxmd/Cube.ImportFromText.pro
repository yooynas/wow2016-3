601,100
562,"NULL"
586,
585,
564,
565,"hYbm27_oa@24vC3bi4v^FZGDdT^Iu4A=Lbzx]mA:cvpm9R5?l=t4@Yg1SXh<?JpD:NdE;Z2^[UdH44WHtaQ_3eSBmD4Y>uuEz9UhIuq5z^HnnlKj]uu10wrel=]yjh7YJdhi`Vw:X6QTUH7cPl11p2PWqyx2f;lxCM618o3QJv;=plzbIQBlgi0FRl1mMZ6p\s?HcJEy"
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
572,67

#****Begin: Generated Statements***
#****End: Generated Statements****



# Use this process to reset cube data to original values
# Before importing the data, restore the dimensions to their original state
ExecuteProcess('Dim.RestoreOriginals');

cImportPath = 'C:\Cubewise University\Export\';
cFileNameSuffix = '.All.Export.csv';

sCube = 'Currency Exchange Rates';
sFile = sCube | cFileNameSuffix;
CubeClearData(sCube);
ExecuteProcess('Bedrock.Cube.Data.ImportFromFile','pSourceDir',cImportPath,'pSourceFile',sFile,'pTargetCube',sCube,'pTitleRows',2,'pDelimiter',',','pQ
uote','"','pDebug',1);

sCube = 'Employee';
sFile = sCube | cFileNameSuffix;
CubeClearData(sCube);
ExecuteProcess('Bedrock.Cube.Data.ImportFromFile','pSourceDir',cImportPath,'pSourceFile',sFile,'pTargetCube',sCube,'pTitleRows',2,'pDelimiter',',','pQ
uote','"','pDebug',1);

sCube = 'General Ledger';
sFile = sCube | cFileNameSuffix;
CubeClearData(sCube);
ExecuteProcess('Bedrock.Cube.Data.ImportFromFile','pSourceDir',cImportPath,'pSourceFile',sFile,'pTargetCube',sCube,'pTitleRows',2,'pDelimiter',',','pQ
uote','"','pDebug',1);

sCube = 'Planning Assumptions';
sFile = sCube | cFileNameSuffix;
CubeClearData(sCube);
ExecuteProcess('Bedrock.Cube.Data.ImportFromFile','pSourceDir',cImportPath,'pSourceFile',sFile,'pTargetCube',sCube,'pTitleRows',2,'pDelimiter',',','pQ
uote','"','pDebug',1);

sCube = 'Product';
sFile = sCube | cFileNameSuffix;
CubeClearData(sCube);
ExecuteProcess('Bedrock.Cube.Data.ImportFromFile','pSourceDir',cImportPath,'pSourceFile',sFile,'pTargetCube',sCube,'pTitleRows',2,'pDelimiter',',','pQ
uote','"','pDebug',1);

sCube = 'Product Type by Region';
sFile = sCube | cFileNameSuffix;
CubeClearData(sCube);
ExecuteProcess('Bedrock.Cube.Data.ImportFromFile','pSourceDir',cImportPath,'pSourceFile',sFile,'pTargetCube',sCube,'pTitleRows',2,'pDelimiter',',','pQ
uote','"','pDebug',1);

sCube = 'Regional Assumptions';
sFile = sCube | cFileNameSuffix;
CubeClearData(sCube);
ExecuteProcess('Bedrock.Cube.Data.ImportFromFile','pSourceDir',cImportPath,'pSourceFile',sFile,'pTargetCube',sCube,'pTitleRows',2,'pDelimiter',',','pQ
uote','"','pDebug',1);

sCube = 'Retail';
sFile = sCube | cFileNameSuffix;
CubeClearData(sCube);
ExecuteProcess('Bedrock.Cube.Data.ImportFromFile','pSourceDir',cImportPath,'pSourceFile',sFile,'pTargetCube',sCube,'pTitleRows',2,'pDelimiter',',','pQ
uote','"','pDebug',1);

sCube = 'Wholesale';
sFile = sCube | cFileNameSuffix;
CubeClearData(sCube);
ExecuteProcess('Bedrock.Cube.Data.ImportFromFile','pSourceDir',cImportPath,'pSourceFile',sFile,'pTargetCube',sCube,'pTitleRows',2,'pDelimiter',',','pQ
uote','"','pDebug',1);

573,5

#****Begin: Generated Statements***
#****End: Generated Statements****


574,5

#****Begin: Generated Statements***
#****End: Generated Statements****


575,5

#****Begin: Generated Statements***
#****End: Generated Statements****


576,CubeAction=1511DataAction=1503CubeLogChanges=0
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
