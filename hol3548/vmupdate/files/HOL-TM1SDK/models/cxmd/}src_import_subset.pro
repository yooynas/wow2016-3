601,100
602,"}src_import_subset"
562,"CHARACTERDELIMITED"
586,"C:\_demo\A_CW_Demo\Data\Year}subs\Dyna.sub"
585,"C:\_demo\A_CW_Demo\Data\Year}subs\Dyna.sub"
564,
565,"qw1r_5gE>Y]]turx_a3S`RvcT:D;]4pu8pNKFU]N]TsU?F\H<zcTZTSHsiXZGHWmhf;[Ql7;C=61BCbOoV145Yi4mNoqa`xZS`@[]Rbcn6n<m=Q:Jt@eVect\z?Bs`?IiBA;pc:Nud:iPZ3`d4^9L\UC\qpoY<U6=JQd@a9gVsd\i4O1F4pN>K6LX9Ue?ouG7t`\LFMm"
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
pDim
pPathToSub
pSubName
pSubOverwrite
pDebug
561,5
2
2
2
1
1
590,5
pDim,"AAA"
pPathToSub,"C:\_demo\A_CW_Demo\Import"
pSubName,"Default - AAA"
pSubOverwrite,1
pDebug,0
637,5
pDim,""
pPathToSub,""
pSubName,""
pSubOverwrite,""
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
572,88

#****Begin: Generated Statements***
#****End: Generated Statements****

################ OBJECTIVE #####################################################
#
# Re-creating a Subset
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

# Dimension(s)
cDim = pDim;

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
cSubset = pSubName;
cSubsetFile = cSubset | '.sub';
cFullFilePath = pPathToSub | '\' | cSubsetFile;

nLineNo = 0;

nMetaDataStartFlag = 1;
nDataStartFlag = 1;

nSubsetFinishedCreationFlag = 0;
nSubsetExistFlag = 0;

#--------------------------------
# VALIDATION
#--------------------------------
nSubsetExistFlag = SubsetExists(cDim, cSubset);
if(nSubsetExistFlag = 1 & pSubOverwrite <> 1);
    AsciiOutput(cLogFile, 'Subset [' | cSubset | '] exists in [' | cDim | ']. Please delete first.');
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

573,74

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
# 1. Retrieve MDX - if present
# --------------------------------------------
if(sCode @= cCode_MDX & sData @<> '');
    nGetMDXFlag = 1;
    nMDXLineData = nLineNo + 1;
endif;

if(nGetMDXFlag = 1 & nLineNo = nMDXLineData);
    sMDX = sData;
    nGetMDXFlag = 0;
endif;

# --------------------------------------------
# 2. Retrieve Alias - if present
# --------------------------------------------
if(sCode @= cCode_Alias);
    sAlias = sData;
endif;

# --------------------------------------------
# 3. Retrieve Element Count - for static subset only
# --------------------------------------------
if(sCode @= cCode_ElementCount);
    nTotalElements = if(sData @<> '', numbr(sData), 0);
endif;

# --------------------------------------------
# 4. Flag if to include ALL ELEMENTs - for static subset only
# --------------------------------------------
if(sCode @= cCode_IncludeAllElements);
    nIncludeAllElementsFlag = if(sData @= '1', 1, 0);
endif;

# --------------------------------------------
# 5. Flag if to Expand Above
# --------------------------------------------
if(sCode @= cCode_ExpandAbove);
    nExpandAboveFlag = if(sData @= '1', 1, 0);
endif;

# --------------------------------------------
# CHECK
# --------------------------------------------
if(pDebug = 1);
    AsciiOutput(cLogFileMetaData, 'DEBUG', 'sMDX', sMDX, 'sAlias', sAlias, 'nTotalElements', numbertostring(nTotalElements));
endif;

574,98

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
    AsciiOutput(cLogFileData, 'DATA', numbertostring(nLineNo), sCode, sData, numbertostring(nSubsetFinishedCreationFlag));
endif;

# --------------------------------------------
# Create Subset
# --------------------------------------------
if(nSubsetFinishedCreationFlag = 0);

    # a. Static
    # --------------------------------------------
    if(sMDX @= '');
        
        # a. manual element insert
        if(nTotalElements > 0);
            
            # a.1. Insert User Selected Elements
            if(nInsertThisElementFlag = 1);
                if(nElementsAdded <= nTotalElements);
                    nElementsAdded = nElementsAdded + 1;
                    SubsetElementInsert(cDim, cSubset, sData, nElementsAdded);
                    nSubsetFinishedCreationFlag = if(nElementsAdded = nTotalElements, 1, 0);
                endif;
            endif;
            
            # a.2. Prepare Subset
            if(sCode @= cCode_ElementCount);
                nInsertThisElementFlag = 1;
                
                # Create/Re-Create Subset
                if(nSubsetExistFlag = 1);
                    SubsetDeleteAllElements(cDim, cSubset);
                else;
                    SubsetCreate(cDim, cSubset);
                endif;
            endif;    
        endif;
        
        # b.1. manual element insert - all elements
        if(nIncludeAllElementsFlag = 1);
            # Create/Re-Create Subset
            if(nSubsetExistFlag = 1);
                SubsetDeleteAllElements(cDim, cSubset);
            else;
                SubsetCreate(cDim, cSubset);
            endif;
            
            # insert all element(s)
            nDimSize = dimSiz(cDim);
            nIndex = 1;
            while(nIndex <= nDimSize);
                SubsetElementInsert(cDim, cSubset, dimnm(cDim, nIndex), nIndex);
                nIndex = nIndex + 1;
            end;
            
            nSubsetFinishedCreationFlag = 1;
        endif;
    
    # b. Dynamic
    # --------------------------------------------
    elseif(sMDX @<> '');
        
        # Create/Re-Create Subset
        # possible to use SubsetMDXGet/SubsetMDXSet, however this is for 10.2.2 at least
        # Reference: http://www-01.ibm.com/support/docview.wss?uid=swg27042401
        if(nSubsetExistFlag = 1);
            SubsetDestroy(cDim, cSubset);
        endif;
        
        SubsetCreatebyMDX(cSubset, sMDX);
        nSubsetFinishedCreationFlag = 1;
    endif;
else;
    ProcessBreak;
endif;

575,17

#****Begin: Generated Statements***
#****End: Generated Statements****

# --------------------------------------------
# Update Subset Properties
# --------------------------------------------
if(nSubsetFinishedCreationFlag = 1);
    # Set Alias
    if(sAlias @<> '');
        SubsetAliasSet(cDim, cSubset, sAlias);
    endif;
    
    # Set Expand Above
    SubsetExpandAboveSet(cDim, cSubset, nExpandAboveFlag);
endif;

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
