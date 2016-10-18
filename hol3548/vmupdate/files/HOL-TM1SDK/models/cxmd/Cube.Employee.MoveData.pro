601,100
602,"Cube.Employee.MoveData"
562,"VIEW"
586,"Employee"
585,"Employee"
564,
565,"vl;aHJhALvdYvEbLuEtZr2aTW@PRAE\\ohKaoQaiNUBBZD@NQMdMPz96k^rHkruX3]H2zwK5DpEGY_g9S5XVGhanvMfwu_hc:pT;jiCj30f\T@OlbwWf\\]\HuU18SixA0BIVjxFHGJvUl[[^Y@B1up5Q<sr59IWSmMZuZMEl5Vr@SuLtYQ7Bg;6[]ipRkLOpoC9yrH:"
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
570,Executive and Administration
571,
569,0
592,0
599,1000
560,5
pID
pDeptSrc
pRegionSrc
pDeptTgt
pRegionTgt
561,5
2
2
2
2
2
590,5
pID,"767955365"
pDeptSrc,"Sales and Marketing"
pRegionSrc,"Poland"
pDeptTgt,"Manufacturing"
pRegionTgt,"Finland"
637,5
pID,""
pDeptSrc,""
pRegionSrc,""
pDeptTgt,""
pRegionTgt,""
577,12
vVersion
vYear
vMeasure
vCurrency
vRegion
vDepartment
vEmployee
vPeriod
Value
NVALUE
SVALUE
VALUE_IS_STRING
578,12
2
2
2
2
2
2
2
2
2
1
2
1
579,12
1
2
8
4
5
6
7
3
9
0
0
0
580,12
0
0
0
0
0
0
0
0
0
0
0
0
581,12
0
0
0
0
0
0
0
0
0
0
0
0
582,9
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
603,0
572,36

#****Begin: Generated Statements***
#****End: Generated Statements****

#Create source
ExecuteProcess('Bedrock.Cube.View.Create'
  , 'pCube', 'Employee'
  , 'pView', 'EmployeeSource1'
  , 'pFilter', 'Version:Budget&Year:2016&Currency:Local&Region:' | pRegionSrc | '&Department:' | pDeptSrc | '&Employee:' | pID
  , 'pSuppressZero', 1
  , 'pSuppressConsol', 1
  , 'pSuppressRules', 1
  , 'pDimensionDelim', '&'
  , 'pElementStartDelim', ':'
  , 'pElementDelim', '+'
  , 'pDebug', 0
);

#Clear Target

ExecuteProcess('Bedrock.Cube.Data.Clear'
  , 'pCube', 'Employee'
  , 'pView', ''
  , 'pFilter', 'Version:Budget&Year:2016&Currency:Local&Region:' | pRegionTgt | '&Department:' | pDeptTgt | '&Employee:' | pID
  , 'pDimensionDelim', '&'
  , 'pElementStartDelim', ':'
  , 'pElementDelim', '+'
  , 'pDestroyTempObj', 1
  , 'pDebug', 0
);


DataSourceType='View';
DataSourceNameForServer='Employee';
DatasourceCubeview='EmployeeSource1';

573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,13

#****Begin: Generated Statements***
#****End: Generated Statements****

IF( VALUE_IS_STRING = 1 );

CellPutS(sValue,'Employee', vVersion,vYear,vPeriod,vCurrency,pRegionTgt,pDeptTgt,vEmployee,vMeasure);

ELSE;

CellPutN(nValue,'Employee', vVersion,vYear,vPeriod,vCurrency,pRegionTgt,pDeptTgt,vEmployee,vMeasure);

ENDIF;
575,22

#****Begin: Generated Statements***
#****End: Generated Statements****


ExecuteProcess('Bedrock.Cube.Data.Clear'
  , 'pCube', 'Employee'
  , 'pView', ''
  , 'pFilter', 'Version:Budget&Year:2016&Currency:Local&Region:' | pRegionSrc | '&Department:' | pDeptSrc | '&Employee:' | pID
  , 'pDimensionDelim', '&'
  , 'pElementStartDelim', ':'
  , 'pElementDelim', '+'
  , 'pDestroyTempObj', 1
  , 'pDebug', 0
);

ExecuteProcess('Bedrock.Cube.View.Delete'
  , 'pCubes', 'Employee'
  , 'pViews', 'EmployeeSource1'
  , 'pDelimiter', '&'
  , 'pDebug', 0
);
576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,0
900,
901,
902,
938,0
937,
936,
935,
934,
932,0
933,0
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
