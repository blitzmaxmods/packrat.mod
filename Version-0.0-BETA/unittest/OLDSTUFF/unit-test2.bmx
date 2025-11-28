SuperStrict

'	UNIT TEST FOR PEG PARSER
'	(c) Copyright Si Dunford, Dec 2024, All Rights Reserved

Import unit.testing
'Import peg.parser
Import "../parser.bmx"
'Import "../../peg.parser/bin/TPackratParser_PEG_DEV.bmx"

' Create a Unit testing class
Type TTest Extends TUnitTest

	Field parser:TPackratParser
	
	Method New()
		parser = GetPEGParser( PEG_DEVELOPMENT )
		DebugStop
		Local grammar:TGrammar = parser.getGrammar()
		Print grammar.toPeg()
		
	End Method

	Method test:Int( title:String, source:String, startrule:String="" )
		Local tree:TParseTree
		Try
			DebugStop
Print source
' THIS IS RETURNING NULL - I DON'T KNOW WHY!
			tree = Parser.parse( source, startrule )
			DebugStop
			
			Print "-----PARSE CSV TREE TO GRAMMAR----------"
			
			Print tree.errorcount()+ " errors"
			Print tree.reveal()
			
			'If tree.hasErrors()
				
			'End If
			
			Print tree.getTree()
			
			'Print tree.getTextTree()
			
	Rem
			' 	COMPILE CSV PARSE TREE INTO GRAMMAR
			Local Compile:TTreeToGrammar = New TTreeToGrammar()
			Local csv_grammar:TGrammar
			Try
				csv_grammar = Compile.grammar( csv_tree )
			Catch e:TParserException
				Print "## EXCEPTION: "+e.message()
				Print "## TRACEBACK: "+e.traceback()
				End
			EndTry
	EndRem
			'Return tree
		Catch e:TParserException
			Print "## EXCEPTION: "+e.message()
			Print "## TRACEBACK: "+e.traceback()
			Return Null
		EndTry
	End Method
	
End Type

'	PREPARE THE TEST TABLE

Local UnitTest:TTest = New TTest()	
unittest.heading( "PATTERNS" )
unittest.write( ["ID","STATE","NAME","RESULT"] )
unittest.break()

'	CREATE A PARSER

Local parser:TPackratParser = New TPackratParser()

'	CREATE A TEST GRAMMAR

Local grammar:TGrammar = New TGrammar( "TEST" )
grammar["NUMBER"] = CAPTURE("NUMBER",ONEORMORE(RANGE("0-9")))
'grammar["COMMENT"] = SEQUENCE([ _, SYMBOL("#"), READUNTIL(EOL) ])

'	SET GRAMMER
parser.setGrammar( grammar )

'	PARSE STATEMENT
Local tree:TParseTree = Parser.parse( "0123456789", "NUMBER" )
If tree
	Print tree.getTree()
Else
	Print "- FAILED TO CREATE PARSE TREE"
EndIf

DebugStop

'WHAT WE NEED IS BYNAME SHOULD Return A CAPTURE NAME, Not THE RULE NAME!

For Local result:TParseNode = EachIn tree.byName( "NUMBER" )
	DebugStop
	Print result.captured
Next
DebugStop

'	GET INSTANCE OF DEVELOPMENT PEG PARSER

Local source:String = ""
DebugStop
UnitTest.test( "Comment", "# This is a test", "COMMENT" )
	
' Parse a comment
'Local pattern:TPattern = RANGE("0-9")
'Print pattern.ToString()
'DebugStop
'test( "Number using RANGE", Text, "0123456789" )

'test( "Number", "23", PEG, "NUMBER" )


'	PACKRAT PARSER
'Import packrat.parser
'Import "../../packrat.parser/parser.bmx"

'	PARSER GENERATOR
'Import bmx.packrat-gen
'Import "../../packrat.generator/generator.bmx"
'Import "../../packrat.tools/tools.bmx"
'	PRODUCTION PEG PARSER
'Include "../src/TPackratParser_PEG.bmx"

'	CREATE INSTANCE OF PACKRAT PEG PARSER

'Local parser:TPackratParser = New TPackratParser_PEG()

'TODO:
