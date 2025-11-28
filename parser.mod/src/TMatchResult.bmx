
' This is a result returned by a match operation

Type TMatchResult
	Field errpos:Int		' The point where an error occurred
	Field label:String		' Failure result; NULL=backtrack otherwise it is an error recovery pattern
	Field node:TParseNode	' Node result
	
	Method New( errpos:Int, label:String, node:TParseNode )
		Self.errpos = errpos
		Self.label  = label
		Self.node   = node
	End Method
	
	' This only uses the backtrack result
	Method found:Int( lookahead:Int = False )
		If Not node; Return False
		Return True
	End Method
	
	' Get the match start and finish
	' ANDPRED, NOTPRED etc do not consume data and therefore this may return an empty string
	Method getPosition( start:Int Var, finish:Int Var )
		If Not node; Return
		start  = node.start
		finish = node.finish
	End Method
	
	' The node does not know about the value unless we create a capture
	' so this cannot be a thing. If we start saving the value of every node just so
	' it is available here, we will use as much RAM as the size of the document
	' The best way to get a match value is to create a capture when you need it.
	' Of use the start/finish locations to extract it from the document.
'	Method value:String()
'		If Not node; Return ""
'		Return node.value
'	End Method


	
EndType