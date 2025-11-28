' A Text document is used as the lookup between the source and result


Type TPosition
	Field line:Int = 0
	Field col:Int = 0
	
	Method New( line:Int, col:Int )
		Self.line = line
		Self.col = col
	End Method
	
	Method format:String()
		Return "("+line+":"+col+")"
	End Method
	
	Method ToString:String()
		Return line+":"+col
	End Method
	
End Type

' INTERNAL USE ONLY!

Type TTextDocument

	' Cache of line numbers
	Field lines:Int[]
	Field content:String
	
	Field tree:TParseTree
	
	Field errors:String[]
	
	Field memotable:TMemoisation
	Field memoenabled:Int = True		' Enable / Disable memoisation
	
	' Parsing tokens used for error reporting
	Field farthest_point:Int = 0
	Field expected_token:String = ""

	Method New( content:String, options:Int=0 )
		Self.content = content
		memotable = New TMemoisation()
		'DebugStop
		setoptions( options )
	End Method

	Method reset_farthest()
		farthest_point = 0
		expected_token = ""
	End Method

	Method extract:String( start:Int, finish:Int )
		Return content[start..finish]
	End Method

	Method set_farthest( point:Int, token:String="" )
		If point <= farthest_point; Return
		farthest_point = point
		If token; expected_token = token
	End Method

	Method error( Text:String )
		errors:+ [Text]
	End Method

	Method error( template:String, node:TPattern, pos:Int )
		Local position:TPosition = getposition(pos)
		Local Text:String = template.Replace( "{pos}", position.ToString() )
		'text = text.Replace( "{identifier}", node.identifier() )
		'DebugStop
		If Instr( Text, "{show}" )
			Local start:Int = lines[position.line-1]
			Local eol:Int = lines[position.line]
			Local line:String = content[start..eol].Replace("~t"," ").Replace("~n","").Replace("~r","")
			'position.line
			'DebugStop
			Text = Text.Replace( "{show}", "~n "+line+"~n"+ (" "[..position.col])+"^~n" )
		End If
		errors:+ [Text]
	End Method

	Method getPosition:TPosition( error:TParseError )
		Return getPosition( error.start )
	End Method
	
	Method getPosition:TPosition( pos:Int )
		'DebugStop
		'Print "FINDING POS '"+pos+"'"
		'Assert pos<=content.length, "Invalid position "+pos+" is not within document!"
		Local line:Int
		If lines.Length = 0
'Print "- Creating cache"
			' Create cache
			lines :+ [0]
			For Local n:Int = 0 Until content.Length
				'Print( content[n] )
				If content[n] = 10; lines :+ [n+1]
				If pos = n; line = lines.Length
			Next
			'For Local n:Int = 0 Until lines.length
			'	Print "LINE "+n+" @"+lines[n]
			'Next
			'DebugStop
			lines :+ [content.Length]
			Return New TPosition( line, pos-lines[line-1]+1 )
		Else
'Print "- Using cache"
			' Use cache
			For Local line:Int = 1 Until lines.Length
				If pos< lines[line]; Return New TPosition( line, pos-lines[line-1]+1 )
			Next
			'DebugStop
			Return New Tposition(1,pos)
		End If
	End Method

	Method gettoken:String( start:Int )
		'DebugStop
		Local finish:Int = start
		'Local ch:String = content[finish]
		Repeat
			finish:+1
			'ch = content[finish]
		Until content[finish] > 32 Or finish>content.Length
		Local Text:String = content[start..finish]
		Text = Text.Replace(" ","\s")
		Text = Text.Replace("~r","\r")
		Text = Text.Replace("~n","\n")
		Text = Text.Replace("~t","\t")
		Text = Text.Replace(Chr(34),"\q")
		Return "'"+Text+"'"
	End Method

	Method parse( parser:TPackratParser, startrule:String = "" )
		tree = parser.parse( Self, startrule )
	End Method
	
	Method getTextTree:String()
		If tree; Return tree.getTextTree( Self )
	End Method
	
	' Document matcher that uses the memo table to improve parsing speed
	Method match:TParseNode( pattern:TPattern, parent:TParseNode, caller:TPackratParser=Null, start:Int=0, depth:Int=0, traceback:String="" )

		If pattern.ruleid > 0 And memoenabled
			' Lookup in memo table
	'DebugStop '- THIS ALWAYS FAILS!!
			Local memo:TMemoEntry = memotable.get( pattern.ruleID, start )
			If memo
	'DebugStop ' YAY - We fixed it! :)
				'position = memo.position
				Print( "TTextDocument: Using memo result" )
				Return memo.result
			EndIf
		
			' Left-Recursion Protection
			' We create a "NULL" to force left recursion to fail
			'memo = New TMemoEntry( Null, start )
			memotable.set( pattern.ruleID, start, Null )
		EndIf
		
		'
		Local result:TParseNode = pattern.getMatch( Self, parent, caller, start, depth, traceback )
		If Not result; Return Null
		'memo.result = result
		'memo.position = start
		memotable.set( pattern.ruleID, start, result )
				

		'DebugStop		
		Return result

Rem
		DebugStop
		Local result:TParsenode = memotable.Apply( pattern.ruleID, start )
		If result
			' Use memotable
			DebugStop
			Return result
		EndIf
		' Run full match
		result = pattern.getMatch( Self, caller, start, depth, traceback )
		If Not result; retun Null
EndRem
	End Method

	Method setOptions( options:Int )
		memoenabled = Not( options & PARSEOPT_NO_MEMOISATION )
'		Local this:TTextDocument = Self
'		DebugStop
	End Method
	
End Type