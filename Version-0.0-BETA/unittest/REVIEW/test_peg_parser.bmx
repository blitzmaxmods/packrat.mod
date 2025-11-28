'	test_peg_parser.bmx
'	(c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
'	VERSION 1.0
'
'	Test PEG Parser against example syntax!
'

'Import packrat.parser
Import "../parser.bmx"

'Import peg.parser
'Import "../../peg.parser/parser.bmx"
'Import "../../peg.parser/bin/TPackratParser_PEG_DEV.bmx"

'import unit.testing
Import "../../unit.testing/testing.bmx"

Include "bin/testlib.bmx"

'	PREPARE THE TEST TABLE

UnitTest.setTab( [3,5,32,30] )	
unittest.heading( "RULES" )
unittest.write( ["ID","STATE","NAME","RESULT"] )
unittest.break()

' Load the (Manual) PEG Parser
'Local PEG:TPackratParser = PEG_Parser()
Local PEG:TPackratParser = New TPackratParser_PEG_DEV()
Local Text:String

' ############################################################

DebugStop
'     PARSER	NAME              	INPUT		RULE
test( PEG,		"Line Comment",		"#Test", 	"COMMENT" )
test( PEG,		"Number",			"23", 		"NUMBER" )

DebugStop
'THIS IS Not WORKING AS EXPECTED!!
test( PEG,		"String",			"ABC", 		"NUMBER" )
test( PEG,		"String",			"ABC", 		"STRING" )

Test( PEG, "ALPHA",	"This is a string", "ALPHA" )              ' Case insensitive A-Z
'Test( PEG, "CHAR",	"RANGE( Chr($34)+"-"+Chr($7F) ), "CHAR" )  ' 7 BIt ASCII except CTRL
'Test( PEG, "CR",	SYMBOL( $0D ), "CR" )                     ' %d13 = Carriage Return \r
'Test( PEG, "CRLF",	CHARSET( Chr($0D)+Chr($0A) ), "CRLF" )    ' Newline \r\n
'Test( PEG, "DIGIT",	RANGE( "0-9" ), "DIGIT" )                 ' Digit 0 to 9
'Test( PEG, "DQUOTE", CHARSET(Chr(34)), "DQUOTE" )		      ' Double Quote 
		
'testrange( "ALPHANUMERIC <- [a-zA-Z_]", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_" )
'testrange( "SYMBOL <- [+-/*]", ["+",",","-",".","/","*"] )	' This is a common issue
'testrange( "SYMBOL <- [-+/*]", ["+","-","/","*"] )
'testrange( "SYMBOL <- [+/*-]", ["+","-","/","*"] )

' Result

