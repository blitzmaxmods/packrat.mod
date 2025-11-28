SuperStrict
'	04.Parsing-Grammar.bmx
'	(c) Copyright Si Dunford, Dec 2024, All rights reserved
'
'	Version 1.0
'
'	The purpose of this example is to show you how to construct a grammar that is then used to match a string

'Import packrat.macros
Import "../macros.mod/macros.bmx"
'import packrat.parser
Import "../parser.mod/parser.bmx"

' First we must create the grammar object.
' We specify the name for the grammar and the starting rule (Which defaults to START)

DebugStop
Local grammar:TGrammar = New TGrammar( "CSV", "FILE" )

' Now we add a series of rules to the grammar

' These symbols can be reused throughout our grammar using the NONTERMINAL() function or __()
grammar[ "COMMA" ] = SYMBOL(",")
grammar[ "CR" ] = SYMBOL( "~n" )

' A CSV value is defined as a sequence of characters excluding a comma and a CR

grammar[ "CELL" ] = CAPTURE( ..
	ONEORMORE( ..
		SEQUENCE([ ..
			NOTPRED( NONTERMINAL( "COMMA" ) ), ..
			NOTPRED( NONTERMINAL( "CR" ) ), ..
			ANY() ..
			]) ..
		) ..
	)

' A CSV line is defined as one or more values seperated by commas ending in CR

grammar[ "LINE" ] = SEQUENCE([ ..
	NONTERMINAL("CELL"), ..
	ONEORMORE( ..
		SEQUENCE([ NONTERMINAL("COMMA"), NONTERMINAL("CELL") ]) ..
		) ..
	])

' A CSV file is defined as one or more lines

grammar[ "FILE" ] = SEQUENCE([ ..
	NONTERMINAL("LINE"), ..
	ONEORMORE( ..
		SEQUENCE([ NONTERMINAL("CR"), NONTERMINAL("LINE") ]) ..
		) ..
	])

' Show the grammar as PEG
' We will also save it for use in other examples...

Local PEG:String = grammar.toPEG()
CreateDir( "peg/" )
SaveString( PEG, "peg/csv.peg" )
Print PEG

DebugStop
' Create an instance of the Packrat parser using our grammar

Local parser:TPackratParser = New TPackratParser( grammar )

' Parse the CSV using our grammar into a Parsetree

Local CSV:String = "1,2,3~n4,5,6~n7,8,9~n"
'parser.setVerbose( True )
Local tree:TParseTree = parser.parse( CSV )

DebugStop
If tree.valid()
	' Use the debugging tool to show us the resulting tree
	Print "RESULTING TREE:"
	Print tree.reveal()
Else
	Print "Failed to parse CSV"
	End
EndIf

' Extract each line and cell and display them on a table

Print "~nEXTRACT TABLE USING POSITION DATA~n"

Print "+-----+-----+-----+-----+"
Print "|  A  |  B  |  C  | SUM |"
Print "+-----+-----+-----+-----+"

' Loop through each row
For Local row:TParseNode = EachIn tree.byName( "LINE" )
	Local line:String, sum:Int = 0

	' Loop through each column
	For Local col:TParsenode = EachIn row.byName( "CELL" )

		' Extract the start and finish position of the dta
		Local start:Int, finish:Int
		col.getPosition( start, finish )
		
		' Extract data from source text
		Local value:String = CSV[start..finish]
		
		' Put result in a table
		line :+ "| " + RSet(value,3) + " "

		' Sum the row
		sum :+ Int(value)
	Next
	' Draw the line plus the sum
	Print line + "| " + RSet(sum,3) + " |"
	Print "+-----+-----+-----+-----+"
Next

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






