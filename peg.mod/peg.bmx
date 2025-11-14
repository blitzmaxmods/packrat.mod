'	PARSER.PEG
'	(c) Copyright Si Dunford, NOV 2025, All Rights Reserved. 
'   VERSION: 1.0
'
'	A Parser that uses the Packrat Parser to Parse PEG.
'
SuperStrict

'Module packrat.peg
Import "../parser.mod/parser.bmx"

Include "dev/TPackratParser_PEG_DEV.bmx"	' MANUALLY GENERATED
Include "bin/TPackratParser_PEG.bmx"		' PACKRAT GENERATED

Include "src/TParseTree2PEG.bmx"			' Tool to convert ParseTree into PEG
