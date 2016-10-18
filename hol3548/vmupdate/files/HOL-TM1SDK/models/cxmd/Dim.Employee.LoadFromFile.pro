601,100
602,"Dim.Employee.LoadFromFile"
562,"CHARACTERDELIMITED"
586,"C:\TM1data\cxmd\Data\Employee.csv"
585,"C:\TM1data\cxmd\Data\Employee.csv"
564,
565,"m\tad56f:Jg>Fae;k2gC^Anxu`p;JF_KLn[6IH@NPNEXjkmsty>sPX1?OKANsMkzQL1uN^rGt1Y7U1x=BgFQjk5\uM]X<<@HRmBeEQ@RUIex5<xB_F9W^SlQDU]XmuS@:H=mnba_IYKqeZq6XOC];`]`\`liCKazZbzPGjmhJQNrAiU_Di\FpUI`dZZ;\B1]@ZLh1xHe"
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
566,8
Select DimEmployee.EmployeeKey, DimEmployee.ParentEmployeeKey,
  DimEmployee.EmployeeNationalIDAlternateKey,
  DimEmployee.ParentEmployeeNationalIDAlternateKey,
  DimEmployee.SalesTerritoryKey, DimEmployee.FirstName, DimEmployee.LastName,
  DimEmployee.MiddleName, DimEmployee.NameStyle, DimEmployee.Title,
  DimEmployee.Phone, DimEmployee.EmailAddress, DimEmployee.DepartmentName
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
560,0
561,0
590,0
637,0
577,14
vEmployeekey
vParentemployeekey
vEmployeenationalidalternatekey
vParentemployeenationalidalternatekey
vSalesterritorykey
vFirstname
vLastname
vMiddlename
vNamestyle
vTitle
vPhone
vEmailaddress
vDepartmentname
vRegion
578,14
1
1
2
2
1
2
2
2
2
2
2
2
2
2
579,14
1
2
3
4
5
6
7
8
9
10
11
12
13
14
580,14
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
0
0
581,14
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
0
0
582,14
VarType=33ColType=827
VarType=33ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
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
572,57

#****Begin: Generated Statements***
#****End: Generated Statements****

## This Process Builds the Employee Dimension ##


cDimName = 'Employee';
cTopNode = 'All Employees';

DatasourceNameForServer = 'Employee.csv';
DatasourceNameForClient = 'Employee.csv';

DimensionDeleteallElements(cDimName);

## Create Dimension if it does not exist ##
IF ( DimensionExists(cDimName) = 0 ) ;
  DimensionCreate(cDimName);
ENDIF;



Dimensionsortorder(cDimName,'ByInPut','Ascending','ByHierarchy','Ascending');

## Insert constant elements ##
DimensionElementInsert(cDimName,'',cTopNode,'C');



## Unwind the Dimension ##
# Iterate through dimensions and for each consolidated element, disconnect its components
nElementCount = DIMSIZ ( cDimName );
iCount = 1;

WHILE ( iCount <= nElementCount );
  sElement = DIMNM ( cDimName, iCount );
  IF ( DTYPE ( cDimName, sElement ) @= 'C' );
    nChildren = ELCOMPN ( cDimName, sElement );
    iChild = nChildren;
    WHILE ( iChild > 0 );
      sChild = ELCOMP ( cDimName, sElement, iChild );
      DimensionElementComponentDelete ( cDimName, sElement, sChild );
      iChild = iChild - 1;
    END;
  ENDIF;
  iCount = iCount + 1;
END;


## Insert Attributes ##
cAttr1 = 'Full Name';


AttrInsert(cdimName,'',cAttr1,'A');
AttrInsert(cdimName,'','Region','S');
AttrInsert(cdimName,'','Department Name','S');

573,16

#****Begin: Generated Statements***
#****End: Generated Statements****

## Clean Metadata ##
sEmployeeID = Trim(vEmployeenationalidalternatekey);

## Insert n Level Elements and rollup into Associated Parent ##
DimensionElementInsert(cDimName,'',sEmployeeID, 'N');
#DimensionElementInsert(cDimName,'',vDepartmentname,'C');

#DimensionElementcomponentAdd(cDimName,vDepartmentName,sEmployeeID,1);
#DimensionElementcomponentAdd(cDimName,cTopNode,vDepartmentName,1);


DimensionElementcomponentAdd(cDimName,cTopNode,sEmployeeID,1);
574,28

#****Begin: Generated Statements***
#****End: Generated Statements****

## Clean Metadata ##
sEmployeeID = Trim(vEmployeenationalidalternatekey);

## Insert Attributes ##
cAttr = 'Full Name';
sValue = vFirstName | ' ' | vLastName | ' ' | vMiddleName;

AttrPutS(sValue,cDimName,sEmployeeID,cAttr);

AttrPutS(vDepartmentname,cDimName,sEmployeeID,'Department Name');
AttrPutS(vRegion,cDimName,sEmployeeID,'Region');
#AttrPutS('2011-01-01',cDimName,sEmployeeID,'StartDate');

CellPutS('2011-01-01','Employee','Budget','2016','Year_Enter','Local',vRegion,vDepartmentname,sEmployeeID,'Start Date');
CellPutS('2050-12-31','Employee','Budget','2016','Year_Enter','Local',vRegion,vDepartmentname,sEmployeeID,'End Date');

CellPutS('2011-01-01','Employee','Budget','2015','Year_Enter','Local',vRegion,vDepartmentname,sEmployeeID,'Start Date');
CellPutS('2050-12-31','Employee','Budget','2015','Year_Enter','Local',vRegion,vDepartmentname,sEmployeeID,'End Date');

CellPutS('2011-01-01','Employee','Actual','2016','Year_Enter','Local',vRegion,vDepartmentname,sEmployeeID,'Start Date');
CellPutS('2050-12-31','Employee','Actual','2016','Year_Enter','Local',vRegion,vDepartmentname,sEmployeeID,'End Date');

CellPutS('2011-01-01','Employee','Actual','2015','Year_Enter','Local',vRegion,vDepartmentname,sEmployeeID,'Start Date');
CellPutS('2050-12-31','Employee','Actual','2015','Year_Enter','Local',vRegion,vDepartmentname,sEmployeeID,'End Date');
575,7

#****Begin: Generated Statements***
#****End: Generated Statements****



#ExecuteProcess('Bedrock.Dim.Sub.Create.All', 'pDimension', cDimName, 'pSubset', 'All Elements');
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
