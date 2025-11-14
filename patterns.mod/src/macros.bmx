' Macros for creating Packrat patterns

Const CASE_SENSITIVE:Int = False
Const CASE_INSENSITIVE:Int = True

' &e - AND predicate / AND lookahead
Function ANDPRED:TPattern( pattern:TPattern )
	Return New TAndPredicate( pattern )
End Function

' . - Matches any character
Function ANY:TPattern()
	Return New TAny()
End Function

' Utility function used to save a result into the parsenode
Function CAPTURE:TPattern( pattern:TPattern )
	Return New TCapture( pattern )
End Function

' [..] - Character set
Function CHARSET:TPattern( set:String )
	Return New TCharset( set )
End Function
Function CHARSET:TPattern( set:String[] )
	Return New TCharset( set )
End Function

' e1/e2 - Choice operand
Function CHOICE:TPattern( pattern:TPattern[] )
	Return New TChoice( pattern )
End Function

' (e) - Group expressions tpgether
Function GROUP:TPattern( pattern:TPattern )
	Return New TGroup( pattern )
End Function

' "text" - Case sensitive literal
Function LITERAL:TPattern( pattern:String )
	Return New TLiteral( pattern, CASE_SENSITIVE )
End Function

' ^l - Attach a label to a pattern
Function LABEL:TPattern( name:String, pattern:TPattern )
	pattern.label = name
	Return pattern
End Function

' 'text' - Case selectable literal (False = ignore case)
Function LITERAL:TPattern( pattern:String, ignorecase:Int=False )
	If Len(pattern) = 1 And Not ignorecase; Return New TSymbol( pattern )
	Return New TLiteral( pattern, ignorecase )
End Function

' NONTERMINAL - Runtime lookup of a rule in the grammar
'Function NONTERMINAL:TPattern( grammar:TGrammar, name:String )
Function __:TPattern( name:String )
	Return New TNonTerminal( name )
End Function
Function NONTERMINAL:TPattern( name:String )
'	Return New TNonTerminal( name, grammar )
	Return New TNonTerminal( name )
End Function

' !e - Negative lookahead
Function NOTPRED:TPattern( pattern:TPattern )
	Return New TNotPredicate( pattern )
End Function

' e+ - One or more
Function ONEORMORE:TPattern( pattern:TPattern )
	Return New TOneOrMore( pattern )
End Function

' e? - Optional pattern
Function OPTIONAL:TPattern( pattern:TPattern )
	Return New TOptional( pattern )
End Function

' [..] - Ranges of characters
Function RANGE:TPattern( range:String )
	Return New TRange( range )
End Function

' e1 e2 - Sequence of patterns
Function SEQUENCE:TPattern( pattern:TPattern[] )
	Return New TSequence( pattern )
End Function

' %NNN - A symbol defined by its ascii code or character
Function SYMBOL:TPattern( character:String )
	Return New TSymbol( character )
End Function
Function SYMBOL:TPattern( character:Int )
	Return New TSymbol( character )
End Function

' e* - Zero or more / Optional
Function ZEROORMORE:TPattern( pattern:TPattern )
	Return New TZeroOrMore( pattern )
End Function
