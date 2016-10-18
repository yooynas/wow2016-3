601,100
602,"Cube.Employee.LoadFromFile"
562,"CHARACTERDELIMITED"
586,"C:\TM1data\cxmd\Data\EmployeeData.csv"
585,"C:\TM1data\cxmd\Data\EmployeeData.csv"
564,
565,"x_6<H7Lfj5ZJwUThMEzZ2QK;a1<`GLjWoxmJ@pdZD8FB@vIBlF6o766UYsmc\v>QE3VMIka7LyDzmlagX@bNuZh?6MTHHG^G:>1l212b83cz\]3oj6@406\w3yaAdPeLdA[:eZw[5u1ww=Lc:\xqjYt@`?6?g\m:bG_EdztTX^Y>Nak0MLLML3m1Q9Av^CQ]_N:Td17K"
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
566,3
Select DimEmployee.SalesTerritoryKey, DimEmployee.DepartmentName, DimEmployee.EmployeeNationalIDAlternateKey, DimEmployee.BaseRate
From DimEmployee
ORDER BY DimEmployee.DepartmentName,DimEmployee.FirstName
567,","
588,"."
589,","
568,""""
570,
571,
569,1
592,0
599,1000
560,3
pVersion
pYear
pM
561,3
2
2
1
590,3
pVersion,""
pYear,""
pM,1
637,3
pVersion,""
pYear,""
pM,""
577,3
vSalesTerritoryKey
vEmployeeKey
vBaseRate
578,3
2
2
1
579,3
1
3
4
580,3
0
0
0
581,3
0
0
0
582,4
VarType=32ColType=827
IgnoredInputVarName=vDepartmentVarType=32ColType=1165
VarType=32ColType=827
VarType=33ColType=827
603,0
572,38

#****Begin: Generated Statements***
#****End: Generated Statements****


DatasourceNameForServer = 'EmployeeData.csv';
DatasourceNameForClient = 'EmployeeData.csv';


## This process loads base salaries to the Employee Cube ##

cCube = 'Employee';
cVersion = pVersion;
cYear = pYear;
#sDepartment = '0';
cCurrency = 'Local';

#cViewName =  '}ClearCube';
#ViewCreate(cCube, cViewName);
#ViewZeroOut(cCube, cViewName);
#ViewDestroy(cCube, cViewName);

ExecuteProcess('Bedrock.Cube.View.Create'
  , 'pCube', 'Employee'
  , 'pView', 'tempView123'
  , 'pFilter', 'Version:' | cVersion | ' & Year:' | cYear | '&Employee Measure:Enter Full Time Base Salary+Pay Method+Full Time Base Salary'
  , 'pSuppressZero', 1
  , 'pSuppressConsol', 1
  , 'pSuppressRules', 1
  , 'pDimensionDelim', '&'
  , 'pElementStartDelim', ':'
  , 'pElementDelim', '+'
  , 'pDebug', 0
);

ViewZeroOut('Employee','tempView123');
ViewDestroy('Employee','tempView123');

573,5

#****Begin: Generated Statements***
#****End: Generated Statements****


574,61

#****Begin: Generated Statements***
#****End: Generated Statements****


vDepartmentName=ATTRS('Employee',vEmployeeKey,'Department Name');


sEmployeeKey = vEmployeeKey;

# Remove dot from end of product
sString = sEmployeeKey;
nLength = LONG(sString);
sLastCharacter = SUBST(sString, nLength, 1);
If(sLastCharacter @= '.');
  sString = SUBST(sString, 1, nLength - 1);
EndIf;
sEmployeeKey = sString;


#IF(pVersion@<>'Actual');
   nPercent=RAND/10;
   vBaseRate=vBaseRate*nPercent+vBaseRate;
#ENDIF;

nSalary = vBaseRate * 160 * pM;

#Employee Cube
#Version
#Year
#Period
#Currency
#Region
#Department
#Employee
#Employee Measure

# department is a random whole number between 2 and 7
#sDepartment = Numbertostring(INT(RAND * 6) + 2);

IF(pVersion@<>'Actual');
   CellPutN(nSalary*12, cCube, cVersion, cYear, 'Year_Enter', cCurrency, vSalesTerritoryKey, vDepartmentName, sEmployeeKey, 'Enter Full Time Base Salary');
   CellPutS('Monthly', cCube, cVersion, cYear,  'Year_Enter', cCurrency, vSalesTerritoryKey,vDepartmentName , sEmployeeKey, 'Pay Method');
ENDIF;

nMonth = 1;
WHILE(nMonth <=12);
  sMonth = NumberToString(nMonth);
  IF(CellIsUpdateable(cCube, cVersion, cYear, sMonth, cCurrency,vSalesTerritoryKey,vDepartmentName, sEmployeeKey, 'Enter Full Time Base Salary') = 1 );
   #CellPutN(1, cCube, cVersion, cYear, sMonth, cCurrency, vSalesTerritoryKey, vDepartmentName, sEmployeeKey, 'FTE');
   CellPutS('Monthly', cCube, cVersion,cYear,  'Year_Enter', cCurrency, vSalesTerritoryKey,vDepartmentName , sEmployeeKey, 'Pay Method');
   IF(pVersion@='Actual');
       CellPutN(nSalary, cCube, cVersion, cYear, sMonth, cCurrency, vSalesTerritoryKey,vDepartmentName , sEmployeeKey, 'Enter Full Time Base Salary');
       CellPutS('Monthly', cCube, cVersion, cYear, 'Year_enter', cCurrency, vSalesTerritoryKey,vDepartmentName , sEmployeeKey, 'Pay Method');
   ENDIF;
    #TEXTOUTPUT('Test.csv', NumberToString(nSalary), cCube, cVersion, cYear, sMonth, cCurrency, sRegion, vDepartmentName, sEmployeeKey, 'Enter Full Time Base Salary');
  EndIf;
  nMonth = nMonth +1;
END;


575,6

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
