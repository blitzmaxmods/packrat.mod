SuperStrict

'	CSV-MANUAL-PARSER.BMX
'	(c) Copyright Si Dunford [Scaremonger], Dec 2024, All rights reserved.
'	VERSION: 1.0, 24 DEC 24, RELEASE

'	This example shows you how to construct a manual parser and use it To parse
'	data from a CSV file.

'	REMEMBER - MATCH START POSITION ARE ZERO-BASED

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
Print "# PEG PARSER"
Print

'	DEFINE A GRAMMAR

Local grammar:TGrammar = New TGrammar( "CSV" )

'	SET THE STARTING RULE
'	This can also be set when TGrammar is created (Default is START)

grammar.setStart( "FILE" )

'	REQUEST COMMON RULES ARE ADDED
grammar.addCommon()

' 	DECLARE RULES (Optional)
' 	This is done in advance so that you can reference them before they are fully defined.

grammar.declare([ "FILE","LINE","CELL","EOL","EOF","COMMA" ])

'	PATTERN REFERENCES
'	Some rules you will need to reference throught your definition, we save them here.

Local _EOL_:TPattern   = grammar.NonTerminal( "EOL" )
Local _LINE_:TPattern  = grammar.NonTerminal( "LINE" )
Local _COMMA_:TPattern = grammar.NonTerminal( "COMMA" )
Local _CELL_:TPattern  = grammar.NonTerminal( "CELL" )
Local _CRLF_:TPattern  = grammar.NonTerminal( "CRLF" )

' 	WSP is a default grammer for "Whitespace" provided by the parser
Local _WSP_:TPattern   = grammar.NonTerminal( "WSP" )

'	DEFINE RULES
'	You must define each rule using grammar notation

grammar["FILE"]  = CAPTURE("FILE",SEQUENCE([ _LINE_, ZEROORMORE( SEQUENCE([ _EOL_, _LINE_ ]) ) ]))
grammar["LINE"]  = CAPTURE("LINE",SEQUENCE([ _CELL_, ZEROORMORE( SEQUENCE([ _COMMA_, _CELL_ ]) ) ]))
grammar["CELL"]  = CAPTURE("CELL",ZEROORMORE( SEQUENCE([ NOTPRED(_COMMA_), NOTPRED(_EOL_), ANY() ]) ))
grammar["COMMA"] = LITERAL( "," )
grammar["CRLF"]  = CHARSET( "~r~n" )
grammar["EOF"]   = SEQUENCE([ ZEROORMORE(_WSP_), NOTPRED( ANY() ) ])
grammar["EOL"]   = SEQUENCE([ ZEROORMORE(_WSP_), _CRLF_ ])

'	DEBUG YOUR GRAMMAR AS PEG

Print grammar.toPeg()

'	CREATE A PARSER USING GRAMMAR

Local parser:TPackratParser = New TPackratParser( grammar )

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
