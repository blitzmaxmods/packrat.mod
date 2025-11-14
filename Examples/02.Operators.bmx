SuperStrict
'	02.Operators.bmx
'	(c) Copyright Si Dunford, Dec 2024, All rights reserved
'
'	Version 1.0
'
'	The purpose of this example is to test each operator

'Import packrat.patterns
Import "../patterns.mod/patterns.bmx"

Local pattern:TPattern

' AND PREDICATE: &e
' ANDPRED does not consume any input but returns expression if expression succeeds
' and fails if expression fails.
TITLE "AND PREDICATE: &e"
	pattern = ANDPRED( LITERAL("Hello") )

	Print "Match 'Hello' in 'Hello World':"
	RESULT( "Hello World", pattern )

	Print "Match 'Hello' in 'hello world':"
	RESULT( "hello world", pattern )

' ANY: .
' Returns any character; only fails at EOI
TITLE "ANY: ."
	pattern = ANY()
	
	Print "Match ANY in 'Hello World':"
	RESULT( "Hello World", pattern )
	
' CHARSET: []
' Used to check for a specific set of characters
TITLE "CHARSET: []"
	pattern = CHARSET( "1234567890" )	' DIGIT <- [1234567890]

	Print "Match a DIGIT in '0x7ab4500'"
	RESULT( "0x7ab4500", pattern )

	Print "Match a DIGIT in '$7ab4500'"
	RESULT( "$7ab4500", pattern )

' CHOICE: e1 / e2
' Used to find one of a set of expressions. fails if all expressions fail.
TITLE "CHOICE: e1 / e2"
	' Match strings, but notice the boolean to inform the parser not to match case.
	pattern = CHOICE([ LITERAL("HELLO", True), LITERAL("GOODBYE", True) ])
	
	' This will find the first option
	Print "Match a choice in 'Hello'"
	RESULT( "Hello", pattern )

	' This will find the second option
	Print "Match a choice in 'Goodbye'"
	RESULT( "Goodbye", pattern )

	' This will not be found and would cause the parsing to fail/fallback
	Print "Match a choice in 'Fairwell'"
	RESULT( "Fairwell", pattern )

' GROUP: (e)
' Use a group when you need to clarify an expression in the same way as you would
' a mathematical term to get the order of preference correct.
' For example, when using Choice you may need to group them if you want One or more
' Options <- "A" | "B" | "C" *       # This gives One or More "C"
' Options <- ( "A" | "B" | "C" )*    # This gives one or more of either A, B or C
TITLE "GROUP: (e)"
	pattern = ONEORMORE( GROUP( CHOICE([ LITERAL("A"), LITERAL("B"), LITERAL("C") ]) ))
	Print pattern.toPEG( True )

	' Matches 
	Print "Match a group"
	RESULT( "ABAABBBA", pattern )

	' Matches 
	Print "Match prefix only"
	RESULT( "ABAA9999", pattern )

' LABEL: ^l
' No example is shown because this is intended to be used in a grammar and will 
' be explained in a later example.

TITLE "LITERAL: ~q..~q Or '..'"

	pattern = LITERAL( "Hello World" )
	Print "Case sensitive ( "+pattern.toPEG( True )+" )"
	RESULT( "Hello World", pattern )

	pattern = LITERAL( "hello world", True )
	Print "Case Insensitive ( "+pattern.toPEG( True )+" )"
	RESULT( "Hello World", pattern )

' NON-TERMINAL: rule
' No example is shown because this is intended to be used in a grammar and will 
' be explained in a later example.

' NOT PREDICATE: !e
' This returns success if the expression does not match and fail if the expression matches
' NOTPRED does not consume any data
TITLE "NOT PREDICATE: !e"
	pattern = NOTPRED( SYMBOL("<") )
	Print pattern.toPEG( True )

	Print "Match '<' with !~q<~q"
	RESULT( "<", pattern )

	Print "Match '>' with !~q<~q"
	RESULT( ">", pattern )

' ONE OR MORE: e+
TITLE "ONE OR MORE: e+"
	pattern = ONEORMORE( LITERAL("a") )

	Print "Match one symbol"
	RESULT( "abcdef", pattern )

	Print "Match multiple symbols"
	RESULT( "aaaabbbbccccddddeeeeffff", pattern )

' OPTIONAL: e?
TITLE "OPTIONAL: e?"
	pattern = OPTIONAL( SYMBOL("a") )

	Print "Match existing optional character"
	RESULT( "abcdef", pattern )

	Print "Match missing optional character"
	RESULT( "bcdef", pattern )

' RANGE: []
' A range is used to contruct a charset and is otherwise identical
TITLE "RANGE: []"
	pattern = ONEORMORE( RANGE( "0-9A-Fa-f" ) )	' Hexadecimal <- [0-9A-Fa-f]
	Print pattern.toPEG( True )

	Print "Match a hexadecimal number"
	RESULT( "7ab4500", pattern )

' SEQUENCE: e1 e2
TITLE "SEQUENCE: e1 e2" 
	pattern = SEQUENCE([ ..
		LITERAL( "HELLO" ), LITERAL( " " ), LITERAL( "WORLD" ) ..
		])

	Print "Match a sequence"
	RESULT( "HELLO WORLD", pattern )

	Print "Failed sequence match"
	RESULT( "HELLO UNIVERSE", pattern )

' SYMBOL: %nn
TITLE "SYMBOL: %nn"
	pattern = SYMBOL("<")

	Print "Match a symbol"
	RESULT( "<", pattern )

	Print "Do no match a symbol"
	RESULT( ">", pattern )

' ZERO OR MORE: e*
TITLE "ZERO OR MORE: e*"
	pattern = ZEROORMORE( SYMBOL("a") )

	Print "Match zero symbols"
	RESULT( "bcdef", pattern )

	Print "Match zero or more symbols"
	RESULT( "aaaabbbbccccddddeeeeffff", pattern )


' Simple function to create a TITLE
Function TITLE( text:String )
	Print "~n"+text
	Print " "[..Len(text)].Replace(" ","=")
End Function

' Simple function to produce a results
Function RESULT( text:String, pattern:TPattern )
'	pattern.setVerbose()	' Enable verbose so we have debug information
	Local match:TMatchResult = pattern.match( text )
	If Not match.found()
		Print "- NOT FOUND"
		Return
	EndIf

	' Get the matched text
	Local start:Int, finish:Int
	match.getPosition( start, finish )
	' Some operators do not consume data (ANDPRED, NOTPRED etc) so we check here
	If start = finish
		Print "- FOUND"
	Else
		Print "- FOUND '"+text[start..finish]+"'"
	EndIf
End Function

