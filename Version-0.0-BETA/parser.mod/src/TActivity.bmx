
'Interface IActionCallback
'	Method actioncall:TParseNode( action:String, node:TParseNode )
'EndInterface

' ACTIVITY == {action [args]} 
' Always returns SUCCESS when an action matches
' Calls an action using reflection
Type TActivity Extends TPattern

	Field name:String
	'Field action:Object
	
	Method New( name:String, action:Object )
		Self.name   = Lower(name)
		'Self.action = action
		Self.patterns = [ ..
			New TSequence([ ..
				TPattern( New TSymbol("{") ), ..
				New TCapture( New TOneOrMore( New TRange("A-Za-z_") ) ), ..
				TPattern( New TSymbol("}") ) ..				
			]) ] 
			'				New TSymbol("{"), ..
'				'New TLiteral( name, True ) ..
'				New TSequence([ ..
'					New TRange("A-Za-z_") ..
'				]) ..

	
			'	New TSymbol(" "), ..
			'	New TSequence([ ..
			'		New TRange("A-Za-z_"), ..
			'		New TOneOrMore( New TRange("A-Za-z_0-9") ) ]), ..
			'	New TSymbol("}") ..
	End Method

	Method getMatch:TParseNode( doc:TTextDocument, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )
		traceback :+ "/ACTIVITY"
'Print( " "[..start]+"^ "+start+"/ANDPRED" )
DebugStop
		Local result:TParseNode = doc.match( patterns[0], parent, caller, start, depth+1, traceback )
		If Not result; Return Null
		
		doc.set_farthest( start )
		
DebugStop ' Need to identify action and call the callback function
		
		' GET ACTION NAME
		' This is always the first element after the leading "{"
		Local children_count:Int = Len(result.children)
		If children_count<3; Return result
		Local action_name:String = result.children[1].captured	'.value()
		'result.captured = action_name

DebugStop	' why is caller or parent null?

		' EXECUTE ACTION
		If Not parent Or Not caller; Return result
		'Local callback:IActionCallback = IActionCallback( caller )

		' If a result contains an action then we need to evaluate it
DebugStop		
		' Typecast callback
		'Local callback:IActionCallback = IActionCallback( caller )
		'If Not callback; Return result
		'Print "CALLBACK IS SET"

DebugStop				
		Print "EXECUTE ACTION: "+action_name+"()"
		DebugStop ' THIS DOES NOT WORK HERE, NEEDS PARENT OBJECT
		caller.actioncall( action_name, parent )
		'Return callback.actioncall( action_name, result )

'Print "EXECUTE ACTION: "+action_name+"()"
'If callback
'	Print "CALLBACK IS SET"
'	DebugStop ' THIS DOES NOT WORK HERE, NEEDS PARENT OBJECT
'	callback.actioncall( action_name, result.children[1..children_count-1] )
'Else
'	Print "CALLBACK IS NOT SET"
'EndIf
'DebugStop
		'ShowMatch( start, result.finish, "MATCH:ACTIVITY("+action_name+")" )

DebugStop
		Return result
	End Method
	
	Method PEG:String()
DebugStop
		Return "{action}"
	End Method

	Method generate:String( tab:String )
DebugStop
		Return "ACTIVITY()"
	End Method

EndType



