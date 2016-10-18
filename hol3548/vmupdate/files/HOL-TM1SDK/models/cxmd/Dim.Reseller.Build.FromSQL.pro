601,100
602,"Dim.Reseller.Build.FromSQL"
562,"ODBC"
586,"AdventureWorks"
585,"AdventureWorks"
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
566,2
Select DimReseller.*
From DimReseller
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
577,20
vResellerKey
GeographyKey
ResellerAlternateKey
Phone
BusinessType
vResellerName
NumberEmployees
OrderFrequency
OrderMonth
FirstOrderYear
LastOrderYear
ProductLine
AddressLine1
AddressLine2
AnnualSales
BankName
MinPaymentType
MinPaymentAmount
AnnualRevenue
YearOpened
578,20
2
2
2
2
2
2
1
2
1
1
1
2
2
2
2
2
1
2
2
1
579,20
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
15
16
17
18
19
20
580,20
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
0
0
0
0
0
0
581,20
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
0
0
0
0
0
0
582,20
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=33€ColType=827€
VarType=32€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=33€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=33€ColType=827€
VarType=32€ColType=827€
VarType=32€ColType=827€
VarType=33€ColType=827€
931,1
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
603,0
572,27

#****Begin: Generated Statements***
#****End: Generated Statements****

### This Process Builds the Reseller Dimension ###

## CONSTANTS ##
cDimName = 'Reseller';
cTopNode1 = 'All Resellers';


## Create Dimension if it does not exist ##
If ( DimensionExists (cDimName ) = 0 ) ;
  DimensionCreate(cDimName);
  Else;
  DimensionDeleteAllElements(cDimName);
ENDIF;

DimensionSortOrder(cDimName,'ByName','Ascending','ByHierarchy','Ascending');


## Insert Top Node of Consolidations ##
DimensionElementInsert(cDimName,'',cTopNode1,'C');




573,24

#****Begin: Generated Statements***
#****End: Generated Statements****


#### Consolidation 1 ####

# Remove dot from end of key
sString = vResellerKey; 
nLength = LONG(sString);
sLastCharacter = SUBST(sString, nLength, 1);
If(sLastCharacter @= '.');
  sString = SUBST(sString, 1, nLength - 1);
EndIf;

sResellerKey = sString;


## Insert N Level elements ##
DimensionElementInsert(cDimName,'',sResellerKey,'N');

## Assign Parent to Child Relationship ##
DimensionElementComponentAdd(cDimName, cTopNode1, sResellerKey,1);

574,20

#****Begin: Generated Statements***
#****End: Generated Statements****

# Remove dot from end of key
sString = vResellerKey; 
nLength = LONG(sString);
sLastCharacter = SUBST(sString, nLength, 1);
If(sLastCharacter @= '.');
  sString = SUBST(sString, 1, nLength - 1);
EndIf;
sResellerKey = sString;

# Update Alias
If(sResellerKey @= '643' % sResellerKey @= '649');
  vResellerName = vResellerName | ' (' | sResellerKey | ')';
EndIF;

AttrPutS(vResellerName, 'Reseller', sResellerKey, 'FullName');

575,4

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
