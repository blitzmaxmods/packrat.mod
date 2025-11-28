SuperStrict
'	05.PEG-Grammar.bmx
'	(c) Copyright Si Dunford, Dec 2024, All rights reserved
'
'	Version 1.0
'
'	The purpose of this example is to show you how to parse a PEG definition
'	then use it to match a String

'Import packrat.patterns
'Import "../patterns.mod/patterns.bmx"
'import packrat.parser
'Import "../parser.mod/parser.bmx"
'import packrat.peg
Import "../peg.mod/peg.bmx"

' Import function to display a multidimensional string array as a table
Import "library/showtable.bmx"

' Check that example 04 has been run to generate a PEG file.

If Not FileType( "peg/csv.peg" ) = FILETYPE_FILE
	Notify( "You must run example 04 to generate 'csv.peg' before running this example", True )
	End
End If

'	Load the PEG definition
Local csvpeg:String = LoadString( "peg/csv.peg" )
DebugStop

'	Create a Parser from a PEG definition

Local parser:TPackratParser = CreateParserFromPEG( csvpeg, True, True )	' Use DEV PARSER
parser.setVerbose( True )	' Get debugging information

'	Show the grammar definition.
'	This should be the same as the PEG we loaded

Print parser.grammar.toPEG()

'	Parse a CSV using our newly build parser

Local CSV:String = "1,2,3~n4,5,6~n7,8,9~n"
DebugStop
parser.setVerbose( True )
Local tree:TParseTree = parser.parse( CSV, "FILE" )	' "FILE" is the starting rule

DebugStop 'THIS DOES Not PARSE CORRECTLY - WE NEED To GET ERRORS

' Show the Memoisation cache
DebugStop
Local memo:TMemoisation = parser.getMemotable()
If memo
	Print( "~nMEMOTABLE")
	showtable( memo.query() )
EndIf

' Show the Parsetree
Print( "~nPARSETREE")
showtable( tree.query() )

If tree.valid()
	' Use the debugging tool to show us the resulting tree
	Print "RESULTING TREE:"
	Print tree.reveal()
Else
	Print "Failed to parse CSV"
	End
EndIf

' Identify if we have any errors

If tree.hasErrors()
	Print ":(  ERRORS BY NAME"
	For Local error:TParseNode = EachIn tree.errors()
		Print "## "+error.getMeta( "errmsg" )
	Next
	End
Else
	Print ":) - No errors"
EndIf

'	Display the parse results in a table

Print "~nEXTRACT TABLE USING CAPTURES~n"

Print "+-----+-----+-----+-----+"
Print "|  A  |  B  |  C  | SUM |"
Print "+-----+-----+-----+-----+"

' Loop through each row
For Local row:TParseNode = EachIn tree.byName( "LINE" )
	Local line:String, sum:Int = 0

	' Loop through each cell (column) in the row
	For Local cell:TParsenode = EachIn row.byName( "CELL" )
	
		' Extract data from source text
		Local value:String = cell.captured
		
		' Put result in a table
		line :+ "| " + RSet(value,3) + " "

		' Sum the row
		sum :+ Int(value)
	Next
	' Draw the line plus the sum
	Print line + "| " + RSet(sum,3) + " |"
	Print "+-----+-----+-----+-----+"
Next
