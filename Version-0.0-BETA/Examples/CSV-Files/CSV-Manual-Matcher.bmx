SuperStrict

'	CSV-MANUAL-MATCHER.BMX
'	(c) Copyright Si Dunford [Scaremonger], Dec 2024, All rights reserved.
'	VERSION: 1.0, 24 DEC 24, RELEASE

'	This example shows you how to construct a pattern matcher and then use to extract 
'	data from a CSV file.
'
'	REMEMBER - MATCH START POSITION ARE ZERO-BASED
'
'	CSV DEFINITION USED IN THIS EXAMPLE
'	* A CSV FILE contains one or more lines.
'	* Each LINE is a record
'	* A LINE contains one or more CELL values seperated by commas

'Import PEG.Parser
Import "../../../peg.parser/parser.bmx"

'	EXAMPLE DATA

Local CSV_DATA:String = "1,2,3~n4,5,6~n7,8,9~n"

'	BUILD A NEW GRAMMAR

'	The PEG definition for what we are building is as follows:
'
'		FILE  <- LINE ( EOL LINE )*
'		LINE  <- CELL ( COMMA CELL )* 
'		CELL  <- (!COMMA !EOL . )* 
'		COMMA <- ","
'		CRLF  <- [\x13\x10]
'		EOF   <- WSP* !.
'		EOL   <- WSP* CRLF
'

Print "########################################"
Print "# PEG MATCHING"
Print

'	DEFINE THE PEG MATCHER
'	Note the order these are defined is in reverse because
'	FILE needs LINE and LINE needs CELL

'DebugStop
' Equivalent To the regex: [^,\n]*
Local CSVCell:TPattern = ..
	CAPTURE( "CELL", ..
		ONEORMORE( ..
			SEQUENCE([ ..
				NOTPRED( SYMBOL(",") ), ..
				NOTPRED( SYMBOL("~n" ) ), ..
				ANY() ..
			]) ..
		)..
	)
' Sort of like: CSVCell ("," CSVCell)*
Local CSVLine:TPattern = ..
	CAPTURE( "LINE",..
		SEQUENCE( [CSVCell, ONEORMORE( SEQUENCE([SYMBOL(","), CSVItem]))] )..
	)
' Sort of like: CSVLine ("\n" CSVLine)*
Local CSVFile:TPattern = ..
	CAPTURE( "FILE",..
		SEQUENCE( [CSVLine, ONEORMORE( SEQUENCE([SYMBOL("~n"), CSVLine]))] )..
	)

'	MATCH THE DATA

Local result:TParseNode = CSVFile.match( CSV_DATA )

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
