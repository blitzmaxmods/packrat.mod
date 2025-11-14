
' Dictionary for indexed lookups.

Type TDictionary 

	Field index:TMap		' Index of TLINK (Into list)
	Field list:TList		' List of TPattern
	
	Method New()
		index = New TMap()
		list  = New TList()
	End Method

'	Method addFirst( key:String, value:Object )
'		index.addFirst( key )
'		list.insert( key, value )		
'	End Method

'	Method addLast( key:String, value:Object )
'		index.addLast( key )
'		list.insert( key, value )		
'	End Method

'	Method first:Object()
'		Return list.valueforkey( String(index.first()) )
'	End Method

	Method count:Int()
		If list; Return list.count()
	End Method

	Method keys:TMapEnumerator() 
		Return index.keys()
	End Method

	Method contains:Int( key:String )
		Return index.contains( key )
	End Method
	
	' Assign a new key
	Method Operator []=( key:String, value:Object )
		Local link:TLink
		' Delete old record and update it
		If index.contains( key )
			link = TLink( index.valueforkey( key ) )
			link.remove()
		End If
		' Create a new key
		link = list.addlast( value )
		index[key] = link
	End Method
	
	' Get a key
	Method Operator []:Object( key:String )
		Local link:TLink = TLink( index.valueforkey( key ) )
		If link; Return link.value()
		Return Null
	End Method
	
End Type
