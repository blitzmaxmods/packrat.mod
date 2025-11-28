'	TParseTree
'	(c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
'	VERSION 1.0
'
'	A ParseTree is the result of parsing a source file with a given grammar.

'   CHANGES:
'   DD MMM YYYY  V1.0  First version
'

Type TParseTree ' Extends TParseNode

	'Field startrule:String = "BEGIN"
	Field root:TParseNode
	
	'Method New( startrule:String, root:TParseNode = Null )
	Method New( root:TParseNode = Null )
		'Self.startrule: String = startrule
		Self.root = root
	End Method

	Method getRoot:TParseNode()
		Return root
	End Method
	
	Method setRoot( root:TParseNode )
		Self.root = root
	End Method

	Method hasRoot:Int()
		Return Not(root = Null)
	End Method
		
	'Method AsString:String()
	'	If root; Return root.AsString()
	'End Method
	
	Method getTextTree:String( doc:TTextDocument )
		If root; Return root.getTextTree( doc )
	End Method

	Method getTree:String()
		If root; Return root.getTree()
	End Method
	
	' Override TParsenode to use specific root instead.
	Method ByName:TSearchEnumerator( name:String )
		If root; Return root.byname( name )
	End Method
	
	' Override TParsenode to use specific root instead.
	Method ByKind:TSearchEnumerator( kind:Int )
		If root; Return root.byKind( Kind )
	End Method
	
	Method hasErrors:Int()
		If Not root; Return False
		For Local error:TParseNode = EachIn byname("ERROR")
			Return True
		Next
		Return False
	End Method
	
	' Only use this if you need the error count without errors
	' It is more efficient to get the errors and count them
	Method errorcount:Int()
		If Not root; Return 0
		Local count:Int = 0
		For Local error:TParseNode = EachIn byname("ERROR")
			count :+ 1
		Next
		Return count
	End Method

	Method getErrors:TParseError[]()
		If Not root; Return Null
		Local list:TParseError[] = []
		For Local error:TParseNode = EachIn byname("ERROR")
			list :+ [New TParseError( error.value(), error.start, error.finish )]
		Next
		Return list
	End Method

	' Extract Grammar from a parseTree
	Method extractGrammar:TGrammar()
		DebugStop
		
		'For Local rule:TParseNode = EachIn Self.byName("RULE")
		'	DebugStop
		'Next
		If Not root; Return Null
		'
		'
DebugStop ' I need an efficient VISITOPR And tree walker here.

		' Wrap visitor to catch reflection exceptions that simply report "ERROR"
		Try
'			visit( root, Self , "extract_grammar" )
		Catch e:String
			If e="ERROR"
				Throw New TReflectionException()
			Else
				Throw New TStringException( e )
			EndIf
		Catch e:Object
			Throw e
		End Try
		
	EndMethod
	
	' IVisitable
	'Public Method accept:Int( visitor:IVisitor )
	'	Return visitor.visit( Self )
	'End Method
	
	' Debug tool - Builds a textual tree
	Method reveal:String()
		If Not root; Return "NO ROOT"
		Return root.reveal()
	End Method
	
	'Method _buildtree:String( node:TParsenode, depth:Int = 0 )
	'	Local tab:String = " "[..depth*2]
	'	Local tree:String = node.name + ":" + node.typeof()
	'	Local children:TParsenode[] = node.getChildren()
	'	For Local child:TParseNode = EachIn children
	'		tree :+ _buildtree( child, depth + 1 )
	'	Next
	'	Return tree
	'End Method

End Type

Type TGift
	Field node:VNode
	Field data:Object
	Field prefix:String
	Method New( node:VNode, data:Object, prefix:String )
		Self.node = node
		Self.data = data
		Self.prefix = prefix
	End Method
EndType