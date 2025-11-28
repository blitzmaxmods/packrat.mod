SuperStrict

'	CSV-PARSER.BMX
'	(c) Copyright Si Dunford [Scaremonger], Dec 2024, All rights reserved.
'
'	This example uses the CSV Parser that was generated using 'CSV-PEG-Generator.bmx'
'	You need to run that example first to create it

'Import PEG.Parser
Import "../../../peg.parser/parser.bmx"
'Import Packrat.Parser
Import "../../../packrat.parser/parser.bmx"
'Import "../../packrat.functions/functions.bmx"

'Import "../parser.bmx"
'Import "../../packrat.functions/functions.bmx"

' IF THIS FAILS HERE:
Import "TCSVParser.bmx"
' YOU NEED TO RUN "CSV-PEG-generator.bmx" EXAMPLE FIRST TO CREATE THE FILE

'	EXAMPLE DATA

Local CSV_DATA:String = "1,2,3~n4,5,6~n7,8,9~n"

Print "########################################"
Print "# CSV PARSER"
Print

'	CREATE A PARSER INSTANCE

Local parser:TPackratParser = TPackrat-CSV-Parser()

'	PARSE DATA AND EXTRACT RESULT

Local tree:TParseTree = parser.parse( CSV_DATA )
Local result:TParseNode = tree.getRoot()

'	SHOW THE RESULT

showdata( result )

'	SIMPLE FUNCTION THAT DRAWS A TABLE

Function showdata( result:TParseNode )
	Print "Result:"
	
	Print "+---+---+---+-----+"
	Print "| A | B | C | SUM |"
	Print "+---+---+---+-----+"
	For Local row:TParseNode = EachIn result.byName( "LINE" )
		Local line:String, sum:Int = 0
		'Print line.tostring()
		For Local col:TParsenode = EachIn row.byName( "CELL" )
			line :+ "| " + col.value() + " "
			sum :+ Int(col.value())
		Next
		Print line + "| " + RSet(sum,3) + " |"
		Print "+---+---+---+-----+"
	Next
End Function
