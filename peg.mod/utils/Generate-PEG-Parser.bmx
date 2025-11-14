'	GENERATE-PEG-PARSER
'	(c) Copyright Si Dunford, NOV 2025, All Rights Reserved. 
'   VERSION: 1.0
'
'	This application uses the manually written (development) PEG parser grammar and generates
'	a "packrat parser for PEG" that is used by other modules.

'	###########################################################
'	#####   WARNING  WARNING  WARNING  WARNING  WARNING   #####
'	#####                                                 #####
'	##### This program OVERWRITES the production packrat  #####
'   ##### parser For PEG.                                 #####
'	##### After running this program you must recompile   #####
'	##### all modules that use the parser.                #####
'	#####                                                 #####
'	###########################################################
'
SuperStrict
'	PACKRAT PARSER

'Import packrat.parser
'Import "../../parser.mod/parser.bmx"

'Import packrat.patterns
Import "../../patterns.mod/patterns.bmx"

'	PARSER GENERATOR

'Import packrat.generator
Import "../../generator.mod/generator.bmx"

'	CREATE INSTANCE OF MANUAL (DEV) PACKRAT PEG PARSER

Include "../dev/TPackratParser_PEG_DEV.bmx"

DebugStop
Local parser:TPackratParser = New TPackratParser_PEG_DEV()

'	GENERATE A PRODUCTION PACKRAT PEG PARSER

Local Generator:TParserGenerator = New TParserGenerator( parser.name(), parser.grammar )
CreateDir("../bin")
Generator.write( "../bin/TPackratParser_PEG.bmx" )

