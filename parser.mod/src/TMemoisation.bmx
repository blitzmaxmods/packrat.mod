'   TMemoisation
'   (c) Copyright Si Dunford, OCT 2022, All Rights Reserved. 
'   VERSION: 1.0

'	Memoisation (Cache) support for Packrat parser.
'	This is an optimisation that gives a packrat parser the ability
'	to achieve unlimited backtracking in linear time.

'	Memoisation also provides an answer for left recursion issues
'	by returning FAIL when recursion is detected.

'   CHANGES:
'   21 OCT 2023  Initial Creation using Array
'	04 JAN 2025  Updated to use TIntMap, change SMemoEntry to TMemoEntry
'	13 NOV 2025  Swapped arrays so POSITION is Outer and ID is Inner, added showSelf()
'
'	FURTHER READING
'		http://www.vpri.org/pdf/tr2007002_packrat.pdf

Type TMemoisation

	Private Field memotable:TIntMap = New TIntMap()
	Private Field expand:Int = 10
	Private Field verbose:Int = False

	Public Method New( verbose:Int = False )
		Self.verbose = verbose
	End Method

	Public Method add:Int( position:Int, ID:Int, node:TParseNode )
'DebugStop
		'Assert ID>0, "Cache reference ID=0 cannot be indexed"
		'DebugStop
		If verbose
			If node
				Print "CACHE.ADD( POS:"+position+", ID:"+ID+" ) => "+node.name+"{"+node.start+".."+node.finish+"}" '+node.value
			Else
				Print "CACHE.ADD( POS:"+position+", ID:"+ID+" ) => NULL (Left recursion protection)"
			EndIf
		EndIf
		Local newrule:Int = False
		' Get Rule from memo
		Local pos:TIntMap = TIntMap( memotable.valueforKey( position ) )
		' If this is a new POS record; create it
		If Not pos
			If verbose; Print( "  - Creating record for position "+position )
			pos = New TIntMap()
			memotable.insert( position, pos )
			newrule = True
		ElseIf verbose
			Print( "  - Using existing record for position "+position )
		EndIf
		' Set rule
		pos.insert( ID, New TMemoEntry( node, position ) )
		Return newrule
	End Method

	Public Method get:TMemoEntry( position:Int, ID:Int )
		'DebugStop
		' Get list of objects cached at this position
		Local pos:TIntMap = TIntMap( memotable.valueforKey( position ) )
		If Not pos
			If verbose; Print "CACHE.GET( POS:"+position+", ID:"+ID+" ) = None (Not found in cache)"
			Return Null
		EndIf
		' Get Memo from rule
		Local result:TMemoEntry = TMemoEntry( pos.valueforkey( id ) )
		If verbose
			If result And result.node
				If verbose; Print "CACHE.GET( POS:"+position+", ID:"+ID+") => "+result.node.name+"{"+result.node.start+".."+result.node.finish+"}" '+result.node.value
			Else
				Print "CACHE.GET: POS:"+position+", ID:"+ID+" => NULL (Left recusion protection)"
			EndIf
		End If
		Return result
	End Method
	 
	Method setVerbose( verbose:Int = True )
		Self.verbose = verbose
	End Method
	
	' Output the memotable for debugging
	Public Method showSelf()
		'DebugStop
		Local data:String[][] 
		data :+ [[ "POS", "KIND","NODE.NAME", "START", "FINISH", "CAPTURED" ]]
		data :+ [[ "~t" ]]
		For Local pos:TIntKey = EachIn memotable.keys()
			Local kind:TIntMap = TIntMap( memotable.valueForKey( pos.value ) )
			For Local id:TIntKey = EachIn kind.keys()
				Local result:TMemoEntry = TMemoEntry( kind.valueforkey( id.value ) )
				Local kindstr:String = id.value+"/"+TPattern.lookup(ID.value)
				If result.node
					data :+ [[ String(pos.value), kindstr, result.node.name, String(result.node.start), String(result.node.finish), result.node.captured ]]
				Else
					data :+ [[ String(pos.value), kindstr, "NULL" ]]
				EndIf
			Next
		Next

		showtable( data )
	
		Function getwidths:Int[]( data:String[][] )
			'DebugStop
			Local cols:Int[] = [0]
			For Local y:Int = 0 Until Len( data )
				If data[y][0]="~t"; Continue
				For Local x:Int = 0 Until Len( data[y] )
					'Local c:Int = Len(cols)
					If Len(cols) < x+1; cols :+ [0]
					cols[x] = Max( cols[x], Len( data[y][x] ) )
				Next
			Next
			'Local line:String 
			'For Local n:Int = 0 Until Len(cols)
			'	line :+ ","+cols[n]
			'Next
			'Print line
			Return cols
		End Function
		
		Function showtable( data:String[][] )
			Local cols:Int[] = getwidths( data )
			'DebugStop
			For Local y:Int = 0 Until Len(data)
				Local line:String ="|"
				If data[y][0]="~t"; line = "+"
				For Local x:Int = 0 Until Len( cols )
					If data[y][0]="~t"
						line :+ (" "[..(cols[x]+2)]).Replace(" ","-")+"+"
					Else
						If Len(data[y])>x
							line :+ " "+data[y][x][..cols[x]]+" |"
						Else
							line:+ " "[..(cols[x]+2)]+"|"
						EndIf
					EndIf
				Next
				Print line
			Next
		
		End Function
	End Method
	
End Type

Type TMemoEntry
	Field node:TParseNode
	Field position:Int
	
	Protected Method New( node:TParseNode, position:Int )
		Self.node = node
		Self.position = position
	End Method
	
EndType

' TEST MEMOISATION
Rem
Type TParsenode	' DUMMY - NOT REAL ONE
	Field name:String, start:Int, finish:Int, kind:String
	Method New( name:String, start:Int, finish:Int, kind:String )
		Self.name = name
		Self.start = start
		Self.finish = finish
		Self.kind = kind
	End Method
EndType

Local memo:TMemoisation = New TMemoisation( True )

' Add some dummy data

'memo.set( 0, 0, New TParsenode( "DUMMY", 0, 9, "TExample" ) )	' Cannot add memo with ID=0
memo.add( 0, 0, New TParsenode( "DUMMY-ONE", 0, 9, "TExample" ) )
memo.add( 0, 1, New TParsenode( "DUMMY-TWO", 0, 1, "TSymbol" ) )
memo.add( 1, 2, New TParsenode( "DUMMY-THREE", 1, 2, "TSymbol" ) )

' Show the data
memo.showself()

' Retrieve data at a given position
Local item:TMemoEntry
item = memo.get( 0,0 )
If item; Print item.node.name Else Print "NULL"
item = memo.get( 0,1 )
If item; Print item.node.name Else Print "NULL"
item = memo.get( 1,1 )
If item; Print item.node.name Else Print "NULL"
item = memo.get( 1,2 )
If item; Print item.node.name Else Print "NULL"
EndRem




