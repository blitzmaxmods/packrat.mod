'	Issue #1 - Infinite Loop
'	(c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
'	VERSION 1.0
'
'	Test PEG Parser against known Infinite loops!
'
'	12 NOV 2023 - Example of issue
'	13 NOV 2023 - Mitigation applied

'TODO:	Need some better examples of infinate loops

' Import unit testing module
Import unit.testing

'Import packrat.parser
Import "../../packrat.parser/parser.bmx"

'Import peg.parser
Import "../../peg.parser/parser.bmx"

'Import packrat.tools
Import "../../packrat.tools/tools.bmx"

Include "src/testlib.bmx"

Local UnitTest:TTest = New TTest()
'	UnitTest.test( "TITLE", SOURCE, STARTRULE ) 

'Global TABSTOP:Int[] = [3,28,10,10]		' Column widths

' ############################################################

'DEBUGGER = False

DebugStop

Local grammar:TGrammar = Unittest.getGrammar()

'	START <- (!.)*

grammar["START"] = ZEROORMORE( NOTPRED( ANY() ) )
unittest.test( "Infinite Loop (!.)*",   "Example Document", grammar )

'	START <- ('a'?)*

grammar["START"] = ZEROORMORE( OPTIONAL( LITERAL("a") ) )
unittest.test( "Infinite Loop ('a'?)*", "Example Document", grammar )

'	START <- (&'a')*

grammar["START"] = ZEROORMORE( ANDPRED( LITERAL("a") ) )
unittest.test( "Infinite Loop (&'a')*", "abcdefghijklmnop", grammar )

'	START <- EXPR
'	EXPR <- EXPR / "."

NEED SOME BETTER EXAMPLES BECAUSE THIS IS Not REALLY A GOOD ONE

grammar.declare( "EXPR" )
grammar["START"] = grammar["EXPR"]
grammar["START"] = CHOICE([ ..
						grammar["EXPR"],..
						LITERAL(".")..
						])
unittest.test( "Infinite Loop (expr)", "charstring.", grammar )
