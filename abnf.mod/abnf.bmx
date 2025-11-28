' ABNF Macro definitions for PEG
' Based on RFC 5234

' To use this, merge it into your existing grammer as follows:
Rem
	Local grammar:TGrammar = new TGrammar()
	...
	grammar.merge( getGrammarABNF() )
	...
EndRem

'Import packrat.macros
Include "../macros.mod/macros.bmx"

' CORE ABNF RULES
' Note the use of LWSP is contraversial and has not been implemented at release

Function getGrammarABNF:TGrammar()
	Local grammar:TGrammar = New TGrammar()

	grammar["BIT"]      = CHARSET(["0","1"])     ' Binary digit 
	grammar["WSP"]      = CHARSET([$20,$09])     ' Space And horizontal tab
	
	grammar["ALPHA"]    = RANGE( "A-Za-z" )      ' Upper- And Lower-Case ASCII letters (A–Z, a–z)
	grammar["CHAR"]     = RANGE( $01, $7F )      ' Any ASCII character, excluding NUL
	grammar["CTL"]      = RANGE( "\x00–\x1F\x7F" ' Controls
	grammar["DIGIT"]    = RANGE( "0-9" )         ' Decimal digits (0–9)
	grammar["HEXDIGIT"] = RANGE( "A-Fa-f0-9" )   ' Hexadecimal digits (0–9, A–F, a–f)
	'grammar["LWSP"]    ' Contraverial and not defined here
	grammar["OCTET"]    = RANGE( $00, $FF )      ' 8 bits of data
	grammar["VCHAR"]    = RANGE( $21, $7E )      ' Visible (printing) characters

	grammar["HTAB"]     = SYMBOL( $09 )          ' Horizontal tab
	grammar["LF"]       = SYMBOL( $0A )          ' Linefeed
	grammar["CR"]       = SYMBOL( $0D )          ' Carriage Return
	grammar["SP"]       = SYMBOL( $20 )          ' Space
	grammar["DQUOTE"]   = SYMBOL( $22 )          ' Double quote
	grammar["CRLF"]     = SYMBOL([ $0D, $0A ])   ' Internet-standard newline (Windows, not Linux)
	
	Return grammar
End Function

' Register this grammar with packrat
'RegisterGrammar( "ABNF", getGrammarABNF )
