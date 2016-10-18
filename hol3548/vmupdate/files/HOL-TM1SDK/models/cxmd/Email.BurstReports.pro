601,100
562,"NULL"
586,
585,
564,
565,"edd8Uaq``6eJ;lXir5qiRlNym^G6T7_4b;d9gOC_of[9liM41:4>1WpYyL7dXKrQ:i7iH@_`SbdfMq\nHxQfc\73rnLjTjhy[Sawg:Gz=NjN^F9zMo2u2ya0psQ\A:3aaW=u?PS5l69OK8T?Ks^F9<@=h8vCkgR:3ppVmUi6MA8WaTOqSfm01uHVbgH>kbh[wU;P5OZE"
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
pYear
pMonth
561,2
2
2
590,2
pYear,"2012"
pMonth,"Sep"
637,2
pYear,Year
pMonth,Month
577,0
578,0
579,0
580,0
581,0
582,0
572,24

#****Begin: Generated Statements***
#****End: Generated Statements****

DatasourceASCIIQuoteCharacter = '';
DatasourceASCIIDelimiter = '|';

sFileName = 'C:\TM1\Tools\PLReport.txt';

nCount = ELCOMPN('Region', 'Total Europe');
n = 1;
WHILE (n < nCount);
  sEl = ATTRS('Region', ELCOMP('Region', 'Total Europe', n), 'Description');
  TextOutput(sFileName, 'id:>' | sEl);
  TextOutput(sFileName, 'To:>' | ATTRS('Region', sEl, 'Manager Email'));
  TextOutput(sFileName, 'Subject:>' | sEl | ' Summary - ' | pYear | ' ' | pMonth);
  TextOutput(sFileName, 'Include:>' | sEl | '.txt');
  TextOutput(sFileName, 'Region:>' | sEl);
  TextOutput(sFileName, 'Year:>' | pYear);
  TextOutput(sFileName, 'Month:>' | pMonth);
  TextOutput(sFileName, '.');
  ExecuteProcess('Email.BurstData', 'pRegion', sEl, 'pYear', pYear, 'pMonth', pMonth);
  n = n + 1;
END;
573,3

#****Begin: Generated Statements***
#****End: Generated Statements****
574,3

#****Begin: Generated Statements***
#****End: Generated Statements****
575,6

#****Begin: Generated Statements***
#****End: Generated Statements****


ExecuteCommand('"C:\TM1\Tools\convey.exe" input="C:\TM1\Tools\PLReport.txt"', 1);
576,CubeAction=1511DataAction=1503CubeLogChanges=0
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
