

Type TGrammar Extends TDictionary
	Private Field COUNTER:Int = 0			' Unique "RULE NUMBER" used by memoisation

	Public
	
	Field name:String = "UNDEFINED"	' Name of the grammar
	Field start:String = "START"	' Starting rule name
	
	Method New( name:String, start:String = "START" )
		Super.New()
		Self.name  = name
		Self.start = start
	
	End Method

	' 28 DEC 2024 - Added Helper Function for single patterns
	Method declare( pattern:String )
		'declare([pattern])
		If contains(pattern); Throw "Pattern '"+pattern+"' already exists and cannot be re-declared"
		Self[pattern] = "DECLARED"
	End Method

	' Declare rules to allow reference before definition
	Method declare( patterns:String[] )
		For Local pattern:String = EachIn patterns
			'Print( "DECLARING '"+pattern+"'" )
			'If contains(pattern); Print "- Already defined"
			If contains(pattern); Throw "Pattern '"+pattern+"' already exists and cannot be re-declared"
			Self[pattern] = "DECLARED"
		Next
	End Method

	Method setStart( start:String )
		Self.start = start
	End Method

	Method getStart:String()
		Return start
	End Method

'	Method getStartRule:TPattern()
'		Local link:TLink = TLink( index.valueforkey( Self.start ) )
'		If link; Return TPattern( link.value() )
'		Return Null
'	End Method
	
	'Method getrule:TPattern( name:String )
	'	Return TPattern( Self[ name ] )
	'End Method
	
	'Method StartRule:TPattern()
	'	Return New TNonTerminal( start, Self )
	'	'Return TPattern( Self[ start ] )
	'End Method
	
	' Non-Terminal runtime lookup
	Method NonTerminal:TPattern( name:String )
		Return New TNonTerminal( name )
	End Method

	' Shortcut to NonTerminal
	Method __:TPattern( name:String )
		Assert Self.contains( name ), "Undefined Pattern '"+name+"' in definition"
		Return New TNonTerminal( name )
	End Method

	' Get a key
	Method Operator []:TPattern( key:String )
		Local link:TLink = TLink( index.valueforkey( key ) )
		If link; Return TPattern( link.value() )
		Return Null
	End Method

	' Set a key
	Method Operator []=( key:String, value:TPattern )
		Local link:TLink
		' Delete old record and update it
		If index.contains( key )
			link = TLink( index.valueforkey( key ) )
			link.remove()
		End If
		' Create a new key
		'value.name = key				' Rules are always named
'		value.ruleID = allocRuleID()	' Allocate rule ID
		link = list.addlast( value )
		index[key] = link
	End Method
	
	Method toPEG:String( showHidden:Int = False )
		Local peg:String = "# PEG Definition for "+name+"~n#~n# Starting rule: "+start+"~n~n"
		For Local rulename:String = EachIn Self.keys()
			Local rule:TPattern = TPattern( Self[rulename] )
			If rule.hidden And Not showHidden; Continue
			peg :+ rulename + " <- " + rule.toPEG() + "~n"
		Next
		Return peg
	End Method

	Private
	
	Method allocRuleID:Int()
		COUNTER :+ 1
		Return COUNTER
	End Method

End Type



