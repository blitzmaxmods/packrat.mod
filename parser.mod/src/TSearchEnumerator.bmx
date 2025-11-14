

Type TSearchEnumerator

	Field list:TList
	
	' Search by name
	Method New( node:TParseNode, name:String )
		list = New TList()
		walk( node, name )
	End Method
	
	' Search by kind
	Method New( node:TParseNode, kind:Int )
		list = New TList()
		walk( node, kind )
	End Method

	Method walk( node:TParseNode, name:String )
		'DebugStop
		For Local child:TParseNode = EachIn node.children
			walk( child, name )
		Next
'If node.name=""
'DebugStop	' Do we have an issue here; name should be the rule
'EndIf
		If node.name = name; list.addlast( node )
	End Method
		
'	Method walk( node:TParseNode, kind:Int )
'		'DebugStop
'		For Local child:TParseNode = EachIn node.children
'			walk( child, kind )
'		Next
'		If node.kind = kind; list.addlast( node )
'	End Method
	
	Method ObjectEnumerator:TListIterator()
		'DebugStop
		Return New TListIterator( list )
	End Method
	
End Type


' Visit all the children execpt the last, then to parent
' then the last child.
' Primarily this should be used on Binary trees!
Type TInOrderEnumerator

	Field list:TList
	
	Method New( node:TParseNode )
		list = New TList()
		walk( node )
	End Method
	
	Method walk( node:TParseNode )
		Local lastchild:Int = node.children.Length
		' ADD LEFT CHILDREN SUBTREES
		For Local i:Int = 0 Until lastchild-1
			walk( node.children[i] )
		Next
		' ADD SELF
		list.addlast( node )
		' ADD RIGHT CHILD SUBTREE
		If lastchild>1; walk( node.children[lastchild-1] )
	End Method

	Method ObjectEnumerator:TListIterator()
		Return New TListIterator( list )
	End Method

End Type

Type TPreOrderEnumerator 'Implements IEnumerator

	Field list:TList

	Method New( node:TParseNode )
		list = New TList()
		' Build stack from tree
		Local todo:TList = New TList()
		todo.addlast( node )
		While Not todo.isEmpty()
			node = TParseNode( todo.removeFirst() )
			list.addlast( node )
			For Local i:Int = 0 Until node.children.Length
				todo.addlast( node.children[i] )
			Next
		Wend
	End Method

	Method ObjectEnumerator:TListIterator()
		Return New TListIterator( list )
	End Method

End Type

Type TPostOrderEnumerator

	Field list:TList

	Method New( node:TParseNode )
		list = New TList()
		walk( node )
	End Method

	Method walk( node:TParseNode )
		For Local i:Int = 0 Until node.children.Length
			walk( node.children[i] )
		Next	
		list.addlast( node )
	End Method

	Method ObjectEnumerator:TListIterator()
		Return New TListIterator( list )
	End Method

End Type

Type TListIterator
	Field list:TList

	Method New( list:TList )
		Self.list = list
	End Method
	
	Method hasnext:Int()
		Return Not list.isEmpty()
	End Method
	
	Method nextObject:Object()
		Return list.removefirst()
	End Method
End Type	
