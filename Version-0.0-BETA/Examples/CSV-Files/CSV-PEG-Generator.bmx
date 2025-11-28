SuperStrict

'	CSV-PEG-GENERATOR.BMX
'	(c) Copyright Si Dunford [Scaremonger], Dec 2024, All rights reserved.
'
'	This example uses the PEG generator to create a parser library for CSV files.
'	You should probably look at the other examples first!

'Import PEG.Parser
Import "../../../peg.parser/parser.bmx"
'Import Packrat.Parser
'Import "../../../packrat.parser/parser.bmx"
'Import "../../packrat.functions/functions.bmx"

'Import "../parser.bmx"
'Import "../../packrat.functions/functions.bmx"

'	PACKRAT PARSER
'Import packrat.parser
Import "../../../packrat.parser/parser.bmx"

'	PARSER GENERATOR
'Import packrat.generator
Import "../../../packrat.generator/generator.bmx"

Print
Print "########################################"
Print "# CSV PARSER GENERATOR"
Print

'	Load the PEG definition from a file

Local csv_peg:String = LoadString( "data/csv.peg" )
Local csv_doc:TTextDocument = New TTextDocument( csv_peg )

'	CREATE INSTANCE OF THE PEG PARSER

Local Parser:TPackratParser = GetPEGParser()	' PEG_DEVELOPMENT )

Local csv_tree:TParseTree
'Try
	DebugStop
	csv_tree = Parser.parse( csv_doc )
'Catch e:TParserException
'	Print "## EXCEPTION: "+e.message()
'	Print "## TRACEBACK: "+e.traceback()
'	End
'EndTry

If Not csv_tree
	Print "## csv_tree IS NULL"
	End
End If

' Check parse
'NEED To FIGURE OUT BEST WAY To GET PARSE ERRORS
DebugStop

Print "-----ASSTRING---------------------------"
'Print csv_tree.root.AsString()

Print "-----TREE-------------------------------"
'Print csv_tree.root.getTree()

'Print "-----TEXTTREE---------------------------"
'Print csv_tree.root.getTextTree()

Print "-----REVEAL-----------------------------"
DebugStop
Print csv_tree.reveal()

Print "-----PARSE ERRORS-----------------------"

' Manually extract errors
'Print "---> ERRORS BY NAME"
'For Local error:TParseNode = EachIn csv_tree.byName( "ERROR" )
'	Print "## "+error.value()
'Next

'Print "---> ERRORS BY NAME"
'For Local error:TParseNode = EachIn csv_tree.byKind( KIND_ERROR )
'	Print "## "+error.value()
'Next

Print "---> ERROR METHODS"
If csv_tree.hasErrors(); Print "## CSV HAS ERRORS"
Print "CSV ERRORS: "+ csv_tree.errorCount()
Local csv_errors:TParseError[] = csv_tree.getErrors()
Print "CSV ERRORCOUNT : "+ csv_errors.Length
For Local error:TParseError = EachIn csv_errors
	Local position:TPosition = csv_doc.getPosition( error )

	Print "## "+position.format()+", "+error.message
Next

' ERRORS SHOULD BE IMPROVED, ESPECIALLY AS I NEED THESE FOR THE
' LANGUAGE SERVER
End
DebugStop

Print "########################################"
Print "# GRAMMAR GENERATOR"

'	Generate a CSV parser using the result
DebugStop

'Print "-----PARSE CSV TREE TO GRAMMAR----------"
' 	COMPILE CSV PARSE TREE INTO GRAMMAR
'
'
'Local Compile:TParseTree2Grammar = New TParseTree2Grammar()
'Local csv_grammar:TGrammar
'Try
'	csv_grammar = Compile.grammar( csv_tree )
'Catch e:TParserException
'	Print "## EXCEPTION: "+e.message()
'	Print "## TRACEBACK: "+e.traceback()
'	End
'EndTry

'If Not csv_grammar
'	Print "## grammar IS NULL"
'	End
'End If

'Print csv_grammar.toPEG()

'	GENERATE A CSV PARSER

Local Generator:TParserGenerator = New TParserGenerator( parser.name(), parser.grammar )
Generator.write( "TCSVParser.bmx" )

Print "COMPILATION SUCCESSFUL"
Print "-> TCSVParser.bmx"

Print "~nYou can test library using 'CSV-Parser.bmx'"

''''

