Rem 
STANDARD OPERATORS

	AndPredicate:  &e                  TAndPredicate
	Choice:        e1 / e2 / e3 / ...  TChoice
	Group:         (e)                 TGroup
	NotPredicate:  !e                  TNotPredicate
	OneOrMore:     e+                  TOneOrMore
	Optional:      e?                  TOptional
	Range:         []                  TRange (Allowed ranges of characters)
	Sequence:      e1 e2 e3 ...        TSequence
	ZeroOrMore:    e*                  TZeroOrMore

EXTENDED OPERATORS

	CharSet:       []                  TCharSet (Allowed selection of characters)

End Rem

' Initialise the TRange component
TRange.initialise()

' ANDPREDICATE == &e 
' Matches expression but does not consume
' Returns FALSE if expression does not match
Type TAndPredicate Extends TPattern
	
	Field pattern:TPattern	' One pattern required
	
	Method New( pattern:TPattern )
		allocate( typeof() )
		Self.pattern = pattern
	End Method

	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
		Local result:TMatchResult = pattern.getMatch( context, parent, start, depth+1 )
		Assert result<>Null, "TAndPredicate received NULL match from "+pattern.typeof()
		If Not result.node; Return FAIL( start )
		Return SUCCESS( Self, start, start )
	End Method
	
	Method toPEG:String()
		Return applyPEGLabel( "&" + pattern.toPEG() )
	End Method

	Method generate:String( tab:String )
		Local str:String = tab + "ANDPRED( "
		str :+ ".."+pattern.generate( tab+"~t" )+".."
		str :+ tab+")"
		Return str
	End Method

EndType

' Any Character (.)
' Returns success unless at end of input
Type TAny Extends TCachedPattern
	
	Method New()
		allocate( typeof() )
	End Method

	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
		' Fail at EOI. This is useful because we can detect EOI using !.
		If start >= context.doc.content.Length; Return FAIL( start )
		Return SUCCESS( Self, start, start+1 )
	End Method
	
	Method toPEG:String()
		Return applyPEGLabel( "." )
	End Method

	Method generate:String( tab:String )
		Return tab+"ANY()"
	End Method

EndType

' A Capture simply extracts text from the pattern inserting it into a parsenode.
' If you dont use this; you need to extract it using getPosition()
' TCAPTURE IS NOT CACHED
Type TCapture Extends TPattern

	Field pattern:TPattern

	Method New( pattern:TPattern )
		allocate( typeof() )
		Self.pattern = pattern
	End Method

	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
		Local result:TMatchResult = pattern.getMatch( context, parent, start, depth+1 )
		Assert result<>Null, "TCapture received NULL match from "+pattern.typeof()
		' Extract captured text
		If result.node; result.node.captured = context.doc.content[result.node.start..result.node.finish]
		Return result
	End Method

	Method toPEG:String()
		Return applyPEGLabel( "$"+pattern.toPEG() )
	End Method

	Method generate:String( tab:String )
		Local str:String = tab+"CAPTURE( .."
		str :+ tab+ pattern.generate( tab+"~t" ) + " .."
		str :+ tab+")"
		Return str
	End Method

EndType

' A Charset scans a set of allowed characters
Type TCharSet Extends TPattern

	Field allowed:String	' Allowed characters

	Method New( charset:String )
		allocate( typeof() )
		Self.allowed = charset
	End Method

	Method New( charset:String[] )
		allocate( typeof() )
		Self.allowed = "".join( charset )
	End Method

	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
		If start>context.doc.content.Length; Return FAIL(start)	' EOI always fails
		Local ch:Int = context.doc.content[start]
		For Local c:Int = EachIn allowed
			If ch=c
'				ShowMatch( start, start+1, "MATCH:TCharSet("+ch+")" )
'				Return Success( start, start+1, Null )
				Return SUCCESS( Self, start, start+1 )
			End If
		Next
		Return FAIL( start )
	End Method
	
'	Method AsString:String()
'		'DebugStop
'		Local tid:TTypeId = TTypeId.forobject( Self )
'		Local name:String = tid.name()
'		name :+ "["+escape(allowed)+"]"
'		'DebugStop
'		Return TTypeId.forobject( Self ).name()+"["+escape(allowed)+"]"
'	End Method

	Method toPEG:String()
		Local str:String = escape(allowed)
		str = str.Replace( " ", "\x20" )
		'If str.Length = 1; Return str
		Return applyPEGLabel( "["+str+"]" )
	End Method

	Method generate:String( tab:String )
		Local str:String = tab+"CHARSET( ~q"+escape(allowed)+"~q )"
		Return str
	End Method

End Type

' CHOICE == e1 / e2 
' Choice is successful when any one of its children is successful, 
' fails when ALL children fail.
' V1.0
Type TChoice Extends TPattern

	Field patterns:TPattern[] = []	' Multiple patterns

	Method New( patterns:TPattern[] )
		allocate( typeof() )
		Self.patterns = patterns
	End Method
	
	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
		Local pos:Int = start
		Local count:Int = 1
		For Local pattern:TPattern = EachIn patterns
'			Local result:TParseNode = doc.match( pattern, parent, caller, pos, depth+1, traceback )
			Local result:TMatchResult = pattern.getMatch( context, parent, pos, depth+1 )
			Assert result<>Null, "TChoice received NULL match from "+pattern.typeof()
			If result.node
				' Treat as a failure if the result start & finish are equal
				' This occurs when a ZeroOrMore() (or Negate) is placed in a choice forcing it to
				' be successful in not finding something. The choice is then successful causing a loop!
'				doc.set_farthest( result.finish )
'				ShowMatch( start, result.finish, "MATCH:CHOICE("+pattern.AsString()+")" )
'
				Return result
			EndIf
			count :+ 1
		Next
		Return FAIL( start )
	End Method
	
'	Method AsString:String()
'		Local str:String
'		For Local pattern:TPattern = EachIn patterns
'			str :+ ","+pattern.AsString()
'		Next
'		
'		Return TTypeId.forobject( Self ).name()+"["+str[1..]+"]}"
'	End Method

	Method toPEG:String()
		Local list:String[] = New String[ patterns.Length ]
		'For Local pattern:TPattern = EachIn patterns
		For Local n:Int = 0 Until patterns.Length
			If Not patterns[n]; Continue	' Shouldn't ever have NULL patterns!
			list[n] = patterns[n].toPEG()
		Next
		Local str:String = " / ".join( list )
		Return applyPEGLabel( str )
	End Method
	
	' Write expression using parser functions
	Method generate:String( tab:String )
		Local str:String = tab + "CHOICE([.."
		If patterns
			For Local pattern:TPattern = EachIn patterns
				str :+ pattern.generate( tab+"~t" ) + ", .."
			Next
		End If
		' Strip trailing ", .."
		str = str[..(str.Length-4)] + " .."+tab+"])"
		Return str
	End Method
	
EndType

' GROUP == ( e )
' A Group simply returns the status of its "only" child.
Type TGroup	Extends TPattern

	Field pattern:TPattern	' One pattern required

	Method New( pattern:TPattern )
		allocate( typeof() )
		Self.pattern = pattern
	End Method

	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
		'Local result:TParseNode = doc.match( patterns[0], parent, caller, start, depth+1, traceback )
		Local result:TMatchResult = pattern.getMatch( context, parent, start, depth+1 )		
		Assert result<>Null, "TGroup received NULL match from "+pattern.typeof()
		If Not result.node; Return FAIL( start )
'		doc.set_farthest( result.finish )
'		ShowMatch( start, result.finish, "MATCH:GROUP, "+AsString() )
		Return result
	End Method
	
	Method toPEG:String()
		Return applyPEGLabel( "( "+ pattern.toPEG() + " )" )
	End Method
	
	Method generate:String( tab:String )
		Local str:String = tab + "GROUP( "
		str :+ ".."+pattern.generate( tab+"~t" )
		str :+ tab+")"
		Return str
	End Method
	
EndType

' Literals are keywords that are static
Type TLiteral Extends TCachedPattern

	Field ignorecase:Int = False		' Case sensitive by default
	Field pattern:String				' The literal string we are matching
	Field patternUpper:String			' String used in case insensitive matches
	
	Method New( pattern:String, ignorecase:Int=False )
		allocate( typeof() )
		Self.ignorecase = ignorecase
		Self.pattern    = pattern
		' If we are ignoring case, change pattern so we don't have to later.
		If ignorecase; Self.patternUpper = Upper( pattern )
	End Method

	' getToken is used by EXPECT / ERROR to identify the token that caused an error
'	Method getToken:String()
'		Return "'"+pattern+"'"
'	End Method

	' General pattern matching has been over-ridden by optimised string compare
	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
'		doc.expected_token = pattern
		If start+Len(pattern) > context.doc.content.Length; Return FAIL( Start )	' EOI always fails		
		If ( Not ignorecase And context.doc.content[start..].startswith( pattern ) )..
			Or ( ignorecase And Upper(context.doc.content[start..start+Len(pattern)])=patternUpper )
				'doc.set_farthest( start+Len(pattern) )', pattern )
				'ShowMatch( start, start+Len(pattern), "MATCH:LITERAL('"+pattern+"')" )
				'Return Success( start, start+Len(pattern) )
				Return SUCCESS( Self, start, start+Len(pattern) )
		End If
		Return FAIL( start )
	End Method
	
'	Method AsString:String()
'		Return TTypeId.forobject( Self ).name()+"{Case-"+["","in"][ignorecase]+"sensitive}["+pattern+"]"
'	End Method

	Method toPEG:String()
		Return applyPEGLabel( Chr(34) + escape(pattern) + Chr(34) + ["","i"][ignorecase] )
	End Method

	Method generate:String( tab:String )
		Local str:String = tab+"LITERAL( "
		str :+ "~q"+escape(pattern)+"~q"
		If ignorecase; str :+ ", True"
		str :+ " )"
		Return str
	End Method
	
EndType

' A NON-TERMINAL is a reference that is looked up at runtime
' Non-Terminal must NEVER use the cache, so we use a basic TPattern here
Type TNonTerminal Extends TPattern

	Field name:String			' Name of rule to lookup
	'Field grammar:TDictionary	' Grammar used for lookup
	Field pattern:TPattern		' Cached runtime pattern lookup
	
	Method New( name:String ) ', grammar:TDictionary )
		allocate( typeof() )
		Self.name    = name
		'Self.grammar = grammar
	End Method

Rem
	' Non-0terminal must NEVER use the cache, so we overwrite this here to prevent it being used
	Method GetMatch:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
		
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
EndRem

	' getToken is used by EXPECT / ERROR to identify the token that caused an error
'	Method getToken:String()
'		Return "Nonterminal '"+name+"'"
'	End Method

	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
'DebugStop
		If context.verbose; Print( "? Matching NON-TERMINAL '"+name+"'" )
		If Not context.grammar
			If context.verbose; Print( "? No grammar defined. Unable to lookup non-terminal" )
			Return FAIL( start )
		EndIf
'		doc.expected_token = name
		If Not pattern; pattern = context.grammar[name]
		If Not pattern; Throw( "Grammar rule ' "+name+"' is not defined" )
'DebugStop
		Local result:TMatchResult = pattern.getMatch( context, parent, start, depth+1 )
		Assert result<>Null, "TNonTerminal received NULL match from "+pattern.typeof()
		'Local result:TParseNode = doc.match( pattern, parent, caller, start, depth+1, traceback )
		If Not result.node; Return result
'		DebugStop
		' SUCCESS
'		doc.set_farthest( result.finish )
		' Name the result with the rule that was used to identify it.
		If Not result.node.name; result.node.name = name
'DebugStop
'		ShowMatch( start, result.finish, "MATCH:NONTERMINAL("+name+") = '"+doc.extract(start, result.finish)+"'" )
		Return result	
	End Method
	
'	Method AsString:String()
'		'DebugStop
'		If Not pattern; pattern = TPattern(grammar[name])
'		If Not pattern; Return "TNonTerminal("+name+")==Null"
'		Return TTypeId.forobject( pattern ).name()+"{"+name+"}"
'	End Method
	
	Method toPEG:String()
		Return applyPEGLabel( name )
	End Method

	' We use a generator static function called __() for this one
	Method generate:String( tab:String )
		Local str:String = tab + "__( ~q"+name+"~q )"
		Return str
	End Method

EndType

' NOTPREDICATE == !e
' Success if pattern not found, Failure if pattern found
' Does not consume anything
Type TNotPredicate Extends TCachedPattern

	Field pattern:TPattern	' One pattern required
	
	Method New( pattern:TPattern )
		allocate( typeof() )
		Self.pattern = pattern
	End Method

	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
'DebugStop
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
		'Local result:TParseNode = doc.match( pattern, parent, caller, start, depth+1, traceback )
		Local result:TMatchResult = pattern.getMatch( context, parent, start, depth+1 )
		Assert result<>Null, "TNotPredicate received NULL match from "+pattern.typeof()
		
		' We must fail if a match was found...
		If result.node; Return FAIL( start )	'Fail on Match found

		' Success on Match NOT found (result.node=null)
		'result = Success( start, start ) 
		Return SUCCESS( Self, start, start )

		'doc.set_farthest( start )
		'ShowMatch( start, result.finish, "MATCH:NOTPRED"+AsString() )
		'Return result	' FAIL / BACKTRACK
	End Method

	Method toPEG:String()
		Return applyPEGLabel( "!" + Trim( pattern.toPEG() ) )
	End Method
	
	Method generate:String( tab:String )
		Local str:String = tab + "NOTPRED( "
		str :+ ".."+pattern.generate( tab+"~t" )+".."
		str :+ tab+")"
		Return str
	End Method
	
EndType

' ONEORMORE == e+
' Matches One or More patterns
' Success when one or more matches. Fail when no match.
' V1.0
Type TOneOrMore Extends TCachedPattern

	Field pattern:TPattern	' One pattern required
		
	Method New( pattern:TPattern )
		allocate( typeof() )
		Self.pattern = pattern
	End Method

	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
		If context.verbose; Print( "? Matching ONE-OR-MORE at "+start )
		Local children:TParseNode[]
		Local pos:Int = start
		Repeat
			'Local result:TParseNode = doc.match( pattern, parent, caller, pos, depth+1, traceback )
			Local result:TMatchResult = pattern.getMatch( context, parent, pos, depth+1 )
			Assert result<>Null, "TOneOrMore received NULL match from "+pattern.typeof()
			If Not result.node
				If pos = start; Return result
				'doc.set_farthest( pos )
'				ShowMatch( start, pos, "MATCH:ONEORMORE "+AsString() )
				'Return New TParseNode( Self, 0, start, pos, children )
				Return SUCCESS( Self, start, pos, children )
			End If
			' Continue matching
			children :+ [ result.node ]
			pos = result.node.finish
		Forever

	End Method

	Method toPEG:String()
		Return applyPEGLabel( "(" + pattern.toPEG() + ")+" )
	End Method
	
	Method generate:String( tab:String )
		Local str:String = tab + "ONEORMORE( "
		str :+ ".."+pattern.generate( tab+"~t" )+".."
		str :+ tab+")"
		Return str
	End Method

EndType

' Optional - Always returns TRUE!
' OPTIONAL == e?
' V1.0
' Sometimes referred to as the ZEROORONE rule
Type TOptional Extends TPattern

	Field pattern:TPattern	' One pattern required
		
	Method New( pattern:TPattern )
		allocate( typeof() )
		Self.pattern = pattern
	End Method

	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
		'Local result:TParseNode = doc.match( pattern, parent, caller, start, depth+1, traceback )
		Local result:TMatchResult = pattern.getMatch( context, parent, start, depth+1 )
		Assert result<>Null, "TOptional received NULL match from "+pattern.typeof()
		If result.node
			'doc.set_farthest( result.finish )
			'ShowMatch( start, result.finish, "MATCH:OPTIONAL, "+AsString() )
			'Return New TParseNode( Self, kind, start, result.finish, [result] )
			Return SUCCESS( Self, start, result.node.finish, [result.node] )
		Else
			'doc.set_farthest( start )
			'Return New TParseNode( Self, kind, start, start, [] )
			Return FAIL( start )
		End If
	End Method

	Method toPEG:String()
		Return applyPEGLabel( pattern.toPEG() + "?" )
	End Method
	
	Method generate:String( tab:String )
		Local str:String = tab + "OPTIONAL( "
		str :+ ".."+pattern.generate( tab+"~t" )
		str :+ tab+")"
		Return str
	End Method

EndType

' A Range takes one or more ranges and builds a list of characters
' Note: "-" has special meaning; if you need to include it place it
' at the start or end otherwise it is treated as a range indicator.
Type TRange Extends TCharSet

	Global ascii8:String	' Lookup table
	
	Field init:String		

	Function initialise()
		If ascii8; Return
		ascii8 = " "[..256]
		For Local n:Int=0 To 255
			ascii8[n] = n
		Next
	End Function

	Method New( range:String )
		allocate( typeof() )
		Self.init = range
		Local p:Int = 0
		Local Length:Int = Len(range)
		Local start:Int, finish:Int
		Repeat
			Select True
			Case p=Length
				Exit
			Case p=0 And range[p]=45
				allowed :+ "-"
				p :+ 1
			Case p+3<=Length And range[p+1]=45
				start = range[p]
				finish = range[p+2]+1
				If start<=finish; allowed :+ ascii8[ start..finish ]
				p :+ 3
			Default
				allowed :+ range[p..p+1]
				p :+ 1
			End Select
		Forever
	End Method

	Method toPEG:String()
'TODO: Compress sequential characters
		Return applyPEGLabel( "["+init+"]" )
	End Method
	
	Method generate:String( tab:String )
		Local str:String = tab+"RANGE( ~q"+escape(init)+"~q )"
		Return str
	End Method
		
End Type

' SEQUENCE == [ e1, e2, e3 ... ]
' A Sequence is successfull if all its children are successfull.
' Fails If any one of its children fail.
Type TSequence Extends TCachedPattern

	Field patterns:TPattern[] = []	' Multiple pattern required
	
	Method New( patterns:TPattern[] )
		allocate( typeof() )
		Self.patterns = patterns
	End Method
	
	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
		If context.verbose; Print( "? Matching SEQUENCE at "+start )
		Local children:TParseNode[]
		Local pos:Int = start
		Local count:Int = 1
		For Local pattern:TPattern = EachIn patterns
			If context.verbose; Print( "? Matching SEQUENCE "+count+" at "+start )
			'Local result:TParseNode = doc.match( pattern, parent, caller, pos, depth+1, traceback )
			Local result:TMatchResult = pattern.getMatch( context, parent, pos, depth+1 )
			Assert result<>Null, "TSequence received NULL match from "+pattern.typeof()

			' If any one fails, then the match fails
			'If result.failed(); Return result
			If Not result.node; Return result			
			'If Not result; Return Null	'result

			' Only add children that have content
			If result.node.finish > result.node.start
				children :+ [ result.node ]
				pos = result.node.finish
			End If
			count :+1
		Next
		If context.verbose; Print( "? SEQUENCE at "+start+ " matched sucecssfully" )
		'doc.set_farthest( pos )
'		ShowMatch( start, pos, "MATCH:SEQUENCE, "+AsString() )
'		Return New TParseNode( Self, 0, start, pos, children )
		Return SUCCESS( Self, start, pos, children )
	End Method
	
'	Method AsString:String()
'		Local str:String
'		For Local pattern:TPattern = EachIn patterns
'			str :+ ","+pattern.AsString()
'		Next
'		Return TTypeId.forobject( Self ).name()+"["+str[1..]+"]"
'	End Method

	Method toPEG:String()
		Local str:String
'		If Not patterns; Return "()"
		For Local pattern:TPattern = EachIn patterns
			str :+ " "+pattern.toPEG()
		Next
'		Return "("+str+" )"
		Return applyPEGLabel( str )
	End Method
	
	' Write expression using parser functions
	Method generate:String( tab:String )
		Local str:String = tab + "SEQUENCE([.."
		If patterns
			For Local pattern:TPattern = EachIn patterns
				str :+ pattern.generate( tab+"~t" ) + ", .."
			Next
		End If
		' Strip trailing ", .."
		str = str[..(str.Length-4)] + " .."+tab+"])"
		Return str		
	End Method
		
EndType

' Symbols are single static ASCII characters
Type TSymbol Extends TCachedPattern

	Field pattern:String
	Field Length:Int
	
	Method New( pattern:String )
		allocate( typeof() )
		Self.pattern = pattern
		Self.Length  = Len( pattern )
	End Method

	Method New( pattern:Int )
		allocate( typeof() )
		Self.pattern = Chr(pattern)
		Self.Length  = 1
	End Method
	
	Method set( pattern:String )
		Self.pattern = pattern
		Self.Length  = Len( pattern )
	End Method
	
	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
'DebugStop
		If start>context.doc.content.Length; Return FAIL(start)	' EOI always fails
		'Local ch:String = doc.content[start..(start+Length)]
		If ( context.doc.content[start..(start+Length)] = pattern )
			'doc.set_farthest( start+Length )
			'ShowMatch( start, start+Length, "MATCH:SYMBOL("+Asc(ch)+")" )
			'Return Success( start, start+Length )
			Return SUCCESS( Self, start, start+Length, [] )
		End If
		
'DebugStop
'Local result:TMatchResult = FAIL(start)
'Return result
		Return FAIL( start )
	End Method

'	Method AsString:String()
'		Return TTypeId.forobject( Self ).name()+"["+escape(pattern)+"]"
'	End Method
	
	Method toPEG:String()
		'If Length=1; Return escape( pattern ).
		Return applyPEGLabel( Chr(34)+escape(pattern)+Chr(34) )
	End Method

	Method generate:String( tab:String )
		Local str:String = tab+"SYMBOL( ~q"+escape(pattern)+"~q )"
		Return str
	End Method

EndType

' ZEROORMORE == e*		(Kleene Operator)
' Matches Zero or More patterns
' V1.0
Type TZeroOrMore Extends TPattern

	Field pattern:TPattern	' One pattern required

	Method New( pattern:TPattern )
		allocate( typeof() )
		Self.pattern = pattern
	End Method

	Method Matcher:TMatchResult( context:TParseContext, parent:TParseNode, start:Int=0, depth:Int=0 )
	'Method Matcher:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
		Local children:TParseNode[]
		Local pos:Int = start
		Local detector:Int = start

		Repeat
			'Local result:TParseNode = doc.match( pattern, parent, caller, pos, depth+1, traceback )
			Local result:TMatchResult = pattern.getMatch( context, parent, pos, depth+1 )
			Assert result<>Null, "TZeroOrMore received NULL match from "+pattern.typeof()

			' A "null" result is also considered a success otherwise it leads to
			' an infinite loop
			If Not result.node 'Or ( result.start = result.finish )
'				doc.set_farthest( pos )
'				If start<>pos; ShowMatch( start, pos, "MATCH:ZEROORMORE('"+AsString()+"')" )
				Return SUCCESS( Self, start, pos, children )
			End If
			children :+ [ result.node ]
			pos = result.node.finish
						
			'DebugStop
			' INFINATE LOOP DETECTION
			If pos = detector
				Print "## INFINITE LOOP DETECTED"
				DebugStop
				Throw( "INFINITE LOOP" )
'				'Local list:String
'				If children And children.Length > 0
'					traceback :+ "~n"
'					For Local n:Int = 0 Until children.Length
'						Local child:TParseNode = children[n]
'						'DebugStop
'						traceback :+ " "+(n+1)+": @("+child.start+".."+child.finish+"), NAME='"+child.named+"', VALUE='"+child.captured+"', {"+child.describe()+"}~n"
'						' ".AsString()+"~n"
'					Next
'				End If
'				Throw New TInfiniteLoop( "ZEROORMORE", pattern.AsString(), traceback )
			End If
			detector = pos
		Forever
	End Method

	Method toPEG:String()
'		If Not pattern; Throw( "#ERR#" )
		Return applyPEGLabel( pattern.toPEG() + "*" )
	End Method
	
	Method generate:String( tab:String )
		Local str:String = tab + "ZEROORMORE( "
		str :+ ".."+pattern.generate( tab+"~t" )+".."
		str :+ tab+")"
		Return str
	End Method

EndType

