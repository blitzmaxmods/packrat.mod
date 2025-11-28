'   TMemoisation
'   (c) Copyright Si Dunford, MMM 2022, All Rights Reserved. 
'   VERSION: 1.0

'	Memoisation support for Packrat parser.
'	This is an optimisation that gives a packrat parser the ability
'	to achieve unlimited backtracking in linear time.

'	Memoisation also provides an answer for left recursion issues
'	by returning FAIL when recursion is detected.

'   CHANGES:
'   21 OCT 2023  Initial Creation using Array
'	04 JAN 2025  Updated to use TIntMap, chnage SMemoEntry to TMemoEntry
'
'	FURTHER READING
'		http://www.vpri.org/pdf/tr2007002_packrat.pdf

Type TMemoisation

	'Private Field memotable:SMemoEntry[][] = [ [ New SMemoEntry() ] ]
	Private Field memotable:TIntMap = New TIntMap()

	'Private Const FAIL
	Private Field expand:Int = 10

	Public Method New()
	End Method

Rem
	Public Method New( expansion:Int = 10 )
		Print "TMemoisation; NEW()"
		expand = expansion
		grow( expand, expand )
	End Method
	
	Public Method grow( x:Int, y:Int )
		'DebugStop
		Print "TMemoisation; GROW FROM X="+memotable[0].Length+", Y="+memotable.Length+" TO X="+x+", Y="+y
		Local rows:Int = memotable.Length
		Local cols:Int = memotable[0].Length
		If y>rows
			' Grow table
			memotable = memotable[..y]
			' Resize new rows
			For Local row:Int = rows Until y
				memotable[row] = New SMemoEntry[x]
			Next
		EndIf
		If x>cols
			' Expand existing rows
			For Local row:Int = 0 Until cols
				memotable[row] = memotable[row][..x] 
			Next
		EndIf
		Print "TMemoisation; SIZE IS X="+memotable[0].Length+", Y="+memotable.Length
	EndMethod
EndRem

Rem Moved into TTextDocument.match()
	Public Method Apply:TParseNode( rule:Int, position:Int )
		Local memo:SMemoEntry
		If Not get( memo, rule, position )
			' Left-Recursion Protection
			memo = New sMemoEntry( fail(), position )
			set( rule, position, memo )
			'
			Local result:TParseNode = Null 'EVAL( rule.body )
			memo.result = result
			memo.position = position
			set( rule, position, memo )
			Return result
		Else
			position = memo.position
			Return memo.result
		End If

	EndMethod
EndRem	

'	Private
	
'	Method fail:TParseNode()
'		DebugStop
'		' Need to insert something to identify failure
'		Return New TParseNode()
'	End Method
	
	Method get:TMemoEntry( ruleID:Int, position:Int )
		'DebugStop
		' Get Rule from memo
		Local rule:TIntMap = TIntMap( memotable.valueforKey( ruleID ) )
		If Not rule; Return Null
		' Get Memo from rule
		Return TMemoEntry( rule.valueforkey( position ) )
	End Method
	 
	Method set:Int( ruleID:Int, position:Int, memo:TParseNode )
'DebugStop
		Local newrule:Int = False
		' Get Rule from memo
		Local rule:TIntMap = TIntMap( memotable.valueforKey( ruleID ) )
		' If this is a new rule; create it
		If Not rule
			rule = New TIntMap()
			memotable.insert( ruleid, rule )
			newrule = true
		EndIf
		' Set rule
		rule.insert( position, New TMemoEntry( memo, position ) )
		Return newrule
	End Method
	
End Type

Type TMemoEntry
	Field result:TParseNode
	Field position:Int
	
	Method New( result:TParseNode, position:Int )
		Self.result = result
		Self.position = position
	End Method
	
EndType
