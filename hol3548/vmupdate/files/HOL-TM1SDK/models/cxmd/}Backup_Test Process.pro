601,100
602,"}Backup_Test Process"
562,"CHARACTERDELIMITED"
586,"C:\Users\tryan\Documents\Cubewise\User Conference\Account_WithHeader.csv"
585,"C:\Users\tryan\Documents\Cubewise\User Conference\Account_WithHeader.csv"
564,
565,"kRe]9Uu=^:>a:sjVSh[5d^U;P[5jFqIUn9bk@ZWNjkoQK3B<2OvlC?1xWLPjRb4socky?DSnXh@z`[GMFF<r]fa2pX5J<8\8Fd_zK9uUNexU@Nf=Gkiwi70Wepxc\a8XxI1uULrITMIicxuGN@6BrlBx85YTV]oe_pM\U]QmgL=Yfc7a3h9@fRx_[CK9<b8`[L@ciHvK"
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
569,1
592,0
599,1000
560,2
param_destroy
param_createIfNotExist
561,2
1
1
590,2
param_destroy,0
param_createIfNotExist,1
637,2
param_destroy,Destroy dimensions
param_createIfNotExist,Create dimensions if they do not exist
577,2
Element
Parent
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
582,3
_DimCaption=New Account_DimType=GENERICVarType=32ColType=825VarDimension=newaccountVarDimOrder=1VarDimAction=UpdateVarElemType=NumericVarDimElemSortType=ByInputVarDimElemSortSense=ASCENDING_UserVisible=Element_UILabel=Element_DataType=STRING_SourceIndex=0
VarType=32ColType=858ConsolidationDim=newaccountConsolidationChildVar=ElementConsolidationChildWeight=1.0ComponentSortType=ByInputComponentSortSense=ASCENDING_UserVisible=Parent_UILabel=Parent_DataType=STRING_SourceIndex=1
VarType=32ColType=1165IgnoredInputVarName=Description_UserVisible=Description_UILabel=Description_DataType=STRING_SourceIndex=2
931,1
0,0,0,
603,0
572,25

#****Begin: Generated Header****
if (param_destroy = 1);
   DimensionDestroy('newaccount');
endif;
if (param_createIfNotExist = 1);
   if (0 = DimensionExists('newaccount'));
      DimensionCreate('newaccount');
      AttrInsert('newaccount', '', 'Caption_Default', 'A');
      CellPutS('GENERIC', '}DimensionAttributes', 'newaccount', 'DIMENSION_TYPE');
      AttrInsert('newaccount', '', 'Format', 'S');
      AttrInsert('newaccount', '', 'Picklist', 'S');
      AttrInsert('newaccount', '', 'calculation', 'S');
      AttrInsert('newaccount', '', 'crossdimcalc', 'S');
      SubsetCreateByMDX('All Members', '[newaccount].MEMBERS', 'newaccount');
      SubsetAliasSet('newaccount', 'All Members', 'Caption_Default');
   endif;
endif;
CellPutS('New Account', '}DimensionAttributes', 'newaccount', 'Caption_Default');
#****End: Generated Header****

#****Begin: Generated Statements***
DimensionSortOrder('newaccount', 'ByInput', 'ASCENDING', 'ByInput', 'ASCENDING');
#****End: Generated Statements****

573,4

#****Begin: Generated Statements***
#****End: Generated Statements****

574,25

#****Begin: Generated Header****
If(Element@='');
   Element='Element';
EndIf;
#****End: Generated Header****

#****Begin: Generated Statements***
DimensionElementInsertDirect('newaccount', '', Element, 'n');
DimensionElementInsertDirect('newaccount', '', Parent, 'c');
DimensionElementComponentAddDirect('newaccount', Parent, Element, 1.0);
#****End: Generated Statements****

#****Begin: Generated Footer****
#Special handling for parent-child hierarchy New Account
If(Parent@='');
    #do not insert child under empty parent
ElseIf(Parent@=Element);
    #do not insert child under itself
Else;
    DimensionElementInsertDirect('newaccount', '', Parent, 'n');
    DimensionElementComponentAddDirect('newaccount', Parent, Element, 1.0 );
EndIf;
#****End: Generated Footer****

575,4

#****Begin: Generated Statements***
#****End: Generated Statements****

576,ReplaceEmptyValues=1_ParseParams={&quotmeasures&quot:[]&#044&quothasHeader&quot:&quottrue&quot&#044&quotnumColumns&quot:&quot3&quot&#044&quotskipRows&quot:&quot0&quot&#044&quotlocale&quot:{&quotlanguange&quot:&quoten&quot&#044&quotvariant&quot:&quot&quot&#044&quotcountry&quot:&quotAU&quot}&#044&quotdimensions&quot:[{&quotdimensionType&quot:&quotGENERIC&quot&#044&quotleafSortDirection&quot:&quotASCENDING&quot&#044&quotconsolidatedSortDirection&quot:&quotASCENDING&quot&#044&quotqualifyHierarchy&quot:false&#044&quotcreateTotalRoot&quot:false&#044&quotinvariantName&quot:&quotnewaccount&quot&#044&quotparentMembers&quot:{&quotcolumnName&quot:&quotParent&quot&#044&quotnumberOfLongItems&quot:0&#044&quotcolumnKind&quot:&quotNone&quot&#044&quottotalItemsNum&quot:0&#044&quottotalValuesLength&quot:0&#044&quotsourceColumn&quot:1&#044&quotvarName&quot:&quotParent&quot&#044&quotnumberOfEmptyItems&quot:0&#044&quotisMeasure&quot:false&#044&quotelementWeight&quot:&quot1&quot&#044&quotminLength&quot:10&#044&quotexpression&quot:null&#044&quotexists&quot:false&#044&quotmaxLength&quot:0&#044&quotcolumnType&quot:&quotSTRING&quot&#044&quotlabel&quot:&quotParent Members&quot&#044&quottype&quot:&quotlevel&quot}&#044&quotisMeasureDimension&quot:false&#044&quotparentChild&quot:true&#044&quotconsolidatedSortType&quot:&quotNONE&quot&#044&quotstrategy&quot:&quotMERGE&quot&#044&quotlabel&quot:&quotNew Account&quot&#044&quotisMemberUpdateStrategyChanged&quot:false&#044&quotleafSortType&quot:&quotNONE&quot&#044&quotqualifySeparator&quot:&quot&#044 &quot&#044&quottype&quot:&quotdimension&quot&#044&quotexists&quot:false&#044&quotchildMembers&quot:{&quotcolumnName&quot:&quotElement&quot&#044&quotnumberOfLongItems&quot:0&#044&quotcolumnKind&quot:&quotNone&quot&#044&quottotalItemsNum&quot:0&#044&quottotalValuesLength&quot:0&#044&quotsourceColumn&quot:0&#044&quotvarName&quot:&quotElement&quot&#044&quotnumberOfEmptyItems&quot:0&#044&quotisMeasure&quot:false&#044&quotelementWeight&quot:&quot1&quot&#044&quotminLength&quot:10&#044&quotexpression&quot:null&#044&quotexists&quot:false&#044&quotmaxLength&quot:0&#044&quotcolumnType&quot:&quotSTRING&quot&#044&quotlabel&quot:&quotChild Members&quot&#044&quottype&quot:&quotlevel&quot}}]}_DeployParams={&quotdataAction&quot:&quotACCUMULATE&quot&#044&quotclass&quot:&quotDeployParams&quot&#044&quotdimensionConflictResolutions&quot:{}}_importSourceDefinition={"sourceTypeHasBeenChanged":false,"excludedColumns":[],"sourceType":"FILE","fileSource":{"filePath":"C:\\Users\\tryan\\Documents\\Cubewise\\User Conference\\Account_WithHeader.csv","excludedColumns":[],"fileType":"TEXT_DELIMITED","shapeParams":{"checkForCrosstab":false,"hasLabels":true},"dataShape":"LIST","parseParams":{"thousandsSeparator":",","decimalSeparator":".","delimiter":",","startRow":0,"startColumn":0,"quote":"\""},"remotePath":"","originalColumns":[],"columns":[{"columnName":"Element","numberOfLongItems":0,"totalItemsNum":99,"maxLength":4,"columnKind":"Hierarchy","totalValuesLength":371,"columnType":"STRING","sourceColumn":0,"varName":"Element","numberOfEmptyItems":0,"isMeasure":false,"expression":null,"minLength":1},{"columnName":"Parent","numberOfLongItems":0,"totalItemsNum":99,"maxLength":4,"columnKind":"Hierarchy","totalValuesLength":293,"columnType":"STRING","sourceColumn":1,"varName":"Parent","numberOfEmptyItems":3,"isMeasure":false,"expression":null,"minLength":1},{"columnName":"Description","numberOfLongItems":1,"totalItemsNum":99,"maxLength":34,"columnKind":"Attribute","totalValuesLength":1502,"columnType":"STRING","sourceColumn":2,"varName":"Description","numberOfEmptyItems":0,"isMeasure":false,"expression":null,"minLength":4}]},"locale":{"thousandsSeparator":",","localeCurrencySymbol":"$","countryCode":"AU","decimalSeparator":".","languageCode":"en","localeCode":"en_AU","localeCurrencyCode":"$","localeDisplay":"English (Australia)","languageDisplay":"English","countryDisplay":"Australia","localeIsDefault":false},"originalColumns":null,"columns":[{"columnName":"Element","numberOfLongItems":0,"totalItemsNum":99,"maxLength":4,"columnKind":"Hierarchy","totalValuesLength":371,"columnType":"STRING","sourceColumn":0,"varName":"Element","numberOfEmptyItems":0,"isMeasure":false,"expression":null,"minLength":1},{"columnName":"Parent","numberOfLongItems":0,"totalItemsNum":99,"maxLength":4,"columnKind":"Hierarchy","totalValuesLength":293,"columnType":"STRING","sourceColumn":1,"varName":"Parent","numberOfEmptyItems":3,"isMeasure":false,"expression":null,"minLength":1},{"columnName":"Description","numberOfLongItems":1,"totalItemsNum":99,"maxLength":34,"columnKind":"Attribute","totalValuesLength":1502,"columnType":"STRING","sourceColumn":2,"varName":"Description","numberOfEmptyItems":0,"isMeasure":false,"expression":null,"minLength":4}]}
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
