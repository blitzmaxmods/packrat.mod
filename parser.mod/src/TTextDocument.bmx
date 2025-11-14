' A Text document is used as the lookup between the source and result

Type TTextDocument

	Field content:String	' The raw document content

	' Memoisation
	'Field memotable:TMemoisation
	'Field memoenabled:Int = True		' Enable / Disable memoisation
	'Field grammar:TGrammar

	Method New( content:String ) ', options:Int=0 )
		Self.content = content
		'memotable = New TMemoisation()
		'DebugStop
'		setoptions( options )
	End Method

	' Entry point for all Parsing
	' Simple matching: Called by TPattern.match()
	' Parsing:         Called by TPackratParser.parse()

	Method match:TMatchResult( context:TParseContext, parent:TParseNode=Null, start:Int=0, depth:Int=0 )
		Raiseif( context.grammar=Null, "context.grammar is NULL" )
		
		' Get starting pattern from grammar
		'Local pattern:TPattern = context.grammar.getStartRule()

		'# Get initial rule and start processing
		Local startrule:String = context.grammar.getStart()
		Local pattern:TPattern = context.grammar.nonTerminal( startrule )
		
		' If we don't have a valid starting rule, then abort
		If Not pattern
			Throw New TPackratBadStart( startrule )
'			'Throw New TMissingRule( startrule )
'			'start = New TError( zeroOrmore( any() ), "Start rule '"+grammar.getStart()+"' is not defined in '"+grammar.name+"'" )
'			'Local pattern:TPattern = New TZeroOrMore( New TAny() )
'			'start = New TError( pattern, "Start rule '"+startrule+"' is not defined in '"+grammar.name+"'" )
		End If
		If context.verbose; Print( "? Start rule '"+startrule+"' selected." )
		
		' Perform a pattern match
		Local result:TMatchResult = pattern.getMatch( context, parent, start, depth )
		Assert result<>Null, "TTextDocument received NULL match"
'DebugStop		
		' Complete
		Return result
	End Method

		
' DEPRECIATED
	' Document matcher that uses the memo table to improve parsing speed
	'Method match:TParseNode( pattern:TPattern, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
Rem
	Method match:TMatchResult( pattern:TPattern, parent:TParseNode, start:Int=0, depth:Int=0 )
Print( "DEPRECIATED: match:TMatchResult( pattern:TPattern, parent:TParseNode, start:Int=0, depth:Int=0 )" )
		' Catch pattern ID issue
		Assert pattern.kind>PATTERN_NONE, "Pattern kind should never be 0"
DebugStop ': memoptable cache should Not be done here.
		If memoenabled
			' Lookup in memo table
			Local memo:TMemoEntry = memotable.get( pattern.kind, start )
			
			If memo
'DebugStop ' YAY - We fixed it! :)
				'position = memo.position
Print( "TTextDocument: Using memo result" )
				Return New TMatchResult( memo.position, Null, memo.node ) 
			EndIf
		
			' Left-Recursion Protection
			' We create a "NULL" to force left recursion to fail
			'memo = New TMemoEntry( Null, start )
			memotable.set( pattern.kind, start, Null )
		EndIf
		
		'
		'Local result:TParseNode = pattern.getMatch( Self, parent, caller, start, depth, traceback )
		Local result:TMatchResult = pattern.getMatch( Self, parent, start, depth )
		Assert result<>Null, "Value of TMatchResult should never be NULL"
		
		' No match found - Backtrack
		DebugStop ' WHAT DO WE RETURN?
		If Not result.label; Return result
		'If Not result; Return Null
		
		DebugStop ' Is this where we check label and do error recovery?
		
		' Match found
		memotable.set( pattern.kind, start, result.node )
		Return result

	End Method
EndRem

	' Error recovery
	Method recover:TMatchResult( result:TMatchResult, start:Int, depth:Int )
		' If there is no label, we simply backtrack (Normal error)
		If Not result.label; Return result
	End Method

	' Set an error
	' Depreciated, error nodes are added to the parsetree
'	Method setError( Text:String )
'		errors:+ [Text]
'	End Method

	' Set an error, uting a template
	' Depreciated, error nodes are added to the parsetree
'	Method setError( template:String, node:TPattern, pos:Int )
'		Local position:TPosition = getposition(pos)
'		Local Text:String = template.Replace( "{pos}", position.ToString() )
'		'text = text.Replace( "{identifier}", node.identifier() )
'		'DebugStop
'		If Instr( Text, "{show}" )
'			Local start:Int = lines[position.line-1]
'			Local eol:Int = lines[position.line]
'			Local line:String = content[start..eol].Replace("~t"," ").Replace("~n","").Replace("~r","")
'			'position.line
'			'DebugStop
'			Text = Text.Replace( "{show}", "~n "+line+"~n"+ (" "[..position.col])+"^~n" )
'		End If
'		errors:+ [Text]
'	End Method
	
'	Method setOptions( options:Int )
'		memoenabled = Not( options & PARSEOPT_NO_MEMOISATION )
'		Local this:TTextDocument = Self
'		DebugStop
'	End Method

End Type