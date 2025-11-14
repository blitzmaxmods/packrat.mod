SuperStrict
'	01.Macros.bmx
'	(c) Copyright Si Dunford, Dec 2024, All rights reserved
'
'	Version 1.0
'
'	The purpose of this example is to show you some macros and how they represent PEG expressions.

'Import packrat.patterns
Import "../patterns.mod/patterns.bmx"

Local pattern:TPattern

' AND PREDICATE: &e
TITLE "AND PREDICATE: &e"
	pattern = ANDPRED( SYMBOL("a") )
	Print pattern.toPEG( True )

' ANY: .
TITLE "ANY: ."
	pattern = ANY()
	Print pattern.toPEG( True )

' CHARSET: []
TITLE "CHARSET: []"
	pattern = CHARSET( "1234567890" )
	Print pattern.toPEG( True )
	pattern = CHARSET( ["1","2","3","4","5","6","7","8","9","0"] )
	Print pattern.toPEG( True )

' CHOICE: e1 / e2
TITLE "CHOICE: e1 / e2"
	pattern = CHOICE([ LITERAL("HELLO"), LITERAL("GOODBYE") ])
	Print pattern.toPEG( True )

' GROUP: (e)
TITLE "GROUP: (e)"
	pattern = GROUP( CHOICE([ LITERAL("HELLO"), LITERAL("GOODBYE") ]) )
	Print pattern.toPEG( True )

' LABEL: ^l
TITLE "LABEL: ^l"
	pattern = LABEL( "errorhandler", LITERAL("HELLO") )
	Print pattern.toPEG( True )

' LITERAL (Case Sensitive): ".."
TITLE "LITERAL (Case Sensitive): "+Chr(34)+".."+Chr(34)
	pattern = LITERAL( "HELLO WORLD" )
	Print pattern.toPEG( True )

' LITERAL (Case Insensitive): ".."i
TITLE "LITERAL (Case Insensitive): "+Chr(34)+".."+Chr(34)+"i"
	pattern = LITERAL( "HELLO WORLD", True )
	Print pattern.toPEG( True )

' NON-TERMINAL: rule
' (This requires a grammar)
TITLE "NON-TERMINAL: rule"
	Local grammar:TGrammar = New TGrammar( "EXAMPLE" )
	grammar["START"] = SEQUENCE([ LITERAL( "HELLO" ), NONTERMINAL( "SPACE" ), LITERAL( "WORLD" ) ])
	grammar["SPACE"] = SYMBOL( " " )
	Print grammar.toPEG( True )

' NOT PREDICATE: !e
TITLE "NOT PREDICATE: !e"
	pattern = NOTPRED( SYMBOL("<") )
	Print pattern.toPEG( True )

' ONE OR MORE: e+
TITLE "ONE OR MORE: e+"
	pattern = ONEORMORE( SYMBOL("a") )
	Print pattern.toPEG( True )

' OPTIONAL: e?
TITLE "OPTIONAL: e?"
	pattern = OPTIONAL( SYMBOL("a") )
	Print pattern.toPEG( True )

' RANGE: []
TITLE "RANGE: []"
	pattern = RANGE( "0-9A-Fa-f" )	' Hexadecimal
	Print pattern.toPEG( True )

' SEQUENCE: e1 e2
TITLE "SEQUENCE: e1 e2" 
	pattern = SEQUENCE([ ..
		LITERAL( "HELLO" ), LITERAL( " " ), LITERAL( "WORLD" ) ..
		])
	Print pattern.toPEG( True )

' SYMBOL: %nn
TITLE "SYMBOL: %nn"
	pattern = SYMBOL("<")
	Print pattern.toPEG( True )

' ZERO OR MORE: e*
TITLE "ZERO OR MORE: e*"
	pattern = ZEROORMORE( SYMBOL("a") )
	Print pattern.toPEG( True )

' Simple function to create a TITLE
Function TITLE( text:String )
	Print "~n"+text
	Print " "[..Len(text)].Replace(" ","=")
End Function