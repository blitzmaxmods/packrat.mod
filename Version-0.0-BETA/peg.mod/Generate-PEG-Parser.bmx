
'	##### WARNING #####
'
'	This program overwrites the production packrat parser for PEG
'	After running this program you must recompile all modules that use the parser.
'
'	##### WARNING #####

'	HOW IT WORKS

'	This application uses the manually written (development) PEG parser grammar And generates
'	a "packrat parser for PEG" that is used by other modules.

SuperStrict

'	PACKRAT PARSER
'Import packrat.parser
Import "../parser.mod/parser.bmx"

'	PARSER GENERATOR
'Import packrat.generator
Import "../generator.mod/generator.bmx"

'	CREATE INSTANCE OF MANUAL (DEV) PACKRAT PEG PARSER

Import "dev/TPackratParser_PEG_DEV.bmx"
Local parser:TPackratParser = New TPackratParser_PEG_DEV()

'	GENERATE A PRODUCTION PACKRAT PEG PARSER

Local Generator:TParserGenerator = New TParserGenerator( parser.name(), parser.grammar )
Generator.write( "bin/TPackratParser_PEG.bmx" )

