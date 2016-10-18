601,100
602,"}src_import_view"
562,"CHARACTERDELIMITED"
586,"C:\_demo\A_CW_Demo\Import\views\check.vue"
585,"C:\_demo\A_CW_Demo\Import\views\check.vue"
564,
565,"cu;av1s>Bo;u\uZT::lwJvLjFZihPc>ibs9]:hLSC9_U_8Qd^dBfRkhK_Ip5YsyuY]wH6NthEk=QcA2Y9:dsxz5uWT8atYy5zZIC7p_=mlb<lvw^EBsE1p3IyaLfYYW8?o:X@]hSdudhLviXtt>7@IL^Kx=9pcyzhC`2:doE<_;hZA7ScCvwjGk9I_1O7m^3YdN^]Cpd"
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
567,"|"
588,"."
589,","
568,""""
570,
571,
569,0
592,0
599,1000
560,5
pCube
pPathToVue
pViewName
pViewOverwrite
pDebug
561,5
2
2
2
1
1
590,5
pCube,"Currency Exchange Rates"
pPathToVue,"C:\_demo\A_CW_Demo\Import\views"
pViewName,"check2"
pViewOverwrite,1
pDebug,0
637,5
pCube,""
pPathToVue,""
pViewName,""
pViewOverwrite,""
pDebug,""
577,1
vData
578,1
2
579,1
1
580,1
0
581,1
0
582,2
VarType=32ColType=827
IgnoredInputVarName=V2VarType=32ColType=1165
603,0
572,112

#****Begin: Generated Statements***
#****End: Generated Statements****

################ OBJECTIVE #####################################################
#
# Re-creating a View
#             

# HISTORY 
# 26/11/2015     Cubewise   Initial Build

#### NOTES ####
# -
# 
# Approx Time  < 30 secs
# Approx File Size n/a
###############################################################################

#--------------------------------
# Initialize Parameters
#--------------------------------
sTimestamp = TimSt(Now, '\Y-\m-\d_\h\iH\sS');
cProcessName = GetProcessName();
sRandomInt = NumberToString( INT( RAND( ) * 1000 ));

cLogFile = GetProcessErrorFileDirectory | sTimestamp | '_' | cProcessName | '.' | sRandomInt | '.log';
cLogFileMetaData = GetProcessErrorFileDirectory | sTimestamp | '_' | cProcessName | '_METADATA.' | sRandomInt | '.log';
cLogFileData = GetProcessErrorFileDirectory | sTimestamp | '_' | cProcessName | '_DATA.' | sRandomInt | '.log';

# Cube
cCube = pCube;

# Alias Info
cCode_Alias = '274';
sAlias = '';

# MDX Info
cCode_MDX = '275';
nGetMDXFlag = 0;
nMDXLineData = 0;
sMDX = '';

# Element Info (for manual)
cCode_ElementCount = '270';
nTotalElements = 0;
nInsertThisElementFlag = 0;
nElementsAdded = 0;

cCode_IncludeAllElements = '278';
nIncludeAllElementsFlag = 0;

# Expand Above Info
cCode_ExpandAbove = '281';
nExpandAboveFlag = 0;

# Other(s)
cView = pViewName;
cViewFile = cView | '.vue';
cFullFilePath = pPathToVue | '\' | cViewFile;

nLineNo = 0;

nMetaDataStartFlag = 1;
nDataStartFlag = 1;

nViewExistsFlag = 0;


cAxis_Title = 1;
cAxis_Row = 2;
cAxis_Column = 3;
nAxisCurrent = -1;
nAxisPrevious = -1;



sAxisDimension = '';

sCodePrevious = '';

nAxisDimensionCount = -1;
nAxisDimensionIndex = 0;
nAxisDimensionElementAddMode = 0;
nAxisDimensionElementAdded = 0;
nAxisDimensionElementTotal = 0;

sAxisDimensionSubset = 'Subset.Migrated.' | sRandomInt;
sAxisDimensionAlias = '';

nSupressZero_Row = 0;
nSupressZero_Col = 0;

#--------------------------------
# VALIDATION
#--------------------------------
nViewExistsFlag = ViewExists(cCube, cView);
if(nViewExistsFlag = 1 & pViewOverwrite <> 1);
    AsciiOutput(cLogFile, 'View [' | cView | '] exists in [' | cCube | ']. Please delete first.');
    ProcessError;
endif;

#--------------------------------
# (SOURCE) Set Datasource
#--------------------------------
if(FileExists(cFullFilePath) = 1);
    DatasourceNameForServer = cFullFilePath;
else;
    DataSourceType = 'NULL';
    DatasourceNameForServer = 'NULL';
endif;

573,39

#****Begin: Generated Statements***
#****End: Generated Statements****

if(nMetaDataStartFlag = 1);
    nLineNo = 0;
    nMetaDataStartFlag = 0;
endif;

nLineNo = nLineNo + 1;

# --------------------------------------------
# 0. Determine if the line has a code, extract if so
# --------------------------------------------
sData = vData;
sCode = ''; nCommaLocation = scan(',', sData);
if(nCommaLocation > 0 & nCommaLocation <= 4);
    sCode = subst(sData, 1, nCommaLocation - 1);
    sData = delet(sData, 1, nCommaLocation);
    sData = trim(sData);
endif;

if(pDebug = 1);
    AsciiOutput(cLogFileMetaData, 'DATA', numbertostring(nLineNo), sCode, sData);
endif;

# --------------------------------------------
# Get Suppress Zero Status
# --------------------------------------------
if(sCode @= '384');
    nSupressZero_Col = if(sData @= '1', 1, 0);
endif;

if(sCode @= '385');
    nSupressZero_Row = if(sData @= '1', 1, 0);
endif;



574,120

#****Begin: Generated Statements***
#****End: Generated Statements****

if(nDataStartFlag = 1);
    nLineNo = 0;
    nDataStartFlag = 0;
endif;

nLineNo = nLineNo + 1;

# --------------------------------------------
# 0. Determine if the line has a code, extract if so
# --------------------------------------------
sData = vData;
sCode = ''; nCommaLocation = scan(',', sData);
if(nCommaLocation > 0 & nCommaLocation <= 4);
    sCode = subst(sData, 1, nCommaLocation - 1);
    sData = delet(sData, 1, nCommaLocation);
    sData = trim(sData);
endif;

if(pDebug = 1);
    AsciiOutput(cLogFileData, 'DATA', numbertostring(nLineNo), sCode, sData);
endif;

# --------------------------------------------
# Process View
# --------------------------------------------

# Create View
if(sCode @= '390');
    if(nViewExistsFlag = 1);
        ViewDestroy(cCube, cView);
    endif;
    ViewCreate(cCube, cView);
endif;

# Axis Dimension Element Count
if(sCode @= '374');
    nAxis = cAxis_Title;
    nAxisPrevious = if(nAxisPrevious = -1, nAxis, nAxisCurrent);
    nAxisCurrent = nAxis;
    
    nAxisDimensionCount = numbr(sData);
elseif(sCode @= '371');
    nAxis = cAxis_Row;
    nAxisPrevious = if(nAxisPrevious = -1, nAxis, nAxisCurrent);
    nAxisCurrent = nAxis;
    
    nAxisDimensionCount = numbr(sData);
elseif(sCode @= '360');
    nAxis = cAxis_Column;
    nAxisPrevious = if(nAxisPrevious = -1, nAxis, nAxisCurrent);
    nAxisCurrent = nAxis;
    
    nAxisDimensionCount = numbr(sData);
endif;

# Axis Dimension
if(sCode @= '7');
    sAxisDimension = sData;
    
    if(nAxisPrevious = nAxisCurrent);
        nAxisDimensionIndex = nAxisDimensionIndex + 1;
    else;
        nAxisDimensionIndex = 1;
    endif;
    
    if(nAxisCurrent = cAxis_Title);
        ViewTitleDimensionSet(cCube, cView, sAxisDimension);
    elseif(nAxisCurrent = cAxis_Row);
        ViewRowDimensionSet(cCube, cView, sAxisDimension, nAxisDimensionIndex);
    elseif(nAxisCurrent = cAxis_Column);
        ViewColumnDimensionSet(cCube, cView, sAxisDimension, nAxisDimensionIndex);
    endif;
    
endif;

# Axis Dimension Element(s)
# what follows is either the name of the subset used in the view (6), or the count of the elements (270) in the dimension
if(nAxisDimensionElementAddMode = 1);
    if(nAxisDimensionElementAdded <= nAxisDimensionElementTotal);
        nAxisDimensionElementAdded = nAxisDimensionElementAdded + 1;
        SubsetElementInsert(sAxisDimension, sAxisDimensionSubset, sData, nAxisDimensionElementAdded);
    endif;
    
    if(nAxisDimensionElementAdded = nAxisDimensionElementTotal);
        nAxisDimensionElementAddMode = 0;
        ViewSubsetAssign(cCube, cView, sAxisDimension, sAxisDimensionSubset);
    endif;
endif;

if(sCodePrevious @= '7' & sCode @= '6');
    # if this is ALL, then ignore
    if(sData @<> 'ALL');
        ViewSubsetAssign(cCube, cView, sAxisDimension, sData);
    endif;
elseif(sCodePrevious @= '7' & sCode @= '270');
    nAxisDimensionElementTotal = numbr(sData);
    nAxisDimensionElementAdded = 0;
    nAxisDimensionElementAddMode = 1;
    SubsetCreate(sAxisDimension, sAxisDimensionSubset);
endif;

# Axis Dimension - Expand Above
if(sCode @= '281' & sData @= '1');
    # SubsetExpandAboveSet(sAxisDimension, sAxisDimensionSubset, 1);
endif;

# Axis Dimension - Alias
if(sCode @= '274' & sData @<> '');
    sAxisDimensionAlias = sData;
    SubsetAliasSet(sAxisDimension, sAxisDimensionSubset, sAxisDimensionAlias);
endif;

# Previous Code
sCodePrevious = sCode;


575,13

#****Begin: Generated Statements***
#****End: Generated Statements****

# --------------------------------------------
# Update View Properties
# --------------------------------------------
ViewRowSuppressZeroesSet(cCube, cView, nSupressZero_Row);
ViewColumnSuppressZeroesSet(cCube, cView, nSupressZero_Col);




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
