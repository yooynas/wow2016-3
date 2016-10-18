601,100
602,"Dim.CloneOriginals"
562,"SUBSET"
586,"}Dimensions"
585,"}Dimensions"
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
560,0
561,0
590,0
637,0
577,1
vDim
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
572,5

#****Begin: Generated Statements***
#****End: Generated Statements****


573,5

#****Begin: Generated Statements***
#****End: Generated Statements****


574,72

#****Begin: Generated Statements***
#****End: Generated Statements****

sDim = vDim;

#Ignore the bedrock dimensions v1..v28
If(sDim @= 'v1'
   %
   sDim @='v2'
   %
   sDim @='v3'
   %
   sDim @='v4'
   %
   sDim @='v5'
   %
   sDim @='v6'
   %
   sDim @='v7'
   %
   sDim @='v8'
   %
   sDim @='v9'
   %
   sDim @='v10'
   %
   sDim @='v11'
   %
   sDim @='v12'
   %
   sDim @='v13'
   %
   sDim @='v14'
   %
   sDim @='v15'
   %
   sDim @='v16'
   %
   sDim @='v17'
   %
   sDim @='v18'
   %
   sDim @='v19'
    %
   sDim @='v20'
   %
   sDim @='v21'
   %
   sDim @='v22'
   %
   sDim @='v23'
   %
   sDim @='v24'
   %
   sDim @='v25'
   %
   sDim @='v26'
   %
   sDim @='v27'
   %
   sDim @='v28');
  ITEMSKIP;
ENDIF;
  
# Don't clone system dimensions
# Don't reclone Original dimensions
If(subst(sDim,1,1) @<> '}' & SCAN('Original', sDim) = 0);
  sSourceDim = sDim;
  sTargetDim = sSourceDim | ' Original';
  ExecuteProcess('Bedrock.Dim.Clone','pSourceDim',sSourceDim, 'pTargetDim', sTargetDim, 'pAttr',1, 'pDebug',1);
EndIf;
575,5

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
