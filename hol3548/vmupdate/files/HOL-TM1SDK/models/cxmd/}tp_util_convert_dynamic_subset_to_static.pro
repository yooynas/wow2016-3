﻿601,100
602,"}tp_util_convert_dynamic_subset_to_static"
562,"NULL"
586,
585,
564,
565,"qoopAxxAYh;T20gFkaVi8[HS<0CKg=S=go7yMCL5<O64Sim4XeBsX?2i_TFP_UxPbeaCTD;te17:r=a44PbBn@:5V<nHw[nn0[BUCJ6mY1zxszK_A3GmP4[d1NtRnk6i_3sUWCFmT>VD=rlPbOX0CVlxA7TwGfVMB6JpF;pH<BJj4yqk6x<;rovtDG:juz_2`Rm=f1sI"
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
560,3
pExecutionId
pDim
pSubset
561,3
2
2
2
590,3
pExecutionId,"None"
pDim,"None"
pSubset,"None"
637,3
pExecutionId,
pDim,
pSubset,
577,0
578,0
579,0
580,0
581,0
582,0
572,42


#################################################################
## IBM Confidential
##
## OCO Source Materials
##
## BI and PM: pmpsvc
##
## (C) Copyright IBM Corp. 2010
##
## The source code for this program is not published or otherwise
## divested of its trade secrets, irrespective of what has been
## deposited with the U.S. Copyright Office.
#################################################################



# Make sure dimension and subset exist
If (DimensionExists(pDim) = 0);
ProcessError;
EndIf;

If (SubsetExists(pDim, pSubset) = 0);
ProcessError;
EndIf;
 
If (SubsetGetSize(pDim, pSubset) = 0);

#do nothing
else;

# Get the first element from subset
cFirstElem = SubsetGetElementName(pDim, pSubset, 1);

# Insert this element back to the subset at the end
SubsetElementInsert(pDim, pSubset, cFirstElem, SubsetGetSize(pDim, pSubset) + 1);

# Remove this inserted element
SubsetElementDelete(pDim, pSubset, SubsetGetSize(pDim, pSubset));

ENdIf;
573,1

574,1

575,1

576,
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
