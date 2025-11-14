
'PATTERN TYPES
Const PATTERN_NONE:Int = 0

Type TPattern

	Const KINDGROWTH:Int      = 25             ' Speed that KINDNAME array will grow
	Global KINDNAMES:String[] = New String[KINDGROWTH]
	Global IDCOUNTER:Int      = 0              ' ID Counter

	' Helper function used in debugging to turn "KIND" into a named string
	Function Lookup:String( kind:Int )
		If kind > Len(KINDNAMES); Return ""
		Return KINDNAMES[ kind ]
	End Function

	Field ID:Int = PATTERN_NONE  ' Unique pattern ID (Used in memoisation)
	Field hidden:Int = False       ' Core rules can be hidden from output
	Field label:String = Null      ' Label use in error recovery
	
	'Field typestr:String
	Field verbose:Int  = False

'	Method New()
'		ID = allocate()
'	End Method

	' Allocate a KIND ID for a given pattern. Used by Memoisation to lookup cache
	Method allocate( typestr:String )
		IDCOUNTER:+1
		If IDCOUNTER>=Len(KINDNAMES); KINDNAMES=KINDNAMES[..(IDCOUNTER+KINDGROWTH)]
		'Self.typestr = typestr
		KINDNAMES[IDCOUNTER]=typestr
		ID = IDCOUNTER
	End Method
	
'	Method allocate:Int()
'		IDCOUNTER:+1
'		Return IDCOUNTER
'	End Method
	
	Method typeof:String()
		Local tid:TTypeId = TTypeId.forObject( Self )
		If tid; Return tid.name()
		Return "P"+Hex(ID)
	End Method

	' Match using this pattern
	Method GetMatch:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )

		If context.verbose; Print( "? "+typeof()+" is NOT using the cache" )
		
		' Perform a match
		Local match:TMatchResult = Matcher( context, parent, start, depth )	
		Assert match<>Null, Typeof()+".Matcher() failed with null result"

		' Return successful match
		If match.node
			If context.verbose; Print( "? Matched '"+typeof()+"' at "+start )
			Return match
		EndIf

		' When there is no match, Label informs us what to do.
		
		' Normal failure (label is NULL) means we simply backtrack
		If Not match.label
			If context.verbose; Print( "? "+typeof()+"; No match at "+start+": backtracking..." )		
			Return match
		EndIf
		
		' Error recovery
		Local recovery:TPattern = context.grammar[match.label]
		Raiseif( Not recovery, "label '"+match.label+"' is not defined in grammar" )
		
		If context.verbose; Print( "? No match at "+start+"; preforming error recovery..." )
		Local error:TMatchResult = recovery.Matcher( context, parent, start, depth )
		Return error		
	EndMethod
	
	' Hide a core rule from being displayed in grammar
	Method hide()
		hidden = True
	End Method
	
	Method setVerbose:TPattern( state:Int = True )
		Self.verbose = state
		Return Self
	End Method
	
	' Extract PEG definition of this pattern
	Method toPEG:String() Abstract
	Method toPEG:String( rule:Int ) Final
		' This version is used in the examples to provide a dummy rule name for a given pattern
		If rule
			Return "RULE <- "+toPEG()
		Else
			Return "START <- "+toPEG()
		EndIf
	End Method
	' Method to apply label to PEG string; only used by toPEG()
	Private Method applyPEGLabel:String( text:String )
		If label; Return text+"^"+label
		Return text
	End Method
	
	' Parser Generator for this pattern
	Public Method generate:String( tab:String ) Abstract

	' Match a simple pattern
	Method match:TMatchResult( text:String )
		' Create a document from the text
		Local doc:TTextDocument = New TTextDocument( text )
		' Create a parser context
		Local context:TParseContext = New TParseContext( doc, Self )
		If Self.verbose; context.setVerbose( Self.verbose )
		' Perform the match
		Local node:TMatchResult = doc.match( context )
		Assert node<>Null, "Value of TMatchResult should never be NULL"
		
		'If Not node; Return New TMatchResult( PARSE_ERROR_NOMATCH, Null, node )
		'Return New SMatchResult( PARSE_ERROR_NONE, Null, Self )
		'Return New SMatchResult( node, Text )
		Return node
	EndMethod

	Private
	
	' Expression specific matcher
	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 ) Abstract
	
	Protected

	'Method ERROR:TMatchResult( pattern:TPattern, start:Int, finish:Int, children:TParseNode[]=[] )
	'End Method

	'Method FAILURE:TMatchResult( pattern:TPattern, start:Int, finish:Int, children:TParseNode[]=[] )
	'End Method
	
	Method FAIL:TMatchResult( errpos:Int )
		Return New TMatchResult( errpos, label, Null )
	EndMethod

	'Method ERROR:TMatchResult( errpos:Int, label:String )
	'	Return New TMatchResult( errpos, label, Null )
	'EndMethod
	
	Method SUCCESS:TMatchResult( pattern:TPattern, start:Int, finish:Int, children:TParseNode[]=[] )
		Local node:TParseNode = New TParseNode( pattern, "", start, finish, children )
		Return New TMatchResult( start, Self.label, node )
	End Method

	' Escape a string
	Method escape:String( Text:String, printables:Int = False )
		Local escaped:String	
		Local n:Int
		While n<Text.Length
			Local ch:Int = Asc(Text[n..n+1])
			If ch=9 
				escaped :+ "\t"
			ElseIf ch=10
				escaped :+ "\n"
			ElseIf ch=13
				escaped :+ "\r"
			ElseIf ch<32 Or ch=92 Or ( ch>125 And ch<256 )
				escaped :+ "\x"+Hex(ch)[6..]
			ElseIf ch>=32 And ch<=126 And printables
				escaped :+ "\x"+Hex(ch)[6..]
			ElseIf ch>256	'UNICODE
	'TODO: Add full support for unicode
				DebugStop
				' THIS IS NOT TESTED - Should produce \uNNNN
				escaped :+ "\u"+Hex(ch)[4..]
				DebugStop		
			ElseIf ch=34
				escaped :+ "\q"
			Else
				escaped :+ Chr(ch)
			End If
			n:+1
		Wend
		Return escaped	
	End Method

	' Un-escape a string
	Method descape:String( Text:String )
	'TODO: Optimise and support unprintables

		DebugLog "DESCAPE() IS UNTESTED"
		DebugStop

		Local descaped:String
		Local n:Int
		While n<Text.Length
			Select Text[n]
			Case "\"	' ESCAPED
	DebugStop
				n:+1
				Select Text[n..n+1]
				Case "\";	descaped :+ "\"
				Case "n";	descaped :+ "~n"
				Case "r";	descaped :+ "~r"
				Case "t";	descaped :+ "~t"
				Case "q";	descaped :+ "~q"
				Case Chr(34);	descaped :+ "~q"
				Case "x"
					descaped :+ Chr( Int( "$"+Text[n..n+2] ) )
					n:+2
				Case "u"
					descaped :+ Chr( Int( "$"+Text[n..n+4] ) )
					n:+4
				Default
					' Invalid encoded character, so ignore
				End Select
				n:+1
			Default
	DebugStop
				descaped :+ Text[n..n+1]
				n:+1
			End Select
		Wend
		Return descaped
	End Method

EndType

Type TCachedPattern Extends TPattern


	'Method GetMatch:TMatchResult( doc:TTextDocument, parent:TParseNode, start:Int=0, depth:Int=0 ) Abstract
	Method GetMatch:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )

		If context.verbose; Print( "? "+typeof()+" is using the cache" )
		' Perform a cache lookup first
		If context.memotable
			' Lookup in memo table
			Local memo:TMemoEntry = context.memotable.get( start, ID )
			If memo
				If context.verbose; Print( "? Retrieved match for "+typeof()+" from cache at "+memo.position )
				Return New TMatchResult( memo.position, Null, memo.node ) 
			EndIf
		
			' Left-Recursion Protection
			' We create a "NULL" to force left recursion to fail
			'DebugStop
			If context.verbose; Print( "? Adding Left-Recursion protection for "+typeof()+" at "+start )
			context.memotable.add( start, ID, Null )
		EndIf
	
		' Perform a match
		Local match:TMatchResult = Matcher( context, parent, start, depth )	
		Assert match<>Null, Typeof()+".Matcher() failed with null result"

		' Return successful match
		If match.node
			If context.verbose; Print( "? Matched '"+typeof()+"' at "+start )
			' Update the memotable cache with a succesful match
			context.memotable.add( start, ID, match.node )
			Return match
		EndIf

		' When there is no match, Label informs us what to do.
		
		' Normal failure (label is NULL) means we simply backtrack
		If Not match.label
			If context.verbose; Print( "? No match at "+start+"; backtracking..." )		
			Return match
		EndIf
		
		' Error recovery
		Local recovery:TPattern = context.grammar[match.label]
		Raiseif( Not recovery, "label '"+match.label+"' is not defined in grammar" )
		
		If context.verbose; Print( "? No match at "+start+"; preforming error recovery..." )
		Local error:TMatchResult = recovery.Matcher( context, parent, start, depth )
		Return error		
	EndMethod

End Type

