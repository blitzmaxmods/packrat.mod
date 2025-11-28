
Type TTreeToGrammar 

	Field tree:TParseTree
	Field result:TGrammar


	Field exception_on_missing_method:Int = True
	Field filter:String[]	' Filters the nodes that are allowed
	
	Method New( tree:TParseTree )
		Self.tree = tree
	End Method

	Method grammar:TGrammar( tree:TParseTree = Null )
		If tree; Self.tree = tree
		If Not Self.tree Or Not Self.tree.root; Return Null
		'
		' Wrap visitor to catch reflection exceptions that simply report "ERROR"
		Try
			visit( tree.root, Self )', "visit" )
		Catch e:String
			If e="ERROR"
				Throw New TReflectionException()
			Else
				Throw New TStringException( e )
			EndIf
		Catch e:Object
			Throw e
		End Try
		
	End Method



Rem	Method visit:String( node:TASTNode, prefix:String="visit", indent:String="" )
'DebugStop
		If Not node ThrowException( "Cannot visit null node" ) 
		'If node.name = "" invalid()	' Leave this to use "visit_" method
		
		' Use Reflection to call the visitor method (or an error)
'DebugStop
		Local this:TTypeId = TTypeId.ForObject( Self )
		' The visitor function is defined in metadata 
		Local class:String = this.metadata( "class" )
		If class = "" 
			If node.classname = "" ; Return ""
			class = node.classname
		End If
		Local methd:TMethod = this.FindMethod( prefix+"_"+class )
		If methd
			Local Text:String = String( methd.invoke( Self, [New TVisitorArg(node,indent)] ))
			Return Text
		EndIf
		If exception_on_missing_method ; exception( prefix+"_"+class )
		Return ""
	End Method
End Rem

	Method in:Int( needle:String, haystack:String[] )
		For Local i:Int = 0 Until haystack.Length
			If haystack[i]=needle ; Return True
		Next
		Return False
	End Method

	Method visit( node:TParseNode, mother:Object, prefix:String = "visitor" )
		If Not node ; Return
		
		' We cannot visit a node unless it is named
		Local name:String = node.name()
		If Not name; Return
		
		' Use Reflection to call the visitor method (or an error)
		Local nodeid:TTypeId = TTypeId.ForObject( node )
		
		' The visitor function is defined in metadata or name
		Local class:String '= nodeid.metadata( "class" )
		If class = ""; class=name

DebugStop	
		' Filter nodes
		If filter.Length>0 And Not in( Lower(class), filter ) 
DebugLog( "Filtered '"+class+"'")
			Return
		End If

		' Use Reflection to call the visitor method (or an error)
		Local this:TTypeId = TTypeId.ForObject( Self )
		Local methd:TMethod = this.FindMethod( prefix+"_"+class )
		If methd
			DebugStop
			DebugLog( "Visiting "+prefix+"_"+class+"()" )
			methd.invoke( Self, [node,mother] )
		ElseIf exception_on_missing_method
			Throw New TMissingVisitor( prefix+"_"+class )
		Else
			DebugLog( "Visitor "+prefix+"_"+class+"() is not defined" )
		EndIf

		' Visit children
		For Local child:TParseNode = EachIn node.children
			visit( child, node, prefix )
		Next
		
	End Method

	'Method visitChildren:String( node:TASTNode, prefix:String, indent:String="" )
	'	Local Text:String
	'	Local compound:TASTCompound = TASTCompound( node )
'DebugStop
	'	For Local child:TASTNode = EachIn compound.children
	'		Text :+ visit( child, prefix, indent )
	'	Next
	'	Return Text
	'End Method
	
	Method visitChildren( node:TParseNode, mother:Object, prefix:String )
		Local family:TParseNode = TParseNode( node )
		If Not family ; Return
		If Not family.children Or family.children.Length=0; Return

		For Local child:TParseNode = EachIn family.children
			visit( child, mother, prefix )
		Next
	End Method
	
	' This is called when node doesn't have metadata or a name...
'	Method visit_:String( node:TParseNode, indent:String="" )
'		DebugStop
'		Throw( "Node '"+node.name()+"' has no name!" )
'	End Method
	
'	Method _:String( node:TParseNode, indent:String="" )
'		DebugStop
'		Throw( "Node '"+node.name()+"' has no name!" )
'	End Method
	
	Method visitor_PEG:String( node:TParseNode, mother:Object )
		DebugStop
		Print "PEG:"
	End Method

	Method visitor_comment:String( node:TParseNode, mother:Object )
		DebugStop
		Print "COMMENT:"
	End Method
	
End Type
