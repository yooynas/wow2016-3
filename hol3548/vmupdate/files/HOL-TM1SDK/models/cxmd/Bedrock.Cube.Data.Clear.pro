601,100
602,"Bedrock.Cube.Data.Clear"
562,"NULL"
586,
585,
564,
565,""
559,0
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
560,8
pCube
pView
pFilter
pDimensionDelim
pElementStartDelim
pElementDelim
pDestroyTempObj
pDebug
561,8
2
2
2
2
2
2
1
1
590,8
pCube,""
pView,""
pFilter,""
pDimensionDelim,"&"
pElementStartDelim,":"
pElementDelim,"+"
pDestroyTempObj,1
pDebug,0
637,8
pCube,"Cube Name"
pView,"Temp view name"
pFilter,"Filter: Year: 2006 + 2007 & Scenario: Actual + Budget & Organization: North America Operations"
pDimensionDelim,"Delimiter for start of Dimension/Element set"
pElementStartDelim,"Delimiter for start of element list"
pElementDelim,"Delimiter between elements"
pDestroyTempObj,"Delete temporary view and Subset ( 0 = Retain View and Subsets 1 = Delete View and Subsets 2 = Delete View only )"
pDebug,"Debug Mode"
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,1
k='Bedrock.Cube.Data.Clear';n=tm1user();b=timst(now,'\Y\m\d\h\i\s');c=numbertostring(int(rand()*1000));p=getprocesserrorfiledirectory|k|'.'|b|'.'|c;a='Bedrock_'|c;if(pdebug>=1);h=p|'Prolog.debug';asciioutput(h,'Process Started: '|timst(now,'\d-\m-\Y \h:\i:\s'));asciioutput(h,'TM1 User:        '|n);asciioutput(h,'');asciioutput(h,'Parameters: pCube:              '|pcube);asciioutput(h,'            pView:              '|pview);asciioutput(h,'            pFilter:            '|pfilter);asciioutput(h,'            pDimensionDelim:    '|pdimensiondelim);asciioutput(h,'            pElementStartDelim: '|pelementstartdelim);asciioutput(h,'            pElementDelim:      '|pelementdelim);asciioutput(h,'            pDestroyTempObj:     '|numbertostring(pdestroytempobj));asciioutput(h,'');asciioutput(h,'Default Temporary View Name : '|a);asciioutput(h,'');endif;y=0;if(trim(pdimensiondelim)@='');pdimensiondelim='&';endif;if(trim(pelementstartdelim)@='');pelementstartdelim=':';endif;if(trim(pelementdelim)@='');pelementdelim='+';endif;if(trim(pcube)@='');if(pdebug>=1);i='No cube specified';asciioutput(h,i);endif;processquit;endif;if(cubeexists(pcube)=0);if(pdebug>=1);i='Cube: '|pcube|' does not exist';asciioutput(h,i);endif;processquit;endif;if(trim(pview)@='');if(pdebug>=1);i='Using default view: '|a;asciioutput(h,i);endif;d=a;else;if(pdebug>=1);i='Using view: '|pview;asciioutput(h,i);endif;d=pview;endif;if(trim(pfilter)@='');if(pdebug>=1);i='Filter has not been specified. User "Clear Cube" as the filter to zero out the entire cube. ';asciioutput(h,i);endif;processquit;elseif(trim(pfilter)@='Clear Cube');pfilter='';endif;if(pdebug>=1);asciioutput(h,'Create view.');endif;if(pdebug<=1);g=executeprocess('Bedrock.Cube.View.Create','pCube',pcube,'pView',d,'pFilter',pfilter,'pSuppressZero',1,'pSuppressConsol',1,'pSuppressRules',1,'pDimensionDelim',pdimensiondelim,'pElementStartDelim',pelementstartdelim,'pElementDelim',pelementdelim,'pDebug',pdebug);endif;if(pdebug>=1);asciioutput(h,'View and Subsets created');endif;if(pdebug<=1);if(g=processexitnormal());viewzeroout(pcube,d);else;asciioutput(h,'Process Bedrock.Cube.View.Create Failed, nothing will be ZeroOut');endif;endif;
573,1

574,1

575,1
if(pdebug>=1);h=p|'Epilog.debug';endif;if(pdebug<=1);executeprocess('Bedrock.Cube.ViewAndSubsets.Delete','pCube',pcube,'pView',d,'pSubset',d,'pMode',pdestroytempobj,'pDebug',pdebug);endif;if(pdebug>=1);asciioutput(h,'Process Finished: '|timst(now,'\d-\m-\Y \h:\i:\s'));endif;
576,CubeAction=1511DataAction=1503CubeLogChanges=0
930,0
638,1
804,0
1217,1
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
918,0
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""

