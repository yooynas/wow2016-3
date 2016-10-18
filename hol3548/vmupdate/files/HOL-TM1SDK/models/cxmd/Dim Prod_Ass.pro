601,100
562,"CHARACTERDELIMITED"
586,"\\lstmx101\deptdata\GFGDept\GFGTM1\SAP_Files\TM1SProdAss.csv"
585,"\\lstmx101\deptdata\GFGDept\GFGTM1\SAP_Files\TM1SProdAss.csv"
564,
565,"y?beAOQ4H@OY0iSI0cJjKPs96aL\wzIGKXosxXGkyXcvxm9n494`PBLm^cZ9<:Ysrfibi7G;y2e;szl_nN[S@nLpgq0Z8x5L@y93e5hoheK><Dqv;B6m_6cO;DV_M:uzEoD8HUyXyhDwvq;OZl1reI]8My9dYN<mQ8SL?B?rV2xDK`Nmy\=GQ]aR4uoQ^73va<:PYTYn"
559,0
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
577,10
V0
V1
V2
V3
V4
V5
V6
V7
V8
V9
578,10
2
2
2
2
2
2
2
2
2
2
579,10
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
580,10
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
581,10
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
582,10
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
572,11

#****GENERATED STATEMENTS START****
#****GENERATED STATEMENTS FINISH****


dim = 'Prod_Ass';

DimensionDeleteAllElements (dim);

DimensionSortOrder (dim, 'ByInput', 'Ascending', 'ByHierarchy', 'Descending') ;

573,64

#****GENERATED STATEMENTS START****
#****GENERATED STATEMENTS FINISH****

# Create Prod_Ass Dimension
# The BMA Group  17 July 2002

# Remove SAP prefix
# NB Test for null does not seem to be needed now...
# IF ( V2 @<> '' );
# V2 = SUBST ( V2, SCAN(' ',V2)+1,LONG(V2)-SCAN(' ',V2));
#  ENDIF;

# Set dimension name variable --------------------------------

   dim = 'Prod_Ass';
  
# Setup Level element names -----------------------------------
   S0 = V0;
   S1 = V0 | ' ' | V1;
   S2 = SUBST ( V2, SCAN(' ',V2)+1,LONG(V2)-SCAN(' ',V2));
   S3 = SUBST ( V3, SCAN(' ',V3)+1,LONG(V3)-SCAN(' ',V3));
   S4 = SUBST ( V4, SCAN(' ',V4)+1,LONG(V4)-SCAN(' ',V4));
   S5 = SUBST ( V5, SCAN(' ',V5)+1,LONG(V5)-SCAN(' ',V5));
      

# Create Level 0
   L0 = S0;
   DimensionElementInsert(dim, '', L0, 'N');  

# Create Level 1 - check for blanks and duplicates
   IF (S1 @<> '');
   L1 = IF( S1 @= S2 % S1 @= S3, S1 | ' (L1)', S1);  
   DimensionElementInsert(dim, '', L1, 'C');
   DimensionElementComponentAdd(dim, L1, L0, 1.0);
   ENDIF;

# Create Level 2 - check for blanks and duplicates
   IF (S2 @<> '');
       L2 = IF( S2 @= S3 % S2 @= S4, S2 | ' (L2)', S2);
      DimensionElementInsert(dim, '', L2, 'C');
      DimensionElementComponentAdd(dim, L2, L1, 1.0);
   ENDIF;

# Create Level 3 - check for blanks and duplicates
   IF (S3 @<> '');
      L3 = IF( S3 @= S4 % S3 @= S5, S3 | ' (L3)', S3);
      DimensionElementInsert(dim, '', L3, 'C');
      DimensionElementComponentAdd(dim, L3, L2, 1.0);
   ENDIF;

# Create Level 4 - check for blanks
   IF (S4 @<> '');
       L4 = IF( S4 @= S5, S4 | ' (L4)', S4);
      DimensionElementInsert(dim, '', L4, 'C');
      DimensionElementComponentAdd(dim, L4, L3, 1.0);
   ENDIF;

# Create Level 5 - check for blanks
   IF (S5 @<> '');
      L5 = S5;
      DimensionElementInsert(dim, '', L5, 'C');
      DimensionElementComponentAdd(dim, L5, L4, 1.0);
   ENDIF;
574,5

#****GENERATED STATEMENTS START****
#****GENERATED STATEMENTS FINISH****


575,5

#****GENERATED STATEMENTS START****
#****GENERATED STATEMENTS FINISH****


576,CubeAction=1511DataAction=1503CubeLogChanges=0
638,1
804,0
1217,1
900,
901,
902,
903,
906,
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
917,1
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
