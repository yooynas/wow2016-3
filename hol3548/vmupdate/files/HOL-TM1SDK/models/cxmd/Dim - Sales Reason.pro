601,100
602,"Dim - Sales Reason"
562,"ODBC"
586,"Adventure Works x64"
585,"Adventure Works x64"
564,
565,"u[Q0UHV1[3SAcKtxLsSSraAtMHCtEG`5M@;Kfw`RynRA@_nLUpSQJ5yqNT^2mapuKK_v?gka`yNoZ6:z5`sU8uxbYE\YQX;H6ULQT2M[`yl^?r4]:vrIXKf1Fd8e?y=UTenbnF=rAd?lUrJ^q:YCefMSaO?9eCwj[U8AP>Z=3W@I<775d?qb?9?:kOAFycm9Qevmru13"
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
566,1
select * from dimSalesReason
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
577,2
SalesReasonName
SalesReasonReasonType
578,2
2
2
579,2
3
4
580,2
0
0
581,2
0
0
582,4
IgnoredInputVarName=SalesReasonKeyVarType=33ColType=1165
IgnoredInputVarName=SalesReasonAlternateKeyVarType=33ColType=1165
VarType=32ColType=827
VarType=32ColType=827
931,1
0,0,0,0,
603,0
572,9

#****Begin: Generated Statements***
#****End: Generated Statements****

vDimName = 'Sales Reason';

AttrInsert(vDimName, '', 'Reason Type', 'S');

DimensionSortOrder ('Sales Reason', 'ByName', 'Ascending', 'ByLevel', 'Ascending');
573,6

#****Begin: Generated Statements***
#****End: Generated Statements****

DimensionElementComponentAdd(vDimName, 'Total Sales Reason', SalesReasonName, 1);

574,5

#****Begin: Generated Statements***
#****End: Generated Statements****

AttrPutS(SalesReasonReasonType, vDimName, SalesReasonName, 'Reason Type');
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
