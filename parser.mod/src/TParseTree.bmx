'	TParseTree
'	(c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
'	VERSION 1.0
'
'	A ParseTree is the result of parsing a source file with a given grammar.

'   CHANGES:
'   DD MMM YYYY  V1.0  First version
'

Type TParseTree ' Extends TParseNode

	Field root:TParseNode

	' Create new tree using the node from the match result
	Method New( result:TMatchResult )
'DebugStop
		If result And result.node; Self.root = result.node
	End Method
	
'	Method New( root:TParseNode = Null )
'		Self.root = root
'	End Method

'	Method getRoot:TParseNode()
'		Return root
'	End Method
	
'	Method setRoot( root:TParseNode )
'		Self.root = root
'	End Method

	Method invalid:Int()
		Return root = Null
	End Method

	Method valid:Int()
		Return Not(root = Null)
	End Method
		
'	Method getTextTree:String( doc:TTextDocument )
'		If root; Return root.getTextTree( doc )
'	End Method

'	Method getTree:String()
'		If root; Return root.getTree()
'	End Method
	
	Method ByName:TSearchEnumerator( name:String )
		If root; Return root.byname( name )
	End Method
	
'	Method ByKind:TSearchEnumerator( kind:Int )
'		If root; Return root.byKind( Kind )
'	End Method
	
'	Method hasErrors:Int()
'		If Not root; Return False
'		For Local error:TParseNode = EachIn byname("ERROR")
'			Return True
'		Next
'		Return False
'	End Method
	
	' Only use this if you need the error count without errors
	' It is more efficient to get the errors and count them
'	Method errorcount:Int()
'		If Not root; Return 0
'		Local count:Int = 0
'		For Local error:TParseNode = EachIn byname("ERROR")
'			count :+ 1
'		Next
'		Return count
'	End Method

'	Method getErrors:TParseError[]()
'		If Not root; Return Null
'		Local list:TParseError[] = []
'		For Local error:TParseNode = EachIn byname("ERROR")
'			list :+ [New TParseError( error.value(), error.start, error.finish )]
'		Next
'		Return list
'	End Method

	' Extract Grammar from a parseTree
'	Method extractGrammar:TGrammar()
'		DebugStop
'		
'		'For Local rule:TParseNode = EachIn Self.byName("RULE")
'		'	DebugStop
'		'Next
'		If Not root; Return Null
'		'
'		'
'DebugStop ' I need an efficient VISITOPR And tree walker here.
'
'		' Wrap visitor to catch reflection exceptions that simply report "ERROR"
'		Try
''			visit( root, Self , "extract_grammar" )
'		Catch e:String
'			If e="ERROR"
'				Throw New TReflectionException()
'			Else
'				Throw New TStringException( e )
'			EndIf
'		Catch e:Object
'			Throw e
'		End Try
'		
'	EndMethod
	
	' Debug tool - Builds a textual tree
	Method reveal:String()
		If Not root; Return "NO ROOT"
		Return root.reveal()
	End Method
	
End Type

'Type TGift
'	Field node:VNode
'	Field data:Object
'	Field prefix:String
'	Method New( node:VNode, data:Object, prefix:String )
'		Self.node = node
'		Self.data = data
'		Self.prefix = prefix
'	End Method
'EndType
