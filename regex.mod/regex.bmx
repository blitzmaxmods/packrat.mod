' REGEX Macro definitions for PEG

' TODO:
' * Fix negative ranges
' * /s does not include unicode spaces or Form Fed

' To use this, merge it into your existing grammer as follows:
Rem
	Local grammar:TGrammar = new TGrammar()
	...
	grammar.merge( getGrammarREGEX() )
	...
EndRem

'Import packrat.macros
Include "../macros.mod/macros.bmx"

DebugLog( "WARNING: packrat.regex is currently in pre-alpha" )

' @bmk echo
' @bmk echo *******************************
' @bmk echo ** WARNING
' @bmk echo ** packrat.regex is currently in pre-alpha
' @bmk echo *******************************
' @bmk echo

Function getGrammarREGEX:TGrammar()
	Local grammar:TGrammar = New TGrammar()
	
	grammar["\d"]    = RANGE( "0-9" )
	grammar["\D"]    = RANGE( "^0-9" )               ' 23 NOV 2025 - This does not work
	grammar["\w"]    = RANGE( "A-Za-z0-9_" )
	grammar["\W"]    = RANGE( "^A-Za-z0-9_" )        ' 23 NOV 2025 - This does not work
	grammar["\s"]    = CHARSET( "\x09\x0A\x0C\x0D\x20" ) '	HTAB, LF, FF, CR, SP
	grammar["\S"]    = CHARSET( "^\x09\x0A\x0C\x0D\x20" ) '	Not whitespace
	
	grammar["\0"]    = SYMBOL( $00 )             ' NULL / CHR(0)
	grammar["\t"]    = SYMBOL( $09 )             ' Horizontal Tab
	grammar["\r"]    = SYMBOL( $0A )             ' Carriage Return
	grammar["\v"]    = SYMBOL( $0B )             ' Vertical Tab
	grammar["\f"]    = SYMBOL( $0C )             ' Form Feed
	grammar["\n"]    = SYMBOL( $0D )             ' Line Feed

	Return grammar
End Function

' Register this grammar with packrat
'RegisterGrammar( "REGEX", getGrammarREGEX )
