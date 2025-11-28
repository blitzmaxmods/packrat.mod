'
' This type uses a Visitor to construct PEG from a parse tree

Function ParseTree2PEG:String( tree:TParseTree )
	DebugStop
	Local visitor:IVisitor = New TParseTree2PEG( tree )
	DebugStop
	
End Function

Type TParseTree2PEG Implements IVisitor

	Method New( parseTree:TParseTree )
	
		Local root:TParsenode = parsetree.getroot()
	
		For Local node:TParsenode = EachIn root.byname("RULE")
			Print "RULE: "+node.name()
			
			DebugStop
		Next
	
		' Visit the parsetree
		'parsetree.accept( Self )
		
		For Local node:TParsenode = EachIn root.preorder()
			Local name:String = node.name()
			If Not name; name = "<empty>"
			Print "# "+name+":"+TTypeId.forobject( node ).name() 
			'DebugStop
			node.accept( Self )
		Next
		
	End Method

	Function ParseTree2PEG( parseTree:TParseTree )
		Local PEG:String

		For Local rule:TParseNode = EachIn parseTree.ByName( "RULE" )
			DebugStop
			Print rule.ToString()
			DebugStop
		Next

	End Function

	'Method visit:Int( sequence:TParsenode )
	'	Print "TParsenode"
	'	DebugStop
	'End Method

	'Method visit:Int( sequence:TSequence )
	'	Print "SEQUENCE"
	'	DebugStop
	'End Method

	Method visit:Int( visitable:IVisitable )
		'DebugStop
		
		Local node:TParseNode = TParseNode( visitable )
		If Not node
			DebugLog "Invalid visitable detected"
			Return False
		End If
		
		Local name:String = node.name()
		If Not name; name = "<empty>"
		Print "VISITING:  "+name+":"+TTypeId.forObject(node).name()
		Print "  ASSTRING:"+node.AsString().Replace("~n","")
		'Print "  TOPEG:   "+node.toPeg()
		
		'DebugStop
		'If children

	End Method


	Method getPEG:String()
	End Method
	
End Type