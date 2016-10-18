601,100
602,"Sys.DimDump"
562,"NULL"
586,
585,
564,
565,"b8aVg3HdJGX:2KMNJ8tVqki]yRNeFD]:C3bdV3OnvmJbt1keNwhyEbKXSykX2ZV`fy7h1<zPe3x9?r5JV_0iUFF`Dmf6Ez3uccllw>_v2e^uhd9y\1IgqdbzfP@CB^xw??Ee[LBBCQa2HHr:fK0hTPXV6v:xK:<]tLUf:Qqs_t1VF`mVq2hp@8B^8RkvyubhH]X[>BVZ"
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
560,1
pDimName
561,1
2
590,1
pDimName,""
637,1
pDimName,"The name of the dimension"
577,0
578,0
579,0
580,0
581,0
582,0
931,1

603,0
572,74

#****Begin: Generated Statements***
#****End: Generated Statements****


DatasourceASCIIQuoteCharacter='';
sElFileName = pDimName | '.dimx';

sAttrDimName = '}ElementAttributes_' | pDimName;
sAttributes = 'Attributes:';
ASCIIOutput(sElFileName, sAttributes);
sAttrTypes = '';
nAttrCount = DIMSIZ( sAttrDimName );
a = 1;
WHILE (a <= nAttrCount);
    sAttr = DIMNM( sAttrDimName , a);
    sAttr = sAttr | ': ' | SUBST( DTYPE( sAttrDimName, sAttr ), 2, 1 );
    ASCIIOutput(sElFileName, Fill(' ', 2) | sAttr);
    a = a + 1;
END;

ASCIIOutput(sElFileName, '');


# Loop through all of the elements
nElCount = DIMSIZ(pDimName);
n = 1;
WHILE (n <= nElCount);
    sEl = DIMNM(pDimName, n);
    If( SCAN (',', sEl) > 0 % SCAN ('#', sEl) > 0 % SCAN (':', sEl) > 0);
        ASCIIOutput(sElFileName, '"' | sEl | '":');
    Else;
        ASCIIOutput(sElFileName, sEl | ':');
    EndIf;



    # Type
    sType = DTYPE(pDimName, sEl);
    ASCIIOutput(sElFileName, Fill(' ', 2) | 'Type: ' | sType);


    sAttributes = Fill(' ', 2) | 'Attributes:';
    ASCIIOutput(sElFileName, sAttributes);
    nAttrCount = DIMSIZ( sAttrDimName );
    a = 1;
    WHILE (a <= nAttrCount);
        sAttr = DIMNM( sAttrDimName , a);
        sAttrType = SUBST( DTYPE( sAttrDimName, sAttr ), 2, 1 );
        If( sAttrType @= 'N' );
            sAttrVal = NumberToString(ATTRN(pDimName, sEl, sAttr));
        Else;
            sAttrVal = ATTRS(pDimName, sEl, sAttr);
        EndIf;
        ASCIIOutput(sElFileName, Fill(' ', 4) | sAttr | ': ' | sAttrVal );
        a = a + 1;
    END;

    # Loop through all of the parents
    sParents = Fill(' ', 2) | 'Parents:';
    ASCIIOutput(sElFileName, sParents);
    nParentCount = ELPARN(pDimName, sEl);
    p = 1;
    WHILE (p <= nParentCount);
        sPar = ELPAR(pDimName,  sEl, p);
        ASCIIOutput(sElFileName, Fill(' ', 4) | sPar | ': ' | NumberToString(ELWEIGHT(pDimName, sPar, sEl)) );
        p = p + 1;
    END;


    ASCIIOutput(sElFileName, '');

    n = n + 1;
END;
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
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
