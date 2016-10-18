601,100
602,"}tp_clean_owner_groups"
562,"NULL"
586,
585,
564,
565,"m6wXV`x6xAvvma2TH42nlSC9AI``k82ARF^XM=<cd]]l1;xznpDztG7_W?7vYbX1]M[y1OTUPotisEorvFX3gi:xKY;jyO2Q0Yn8p[SG5G:hlL2FXPOxw7jE^aSyNgRGGDIfchO0Q5ykr0Cn\VngfcN>E9:ZsBQybwmuk@izkutbFfws13;KF6\UETBhlV1udRM;EtuT"
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
560,2
pExecutionId
pApprovalDim
561,2
2
2
590,2
pExecutionId,"None"
pApprovalDim,"None"
637,2
pExecutionId,
pApprovalDim,
577,0
578,0
579,0
580,0
581,0
582,0
572,126


#################################################################
## IBM Confidential
##
## OCO Source Materials
##
## BI and PM: pmpsvc
##
## (C) Copyright IBM Corp. 2008, 2009, 2010
##
## The source code for this program is not published or otherwise
## divested of its trade secrets, irrespective of what has been
## deposited with the U.S. Copyright Office.
#################################################################

# This script deletes all owner groups created for a particular
# approval dimension, or absolutely all owner groups if an empty
# pApprovalDim parameter is supplied. 
# Since only one boxboro application
# can use a particular approval dimension at a time, this
# process deletes all owner groups associated with the 
# approval dimension without regard to particular subsets.



# SETUP PROCESS

	#*** Constants

	cControlPrefix = '}';
	cTM1Process = GetProcessName();
	cApprovalDim = pApprovalDim;
	cGroupsDim = '}Groups';
	pControl = 'Y';
	
	
	#*** Configure logging	

	# Get log file name
	StringGlobalVariable('gPrologLog');
	vReturnValue = ExecuteProcess(
			cControlPrefix | 'tp_get_log_file_names',
			'pExecutionId', pExecutionId, 
			'pProcess', cTM1Process, 
			'pControl', pControl);
	If (vReturnValue <> ProcessExitNormal());
		ProcessError;
	EndIf;
	cTM1Log = gPrologLog;
	
	# Retrieve flag for generating logs
	cConfigDim = cControlPrefix | 'tp_config';
	If (DimensionExists(cConfigDim) = 1);
		cGenerateLog = ATTRS(cControlPrefix | 'tp_config', 'Generate TI Log', 'String Value');
	Else;
		cGenerateLog = 'N';
	EndIf;
		

	#*** Log parameters

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 
				'Parameters:', pExecutionId, pApprovalDim);
	EndIf;
		

#*** Get lock - will be held until process exits

#cLockName = 'tp_semaphore';
#Synchronized( cLockName ) ;


# DELETE OWNER GROUPS
	# Go through the list of groups in reverse order looking for
	# owner groups - all owner groups if no pApprovalDim is supplied,
	# or only owner groups with pApprovalDim as part of their
	# prefix otherwise.	

	# Determine the prefix used to identified owner groups to delete
	If (cApprovalDim @= '');
		# we have been asked to remove all owner groups regardless of approval hierarchy
		cOwnerGroupPrefix = cControlPrefix | 'tp_owner_';
	Else;
		cOwnerGroupPrefix = cControlPrefix | 'tp_owner_' | cApprovalDim | '_';
	EndIf;
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log,  TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 
				'will delete all groups with prefix', cOwnerGroupPrefix);
	EndIf;

	# Loop through all groups in reverse order so we can delete as we go
	cGroupsDimSize = DIMSIZ(cGroupsDim);
	vIndex = cGroupsDimSize;
	vDeletedCount = 0;
	While (vIndex >= 1);
		vGroupName = DIMNM(cGroupsDim, vIndex);

		If (SCAN(cOwnerGroupPrefix, vGroupName) = 1);
			If (cGenerateLog @='Y');
				TextOutput(cTM1Log,  TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 
						'identified group to delete', vGroupName);
			EndIf;
			DeleteGroup(vGroupName);
			vDeletedCount = vDeletedCount +1;
		EndIf;

		vIndex = vIndex - 1;
	End;
		
	# Note how many groups were actually deleted
	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, 'number of groups deleted', NumberToString(vDeletedCount));
	EndIf;




# FINISH PROCESS

	#*** Log successful completion

	If (cGenerateLog @= 'Y');
		TextOutput(cTM1Log, TIMST(NOW, '\Y-\m-\d \h:\i:\s'), 'The end has been reached.');
	EndIf;
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
