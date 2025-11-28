

' A Packrat pattern matcher

Type TPackMatch

	Field root:TParseNode
	Field Text:String

	Public Method New( node:TParseNode, Text:String )
		Self.Text = Text
		If node.children.Length = 0
			If node.finish > 0 ; root = New TParsenode( Null, 0, node.start, node.finish, [node] )
		Else
			root = node
		EndIf
	End Method
	
	Public Method subCount:Int()
		If Not root; Return 0
		Return root.children.Length
	EndMethod

	' Return an expression as text
	Public Method subExp:String( index:Int )
debugstop
		If Not root; Return ""
		If index<0 Or index>root.children.Length; Return ""
		Local start:Int = root.children[ index ].start
		Local finish:Int = root.children[ index ].finish
		Return Text[start..finish]
	EndMethod
	
	' IViewable
'	Public Method getChildren:IViewable[]()
'		Local list:IViewable[] = []
'		If children
'			For Local item:IViewable = EachIn children
'				list :+ [ item ]
'			Next
'		End If
'		Return list
'	End Method

	' IVisitable
'	Public Method accept:Int( visitor:IVisitor )
'		Return visitor.visit( Self )
'	End Method

	' SEARCH

	Public Method ByName:TSearchEnumerator( name:String )
		Return New TSearchEnumerator( root, name )
	End Method

	Public Method ByKind:TSearchEnumerator( kind:Int )
		Return New TSearchEnumerator( root, kind )
	End Method
			
	'	TREE-WALKING METHODS
	'	https://en.wikipedia.org/wiki/Tree_traversal
	
	Public Method inOrder:TInOrderEnumerator()
		Return New TInOrderEnumerator( root )
	End Method

	Public Method preorder:TPreOrderEnumerator()
		Return New TPreOrderEnumerator( root )
	End Method

	Public Method postorder:TPostOrderEnumerator()
		Return New TPostOrderEnumerator( root )
	End Method

End Type


