'	TParseNode
'	(c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
'	VERSION 1.0
'
'	A ParseNode is a node in the Parse Tree

Type TParseNode 'Extends VNode Implements IVisitable ',IViewable

	Private Field name:String		' Named capture
	'Public Field kind:String		' The type of node
	
	Public Field start:Int			' First character in match
	Public Field finish:Int			' Last character in match
	Public Field captured:String	' Text captured by a pattern
'	Public Field value:String		' Text captured by a pattern

	Public Field children:TParseNode[]

Private 

	Public Method New( pattern:TPattern, kind:String, start:Int, finish:Int, children:TParseNode[]=[] )
'DebugStop ' DO WE NEED KIND HERE?
		'Self.kind = kind
		Self.start = start
		Self.finish = finish
		Self.children = children
	End Method
		
'	Public Method New( pattern:TPattern, kind:Int, start:Int, finish:Int, children:TParseNode[]=[] )
'DebugStop ' DO WE NEED KIND HERE?
'If kind>0; 
'DebugLog( "WARNING: TParseNode.new() is attempting to set kind as INT" )
'		Self.kind = "ID:"+kind
'		Self.start = start
'		Self.finish = finish
'		Self.children = children
'	End Method

	' Get the match start and finish
	' ANDPRED, NOTPRED etc do not consume data and therefore this may return an empty string
	Public Method getPosition( start:Int Var, finish:Int Var )
		start  = Self.start
		finish = Self.finish
	End Method
		
'	Public Method getCapture:String()
'		Return captured
'	End Method

	' Confirm if match found
	' This does not work for lookahead as they do not consume any data
	'Public Method found:Int()
	'	If finish>0 And finish>start; Return True
	'	Return False
	'End Method

'	Public Method name:String()
'		Return named
'	End Method
	
	' Get the captured value of this node
'	Public Method value:String()
'		Return captured
'	End Method
	
'	Public Method AsString:String( padding:Int=0 )
'		Local pad:String = " "[..padding]
'		Local str:String = pad+KINDSTR[ kind ]+": "+start+".."+finish
'		If captured; str :+ ", Captured='"+captured+"'"
'		If children
'			str :+ ", Children: "+ children.Length
'			str :+ "~n"
'			For Local child:TParseNode = EachIn children
'				str :+ child.AsString( padding+1 ) + "~n"
'			Next
'		End If
'		Return str
'	End Method

	' Return a formatted text tree 
	Rem
		ONE
		+-TWO
		| +-THREE
		| +-FOUR
		| | +-FIVE
		| | +-SIX
		| +-SEVEN
		+-EIGHT
		  +-NINE
	End Rem
'	Public Method getTextTree:String( doc:TTextDocument, depth:Int=0 ) ', lastchild:Int=False )
'		Local str:String = " "[..depth*2]
'		str :+ doc.getPosition( start ).format() + ".." + doc.getPosition( finish ).format()
'		str :+ KINDSTR[ kind ]+": "+start+".."+finish
'		If captured; str :+ ", Captured='"+captured+"'"
'		If children
'			str :+ ", Children: "+ children.Length
'			str :+ "~n"
'			For Local child:TParseNode = EachIn children
'				str :+ child.getTextTree( doc, depth+1 ) + "~n"
'			Next
'		End If
'		Return str
'	End Method
'	
'	Public Method getTree:String( depth:Int=0 )
'		'DebugStop
'		Local str:String = " "[..depth*2]
'		'str :+ start+".."+finish+", "
'		str :+ KINDSTR[ kind ]+": "+start+".."+finish
'		If named; str :+ ", Named='"+named+"'"
'		If captured; str :+ ", Captured='"+captured+"'"
'		'str :+ ",value='"+text[start..finish]+"'"
'		If children
'			str :+ ", Children: "+ children.Length
'			str :+ "~n"
'			For Local child:TParseNode = EachIn children
'				str :+ child.getTree( depth+1 ) + "~n"
'			Next
'		End If
'		Return str	
'	End Method
'	

	'Public Method kindStr:String()
	'	Return kind
	'End Method

	' Debug the node as a tree
	Public Method reveal:String( tab:String="" )
		Local data:String = describe()
		If Not data; Return ""
		'Local str:String = LSet(start,3)+"-"+LSet(finish,3)+" "+tab+"NAME='"+name+"', KIND="+KINDSTR[ kind ]+", VALUE='"+captured+"': "+data+"~n"
		'Local str:String = LSet(start,3)+"-"+LSet(finish,3)+" "+tab+"NAME='"+name+"', VALUE='"+value+"': "+data+"~n"
		Local str:String = LSet(start,3)+"-"+LSet(finish,3)+" "+tab+"NAME='"+name+"'" ': "+data+"~n"
		For Local n:Int = 0 Until children.Length
			Local child:TParseNode = children[n]
			str :+ child.reveal( tab+"  " )
		Next	
		Return str
	End Method

	Public Method describe:String()
		Local descr:String 
		If name; descr :+ name
		'DebugStop
		For Local child:TParsenode = EachIn children
			Local str:String = child.describe()
			If str
				If str.startswith("|")
					descr :+ str
				Else
					descr :+ "|"+str
				End If
			End If
		Next
		Return descr
	End Method
	
'	' IViewable
'	Public Method getText:String[]()
'		Local data:String '= doc.content[start..finish]
'		data = data.Replace("~n","\n")
'		data = data.Replace("~r","\r")
'		data = data.Replace("~t","\t")
'		data = data.Replace(" ","\s")
'	
'		Local str:String[]
'		str :+ ["NAMED:    "+named]
'		str :+ ["POSITION: "+start+".."+finish]
'		str :+ ["KIND:     "+kind+ " "+KINDSTR[kind]]
'		str :+ ["CAPTURE:  "+captured]
'		'str :+ ["PATTERN:  "+patid]
'		str :+ ["VALUE:    "+data]
'		Return str
'	End Method
	
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
		Return New TSearchEnumerator( Self, name )
	End Method

'	Public Method ByKind:TSearchEnumerator( kind:Int )
'		Return New TSearchEnumerator( Self, kind )
'	End Method
			
	'	TREE-WALKING METHODS
	'	https://en.wikipedia.org/wiki/Tree_traversal
	
'	Public Method inOrder:TInOrderEnumerator()
'		Return New TInOrderEnumerator( Self )
'	End Method

'	Public Method preorder:TPreOrderEnumerator()
'		Return New TPreOrderEnumerator( Self )
'	End Method
'
'	Public Method postorder:TPostOrderEnumerator()
'		Return New TPostOrderEnumerator( Self )
'	End Method

	
End Type

