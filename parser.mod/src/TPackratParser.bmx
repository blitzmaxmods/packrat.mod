' TPackrat_Parser
' (c) Copyright Si Dunford [Scaremonger], 2023-date, All rights reserved.
' VERSION 1.0
'
' A Packrat parser. This will be extended to support a specific language

' PARSER OPTION BITS
'Const PARSEOPT_VERBOSE:Int        = $0001	'0000 0000 0000 0001	Verbose Processing
'Const PARSEOPT_NO_MEMOISATION:Int = $0002	'0000 0000 0000 0010	Disable Memoisation



Type TPackratParser

'	Global DEBUGGER:Int = False			' Enables the parser debugger
	
	Public Field grammar:TGrammar
	
	Private
	
	'Field document:TTextDocument
	Field context:TParseContext
'	Field memo:TMemoisation
	
'	Field options:Int = 0
	Field verbose:Int = False	' How much output is provided
	
'	Field this:TTypeId			' This is a Reflection of self

	Public 
	
'	Method New( name:String, start:String = "START", options:Int=0 )
'		grammar = New TGrammar( name, start )
'		setoptions( options )
'	End Method

	Method New( grammar:TGrammar )
		Self.grammar = grammar
	End Method

'	Method New( grammar:TGrammar, options:Int )
'		Self.grammar = grammar
'		setoptions( options )
'	End Method

'	Method New( options:Int )
'		setoptions( options )
'	End Method

'	Method errorcount:Int()
'		If Not document; Return -1
'		Return document.errors.Length
'	End Method

	' Get the current memotable
	Method getMemotable:TMemoisation()
		If Not context; Return Null
		Return context.memotable
	End Method
	
	' Get PEG definition
	Method getPEG:String()
		If Not grammar; Return ""
		return grammar.toPEG()
	EndMethod

	' Get the grammar name tied to this parser
	Method name:String()
		Return grammar.name
	End Method

	' Parse source using grammar into a Parse Tree
	Method parse:TParseTree( source:String, startrule:String="" )
		Return parse( New TTextDocument( source ), startrule )
		'Return parse( New TTextDocument( source, options ), startrule )
	End Method
	
	' Parse document using grammar into a Parse Tree
	Method parse:TParseTree( document:TTextDocument, startrule:String="" )
DebugStop
		' Create a parsing context using the source and starting rule
		context = New TParseContext( document, grammar, True, verbose )
		'If verbose; context.setVerbose()
		'Return New TParseTree( document.match( start, Null, Self ) )
		Local tree:TParseTree = New TParseTree( document.match( context ) )

		Return tree
	End Method
	
'	Public Method Notify( event:TEvent )
'	
'		Local message:String = String( event.extra )
'		If document
'			message = message.Replace( "{POS}", document.getPosition( event.data ).format() )
'			message = message.Replace( "{TOKEN}", document.getToken( event.data ) )
'		Else
'			message = message.Replace( "{POS}", event.data )
'			message = message.Replace( "{TOKEN}", "" )
'		End If
'		
'		'DebugStop
'		Print "ERROR: "+message
'		
'	End Method

	' Gets the currently implemented grammer
'	Public Method getGrammar:TGrammar()
'		Return Self.grammar
'	End Method

	' Merge or replace the existing grammar
'	Public Method setGrammar( grammar:TGrammar, Replace:Int=True )
		
		'DebugStop
		
'		If Replace
'			Self.grammar = grammar
'			Return
'		End If
		
'		For Local key:String = EachIn grammar.keys()
'			Local pattern:TPattern = grammar[key]
'			Self.grammar[key] = pattern
'		Next
	
'	End Method

	' Enumerator to allow looping through the grammar rules
'	Method rules:TMapEnumerator()
'		Return grammar.keys()
'	End Method
	
'	Private

	' Shortcut method to get a grammar object
'	Method __:TPattern( name:String )
'	'DebugStop
'		Assert grammar.contains( name ), "Undefined Pattern '"+name+"' in definition"
'		Return grammar.nonTerminal( name )
'	End Method

'	Public
	
	' Validate the rules
	Method validate()
		Assert grammar, "Grammar is not defined"
		For Local rule:String = EachIn grammar.keys()
			Local pattern:TPattern = TPattern( grammar[rule] )
			Assert pattern, "Rule '"+rule+"' is declared but not defined in '"+grammar.name+"'"
		Next
	End Method
	
	' Convert a start position into a line/column
	
	' There are a number of ways this can be done:
	' 1. Loop thorough source counting CRLF and calculate line length
	' 2. Extract all CRLF's in the latest parsetree and work out position of last
	' 3. Loop through parsetree summing lines
'	Public Method getPosition:TPosition( pos:Int )
'		Return document.getPosition( pos )
'		'DebugStop
'		Rem
'		Local line:Int = 1, last:Int
'		For Local n:Int = 0 Until Min( pos, Len(source) )
'			'Local x:Int = source[n]
'			If source[n]=$0A
'				line :+ 1
'				last = n
'			End If
'		Next
'		Return New TPosition( line, pos-last )
'		EndRem
'	End Method
	
'	Method setoptions( options:Int )
'		Self.options = options	' Save so we can pass it to the text document
'		Self.verbose = ( options & PARSEOPT_VERBOSE ) > 0
'		DebugStop
'	End Method

	' Debug the memotable
'	Method showMemotable()
'		Print( "~nMEMOTABLE:" )
'		If context.memotable
'			context.memotable.showSelf()
'		Else
'			Print "- Does not exist"
'		EndIf
'	End Method

	Method setVerbose( state:Int = True )
		verbose = state
	End Method
	
End Type

' Diagnostic function to show when and where a match is made
'Function showMatch( start:Int, finish:Int, Text:String )
'	Local line:String = " "[..start]+"^"
'	Local size:Int = finish-start
'	If size>1; line :+ Replace(" "[..size-2]," ","-")+"^"
'	Print line + " " + Text
'End Function