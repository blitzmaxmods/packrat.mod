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
'	IMPORT PACKRAT MACRO PATTERNS

'Import packrat.patterns
Import "../../patterns.mod/patterns.bmx"

'	IMPORT THE PARSER GENERATOR

'Import packrat.generator
Import "../../generator.mod/generator.bmx"

'	CREATE INSTANCE OF MANUAL (DEV) PACKRAT PEG PARSER
'	(We cannot use getParser() here because module imports the one we are creating)

Include "../dev/TPackratParser_PEG_DEV.bmx"
Local parser:TPackratParser = New TPackratParser_PEG_DEV()

'	GENERATE A PRODUCTION PACKRAT PEG PARSER

Local Generator:TParserGenerator = New TParserGenerator( parser.name(), parser.grammar )
CreateDir("../bin")
Generator.write( "../bin/TPackratParser_PEG.bmx" )

