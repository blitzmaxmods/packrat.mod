'	test_peg_parser.bmx
'	(c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
'	VERSION 1.0
'
'	Test PEG Parser against example syntax!
'
SuperStrict

Import unit.testing

'Import packrat.parser
Import "../parser.bmx"

Include "src/testlib.bmx"

' ############################################################

'	CREATE A PACKRAT PARSER AND A RETURN VALUE
Local parser:TPackratParser = New TPackratParser()
Local result:TParseTree

'	CREATE A GRAMMAR

Local grammar:TGrammar = New TGrammar( "EXAMPLE" )

'	CREATE A BASIC PATTERN

Local digit:TPattern = New TRange( "0-9" )
Print digit.PEG()

'	INSTALL PATTERNS IN GRAMMAR
DebugStop

grammar["DIGIT"] = digit
grammar["INTEGER"] = New TOneOrMore( digit )

Print grammar.toPEG() 

'	INSTALL GRAMMER IN PARSER

parser.setGrammar( grammar )

'	PARSE STRING AGAINST DIGIT

' ############################################################
Print "#### PARSE DIGIT"
result = parser.parse( "2024", "DIGIT" )
DebugStop

Print "--REVEAL--"
Print result.reveal()
'Print result.getTextTree()

Print "--GETTREE--"
Print result.getTree()

Print "~n--ERRORS--"
Print "HASROOT:  "+["False","True"][result.hasRoot()]
Print "HASERROR: "+["False","True"][result.hasErrors()]
Print "ERRORS:   "+result.errorcount()

'	PARSE STRING AGAINST INTEGER
'	Note: This will return a tree containing a set of digits

' ############################################################
Print "#### PARSE INTEGER"
DebugStop
result = parser.parse( "2024", "INTEGER" )
DebugStop

Print "--REVEAL--"
Print result.reveal()
'Print tree.getTextTree()

Print "--GETTREE--"
Print result.getTree()

Print "~n--ERRORS--"
Print "HASROOT:  "+["False","True"][result.hasRoot()]
Print "HASERROR: "+["False","True"][result.hasErrors()]
Print "ERRORS:   "+result.errorcount()

' GET THE VALUE....
DebugStop
'Local node:TParseNode = result.byname("INTEGER")
'Local value:Int 


'	PARSE TEXT AGAINST UNDEFINED RULE

' ############################################################
Print "#### PARSE UNDEFINED"
Try
	result = parser.parse( "2024", "UNDEFINED" )
	DebugStop

	Print "--REVEAL--"
	Print result.reveal()
	'Print tree.getTextTree()

	Print "--GETTREE--"
	Print result.getTree()

	Print "~n--ERRORS--"
	Print "HASROOT:  "+["False","True"][result.hasRoot()]
	Print "HASERROR: "+["False","True"][result.hasErrors()]
	Print "ERRORS:   "+result.errorcount()
Catch e:String
	Print "EXCEPTION: "+e
	If Not result; Print "result is NULL"
EndTry
Rem
DebugStop

' Load the (Manual) PEG Parser
'Local PEG:TPackratParser = PEG_Parser()
'Local PEG:TPackratParser = New TPackratParser_PEG_DEV()
Local PEG:TPackratParser = GetPEGParser( PEG_DEVELOPMENT )
Local Text:String

' ############################################################

unittest.test( "Line Comment", "#Test", PEG, "COMMENT" )

' RANGES
Local pattern:TPattern = RANGE("0-9")
Print pattern.ToString()
DebugStop
test( "Number using RANGE", Text, "0123456789" )

test( "Number", "23", PEG, "NUMBER" )

'testrange( "ALPHANUMERIC <- [a-zA-Z_]", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_" )
'testrange( "SYMBOL <- [+-/*]", ["+",",","-",".","/","*"] )	' This is a common issue
'testrange( "SYMBOL <- [-+/*]", ["+","-","/","*"] )
'testrange( "SYMBOL <- [+/*-]", ["+","-","/","*"] )
DebugStop
' Result
EndRem

' ############################################################
' TEST SEQUENCE INCLUDING AN ACTION

'	"LET" <X> "=" <20> {let}

Print "#### PARSE SEQUENCE WITH ACTION"

Local let:TPattern = New TLiteral( "LET" )
Local variable:TPattern = New TOneOrMore( New TRange("a-zA-Z_") )
Local equal:TPattern = New TSYmbol( "=" )
DebugStop
Local action:TPattern = New TActivity( "let", "example" )
Local integer:TPattern = grammar.__("INTEGER")
Local WSP:TPattern = grammar.__("WSP")

DebugStop
grammar["LET"] = New TSequence([let,WSP,variable,equal,integer,WSP,action])

DebugStop ' PROBLEM HERE IS THAT CALLBACK
		' RECEIVES "LET" Leaf, but not any arguments from the rule.
		' The action somhow needs to receive the rule as an argument!

Try
	Print "LET XYZ=20 {let}"
	debugstop
	result = parser.parse( "LET XYZ=20 {let}", "LET" )
	DebugStop

	Print "--REVEAL--"
	Print result.reveal()
	'Print tree.getTextTree()

	Print "--GETTREE--"
	Print result.getTree()

	Print "~n--ERRORS--"
	Print "HASROOT:  "+["False","True"][result.hasRoot()]
	Print "HASERROR: "+["False","True"][result.hasErrors()]
	Print "ERRORS:   "+result.errorcount()
Catch e:String
	Print "EXCEPTION: "+e
	If Not result; Print "result is NULL"
EndTry