'   bmx.peg-parser
'   (c) Copyright Si Dunford, NOV 2023, All Rights Reserved. 
'   VERSION: 1.0

'   CHANGES:
'   08 NOV 2023  1.00  Initial Creation

'	NOTE:
'	Requires "TPackrat_Parser_PEG.bmx" to be generated before compilation

SuperStrict

'Module peg.parser

'Import packrat.parser
Import "../parser.mod/parser.bmx"

'Import packrat.tools
Import "../tools.mod/tools.bmx"

Include "dev/TPackratParser_PEG_DEV.bmx"	' MANUALLY GENERATED
Include "bin/TPackratParser_PEG.bmx"		' PACKRAT GENERATED

Include "src/TParseTree2PEG.bmx"			' Tool to convert ParseTree into PEG
'Include "src/TParseTree2Grammar.bmx"		' Tool to convert ParseTree into TGrammar

'Const PEG_PRODUCTION:Int  = True
'Const PEG_DEVELOPMENT:Int = False
'Local parser:TPackratParser = PEG.Create( date_peg )
Type TPEG

	Const PRODUCTION:Int = True
	Const DEVELOPMENT:Int = True

	' Create a Parser for given PEG definition
	Function Create:TPackratParser( PEG:String )
		' Use PEG Parser to parse PEG into a ParseTree
		Local pegparser:TPackratParser = New TPackratParser_PEG()
		Local parsetree:TParseTree = pegparser.parse( PEG )

		' Extract grammar from a parsetree and create new parser
		Local grammar:TGrammar = parsetree.extractGrammar()
		Return New TPackratParser( grammar )

	End Function

	'	Obtain an instance of the PEG Packrat Parser
	Function GetParser:TPackratParser( production:Int = True )
		If production; Return New TPackratParser_PEG()
		Return New TPackratParser_PEG_DEV()
	End Function

	'	Parse PEG
	'Function ParsePEG:TParseTree( PEG:String )
	'	Local Parser:TPackratParser = GetParser()
	'	If Not parser; Return Null
	'	Return Parser.Parse( PEG )
	'EndFunction

End Type

' HELPER FUNCTION
' Parses a PEG definition into a grammar that we can use

Rem
Function PEGParser:TPattern( PEG:String, which:Int = PEG_PRODUCTION )
	Local Parser:TPackratParser = GetPEGParser( which )
	Local tree:TParseTree
	Try
		DebugStop
		tree = Parser.parse( PEG )
		DebugStop
		
		Print "-----PARSE CSV TREE TO GRAMMAR----------"
'		' 	COMPILE CSV PARSE TREE INTO GRAMMAR
'		Local Compile:TTreeToGrammar = New TTreeToGrammar()
'		Local csv_grammar:TGrammar
'		Try
'			csv_grammar = Compile.grammar( csv_tree )
'		Catch e:TParserException
'			Print "## EXCEPTION: "+e.message()
'			Print "## TRACEBACK: "+e.traceback()
'			End
'		EndTry

		'Return tree
	Catch e:TParserException
		Print "## EXCEPTION: "+e.message()
		Print "## TRACEBACK: "+e.traceback()
		Return Null
	EndTry
End Function
EndRem